import UIKit
import StorageService

protocol ProfileViewControllerDelegate: AnyObject {
    func showPhotoGalleryViewController()
    func showMusicViewController()
    func showVideoViewController()
    func showRecordViewController()
}

class ProfileViewController: UIViewController {
    
    private enum Constants {
        static let separatorInset: CGFloat = 12.0
    }
    
    weak var delegate: ProfileViewControllerDelegate?
    
    var currentUser: UserModel?
    
    let profileCoordinator: ProfileCoordinator?
    
    private let coreDataService: CoreDataServiceProtocol = CoreDataService()
    
    private let sectionZeroHeader = ProfileTableHeaderView()
    
    fileprivate var dataSource = Post.make()
    
    static let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.id)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.id)
        return tableView
    }()
    
    init(coordinator: ProfileCoordinator) {
        self.profileCoordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupConstraints()
        setupNotificationObserver()
        
        #if DEBUG
        view.backgroundColor = .lightGray
        #else
        view.backgroundColor = .white
        #endif
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        for cell in Self.tableView.visibleCells {
            if let postCell = cell as? PostTableViewCell {
                postCell.startTimer()
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        for (index, cell) in Self.tableView.visibleCells.enumerated() {
            if let postCell = cell as? PostTableViewCell {
                postCell.stopTimer()
                
                if index < dataSource.count {
                    dataSource[index].likes = postCell.currentLikes
                    dataSource[index].views = postCell.currentViews
                }
            }
        }
    }
    
    private func setupTableView() {
        view.addSubview(Self.tableView)
        Self.tableView.backgroundColor = view.backgroundColor
        Self.tableView.sectionHeaderTopPadding = 0
        Self.tableView.delegate = self
        Self.tableView.dataSource = self
        Self.tableView.separatorInset = UIEdgeInsets(
            top: Constants.separatorInset,
            left: Constants.separatorInset,
            bottom: Constants.separatorInset,
            right: Constants.separatorInset
        )
    }
    
    
    private func setupConstraints() {
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            Self.tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            Self.tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            Self.tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            Self.tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
        ])
    }
    
    func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritePostDeleted(_:)), name: NSNotification.Name("FavoritePostDeleted"), object: nil)
    }
    
    @objc func handleFavoritePostDeleted(_ notification: Notification) {
        if let postID = notification.userInfo?["postID"] as? String {
            if let index = dataSource.firstIndex(where: { $0.id == postID }) {
                let indexPath = IndexPath(row: index, section: 2)
                if let cell = Self.tableView.cellForRow(at: indexPath) as? PostTableViewCell {
                    cell.emptyStarMarkImage()
                    cell.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    @objc func doubleTappedOnFavoritePost(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized {
            let location = sender.location(in: Self.tableView)
            
            if let indexPath = Self.tableView.indexPathForRow(at: location) {
                let post = dataSource[indexPath.row]
                let favoritePost = FavoritePost(post: post)
                
                coreDataService.savePost(favoritePost) { success in
                    if success {
                        if let cell = Self.tableView.cellForRow(at: indexPath) as? PostTableViewCell {
                            cell.fillStarMarkImage()
                            cell.isUserInteractionEnabled = false
                        }
                    } else {
                        print(favoritePost.author)
                        print("Error saving post")
                    }
                }
            }
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return dataSource.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.id, for: indexPath) as? PhotosTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.id, for: indexPath) as? PostTableViewCell else {
                return UITableViewCell()
            }
            let post = dataSource[indexPath.row]
            
            cell.configure(post)
            
            coreDataService.isPostFavorite(postId: post.id) { [weak self] isPostFavorite in
                guard let self else { return }
                if isPostFavorite {
                    cell.fillStarMarkImage()
                    cell.isUserInteractionEnabled = false
                } else {
                    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTappedOnFavoritePost(_:)))
                    doubleTapGesture.numberOfTapsRequired = 2
                    cell.isUserInteractionEnabled = true
                    cell.addGestureRecognizer(doubleTapGesture)
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            sectionZeroHeader.user = currentUser
            sectionZeroHeader.delegate = self
            return sectionZeroHeader
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return sectionZeroHeader.intrinsicContentSize.height + 20
        } else {
            return 0
        }
    }

}

extension ProfileViewController: PhotosTableViewCellDelegate {
    func tapArrowClickLabel() {
        delegate?.showPhotoGalleryViewController()
    }
}

extension ProfileViewController: ProfileTableHeaderViewDelegate {
    func didTapRecordButton() {
        delegate?.showRecordViewController()
    }
    
    func didTapMyVideoButton() {
        delegate?.showVideoViewController()
    }
    
    func didTapMyMusicButton() {
        delegate?.showMusicViewController()
    }
}

