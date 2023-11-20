
import UIKit
import AVFoundation

protocol MusicViewControllerDelegate: AnyObject {
    func musicViewControllerDidDisappear()
}

final class MusicViewController: UIViewController {
    
    private struct Constants {
        static let spacing: CGFloat = 70
    }
    
    weak var delegate: MusicViewControllerDelegate?
    
    var player = AVAudioPlayer()
    
    var currentTrackIndex = 0
    
    let trackNames = ["Imagine Dragons Bones", "Linkin Park Numb", "OneRepublic Secrets", "Sting Shape Of My Heart", "The xx Night Time"]
    
    private lazy var playAndPauseButton: UIButton = {
        let playAndPauseButton = UIButton()
        playAndPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playAndPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playAndPauseButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        return playAndPauseButton
    }()
    
    private lazy var stopButton: UIButton = {
        let stopButton = UIButton(type: .system)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.setTitle("STOP".localized, for: .normal)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        return stopButton
    }()
    
    private lazy var nextTrackButton: UIButton = {
        let nextTrackButton = UIButton()
        nextTrackButton.translatesAutoresizingMaskIntoConstraints = false
        nextTrackButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        nextTrackButton.addTarget(self, action: #selector(nextTrack), for: .touchUpInside)
        return nextTrackButton
    }()
    
    private lazy var previousTrackButton: UIButton = {
        let previousTrackButton = UIButton()
        previousTrackButton.translatesAutoresizingMaskIntoConstraints = false
        previousTrackButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        previousTrackButton.addTarget(self, action: #selector(previousTrack), for: .touchUpInside)
        return previousTrackButton
    }()
    
    private lazy var trackNameLabel: UILabel = {
        let trackNameLabel = UILabel()
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        trackNameLabel.textAlignment = .center
        trackNameLabel.textColor = UIColor(named: "AccentColor")
        return trackNameLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews()
        setupConstraints()
        setupAudioPlayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.musicViewControllerDidDisappear()
    }
    
    private func setupView() {
        view.backgroundColor = ColorPalette.profileBackgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(playAndPauseButton)
        view.addSubview(stopButton)
        view.addSubview(nextTrackButton)
        view.addSubview(previousTrackButton)
        view.addSubview(trackNameLabel)
    }
    
    private func setupConstraints() {
        
        let safeAreaLayout = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            playAndPauseButton.centerXAnchor.constraint(equalTo: safeAreaLayout.centerXAnchor),
            playAndPauseButton.centerYAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor, constant: -150),
            
            stopButton.centerXAnchor.constraint(equalTo: safeAreaLayout.centerXAnchor),
            stopButton.centerYAnchor.constraint(equalTo: playAndPauseButton.centerYAnchor, constant: 50),
            stopButton.heightAnchor.constraint(equalToConstant: 30),
            
            nextTrackButton.centerXAnchor.constraint(equalTo: playAndPauseButton.centerXAnchor, constant: Constants.spacing),
            nextTrackButton.centerYAnchor.constraint(equalTo: playAndPauseButton.centerYAnchor),
            
            previousTrackButton.centerXAnchor.constraint(equalTo: playAndPauseButton.centerXAnchor, constant: -Constants.spacing),
            previousTrackButton.centerYAnchor.constraint(equalTo: playAndPauseButton.centerYAnchor),
            
            trackNameLabel.centerXAnchor.constraint(equalTo: playAndPauseButton.centerXAnchor),
            trackNameLabel.centerYAnchor.constraint(equalTo: playAndPauseButton.centerYAnchor, constant: -Constants.spacing),
            trackNameLabel.leadingAnchor.constraint(lessThanOrEqualTo: safeAreaLayout.leadingAnchor, constant: 20),
            trackNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayout.trailingAnchor, constant: -20),
            trackNameLabel.heightAnchor.constraint(equalToConstant: 30)

        ])
    }
    
    private func setupAudioPlayer() {
        guard let audioPath = Bundle.main.path(forResource: trackNames[currentTrackIndex], ofType: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: audioPath))
            setupAudioSession()
            trackNameLabel.text = trackNames[currentTrackIndex]
        }
        catch {
            print(error)
        }
    }
    
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func playButtonTapped() {
        if player.isPlaying {
            player.pause()
            playAndPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playAndPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc func stopButtonTapped() {
        if player.isPlaying {
            player.stop()
            playAndPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            player.currentTime = 0
        }
        else {
            print("Already stopped!")
        }
    }
    
    @objc func nextTrack() {
        if player.isPlaying {
            currentTrackIndex = (currentTrackIndex + 1) % trackNames.count
            setupAudioPlayer()
            player.play()
            playAndPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            currentTrackIndex = (currentTrackIndex + 1) % trackNames.count
            setupAudioPlayer()
        }
    }
    
    @objc func previousTrack() {
        if player.isPlaying {
            currentTrackIndex = (currentTrackIndex - 1 + trackNames.count) % trackNames.count
            setupAudioPlayer()
            player.play()
            playAndPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            currentTrackIndex = (currentTrackIndex - 1 + trackNames.count) % trackNames.count
            setupAudioPlayer()
        }
    }

}
