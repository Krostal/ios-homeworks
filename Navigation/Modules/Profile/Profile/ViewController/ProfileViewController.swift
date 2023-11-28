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
    
    let context = CoreDataService.shared.setContext()
    
    private let sectionZeroHeader = ProfileTableHeaderView()
    
    fileprivate var dataSource = PostStorage.shared.getAllPosts()
    
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
        view.backgroundColor = ColorPalette.profileBackgroundColor
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
        Self.tableView.dragInteractionEnabled = true
        Self.tableView.dragDelegate = self
        Self.tableView.dropDelegate = self
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
        Self.tableView.reloadData()
    }
    
    @objc func doubleTappedOnFavoritePost(_ sender: UITapGestureRecognizer) {
        if sender.state == .recognized {
            let location = sender.location(in: Self.tableView)
            
            if let indexPath = Self.tableView.indexPathForRow(at: location) {
                let post = dataSource[indexPath.row]
                
                let favoritePost = FavoritePostCoreDataModel(context: self.context)
                favoritePost.id = post.id
                favoritePost.author = post.author
                favoritePost.text = post.text
                favoritePost.image = post.imageName
                
                do {
                    try context.save()
                    
                    if let cell = Self.tableView.cellForRow(at: indexPath) as? PostTableViewCell {
                        cell.fillStarMarkImage()
                        cell.isUserInteractionEnabled = false
                    }
                } catch {
                    print("Error saving post: \(error.localizedDescription)")
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
            let favoritePosts = CoreDataService.shared.fetchFavoritePosts()
            
            if favoritePosts.contains(where: { $0.id == post.id }) {
                cell.configure(post)
                cell.fillStarMarkImage()
                cell.isUserInteractionEnabled = false
            } else {
                cell.configure(post)
                cell.emptyStarMarkImage()
                let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTappedOnFavoritePost(_:)))
                doubleTapGesture.numberOfTapsRequired = 2
                cell.isUserInteractionEnabled = true
                cell.addGestureRecognizer(doubleTapGesture)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }

}

extension ProfileViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let post = dataSource[indexPath.row]
        
        var dragItems: [UIDragItem] = []
        
        if let image = post.image {
            let imageItemProvider = NSItemProvider(object: image)
            let imageDragItem = UIDragItem(itemProvider: imageItemProvider)
            dragItems.append(imageDragItem)
        }
        
        if let text = post.text as NSString? {
            let textItemProvider = NSItemProvider(object: text)
            let textDragItem = UIDragItem(itemProvider: textItemProvider)
            dragItems.append(textDragItem)
        }
        
        return dragItems
    }
}

extension ProfileViewController: UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self) || session.canLoadObjects(ofClass: NSString.self)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        let insertIndex = min(destinationIndexPath.row, PostStorage.shared.getAllPosts().count)
        
        coordinator.session.loadObjects(ofClass: UIImage.self) { items in
            guard let images = items as? [UIImage] else { return }
            
            coordinator.session.loadObjects(ofClass: NSString.self) { descriptionItems in
                
                guard let strings = descriptionItems as? [NSString] else { return }
                
                for (index, image) in images.enumerated() {
                    let description = strings.indices.contains(index) ? strings[index] as String : ""
                    print("Description for image \(index): \(description)")
                    
                    let newPost = Post(id: UUID().uuidString, author: "Drag&Drop", text: description, image: image, imageName: "", likes: 0, views: 0)
                    PostStorage.shared.addPost(newPost)
                }
                
                self.dataSource = PostStorage.shared.getAllPosts()
                
                let indexPathsToInsert = (0..<images.count).map { IndexPath(row: insertIndex + $0, section: 2) }
                tableView.insertRows(at: indexPathsToInsert, with: .automatic)
            }
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

