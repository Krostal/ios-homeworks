import UIKit

protocol VideoViewControllerDelegate: AnyObject {
    func videoViewControllerDidDisappear()
}

final class VideoViewController: UIViewController {
    
    private enum Constants {
        static let separatorInset: CGFloat = 12.0
    }
    
    weak var delegate: VideoViewControllerDelegate?
        
    let videos: [String] = [
        "vjreqyWFC2Y",
        "KuqPhzaBZNQ",
        "q7lmtwMroqQ",
        "YyTsTvj4C-8",
        "woMvP3PZKyk?si"
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupConstraints()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.videoViewControllerDidDisappear()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(
            top: Constants.separatorInset,
            left: Constants.separatorInset,
            bottom: Constants.separatorInset,
            right: Constants.separatorInset
        )
    }
    
    private func setupConstraints() {
        
        let safeAreaLayout = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayout.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayout.trailingAnchor)
        ])
    }
    
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.id, for: indexPath) as? VideoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: videos[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
}
