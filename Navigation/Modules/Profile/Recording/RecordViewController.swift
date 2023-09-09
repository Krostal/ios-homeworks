
import UIKit
import AVFoundation

protocol RecordViewControllerDelegate: AnyObject {
    func recordViewControllerDidDisappear()
}

final class RecordViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    weak var delegate: RecordViewControllerDelegate?
    
    private lazy var recordButton: UIButton = {
        let recordButton = UIButton(type: .system)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
        recordButton.tintColor = .systemRed
        recordButton.addTarget(self, action: #selector(recordButtonPressed), for: .touchUpInside)
        return recordButton
    }()
    
    private lazy var playButton: UIButton = {
        let playButton = UIButton(type: .system)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setTitle("PLAY", for: .normal)
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        return playButton
    }()
    
    private lazy var permissionLabel: UILabel = {
        let permissionLabel = UILabel()
        permissionLabel.translatesAutoresizingMaskIntoConstraints = false
        permissionLabel.textColor = .black
        permissionLabel.numberOfLines = 0
        permissionLabel.textAlignment = .center
        permissionLabel.textColor = UIColor(named: "AccentColor")
        return permissionLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews()
        setupConstraints()
        setupAudioSession()
        checkMicrophonePermission()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.recordViewControllerDidDisappear()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        view.addSubview(recordButton)
        view.addSubview(playButton)
        view.addSubview(permissionLabel)
    }
    
    private func setupConstraints() {
        
        let safeAreaLayout = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            recordButton.centerXAnchor.constraint(equalTo: safeAreaLayout.centerXAnchor),
            recordButton.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor, constant: -50),
            
            playButton.centerXAnchor.constraint(equalTo: safeAreaLayout.centerXAnchor),
            playButton.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor, constant: -100),
            
            
            permissionLabel.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor, constant: 20),
            permissionLabel.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor, constant: -20),
            permissionLabel.centerXAnchor.constraint(equalTo: safeAreaLayout.centerXAnchor),
            permissionLabel.centerYAnchor.constraint(equalTo: safeAreaLayout.centerYAnchor)
        ])
    }
    
    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }
    
    private func checkMicrophonePermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            permissionLabel.text = "Press record button to record your audio"
        case .denied:
            permissionLabel.text = "Microphone access denied. Please enable access in the app settings"
            playButton.isHidden = true
            recordButton.isHidden = true
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { [weak self] (granted) in
                DispatchQueue.main.async {
                    if granted {
                        self?.permissionLabel.isHidden = true
                    } else {
                        self?.permissionLabel.text = "Microphone access denied. Please enable access in the app settings"
                    }
                }
            }
        default:
            break
        }
    }
    
    internal func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            playButton.isEnabled = true
        } else {
            playButton.isEnabled = false
            print("Audio recording error")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
        
    @objc func recordButtonPressed() {
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
            recordButton.setImage(UIImage(systemName: "record.circle.fill"), for: .normal)
            recordButton.tintColor = .systemRed
            playButton.isEnabled = true
            permissionLabel.text = "Press record button to record your audio"
            permissionLabel.textColor = UIColor(named: "AccentColor")
                
        } else {
            // Начинаем запись
            let audioFilename = getDocumentsDirectory().appendingPathComponent("audioRecording.m4a")
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder?.delegate = self
                audioRecorder?.record()
                recordButton.setImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
                recordButton.tintColor = .gray
                playButton.isEnabled = false
                permissionLabel.text = "Audio recording is in progress"
                permissionLabel.textColor = .gray
            } catch {
                print("Failed to start recording: \(error.localizedDescription)")
            }
        }
    }
        
    @objc func playButtonPressed() {
        guard let audioFilename = audioRecorder?.url else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.delegate = self
            audioPlayer?.play()
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }
}

extension RecordViewController: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
}
