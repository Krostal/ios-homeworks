import UIKit

final class FavoritePostsViewController: UIViewController {
    
    private enum Constants {
        static let separatorInset: CGFloat = 12.0
    }

    private let coreDataService: CoreDataServiceProtocol = CoreDataService()
    
    private var favoritePosts: [FavoritePost] = []

    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FavoritePostsTableViewCell.self, forCellReuseIdentifier: FavoritePostsTableViewCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupConstraints()
        setupNavigationBar()
        favoritePosts = coreDataService.fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPostsAndUpdateTable()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = view.backgroundColor
        tableView.sectionHeaderTopPadding = 0
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
        
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
        ])
    }
    
    private func fetchPostsAndUpdateTable() {
        favoritePosts = coreDataService.fetchPosts()
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Favorite posts"
        
    }
    
}

extension FavoritePostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataService.fetchPosts().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePostsTableViewCell.id, for: indexPath) as? FavoritePostsTableViewCell else {
            return UITableViewCell()
        }
        
        let post = favoritePosts[indexPath.row]
        
        cell.configure(with: post)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favoritePost = favoritePosts[indexPath.row]
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Remove from favorites") { [weak self] _,_,_ in
                guard let self else { return }
                let success = self.coreDataService.removePost(withID: favoritePost.id)
                if success {
                    self.favoritePosts.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    NotificationCenter.default.post(name: NSNotification.Name("FavoritePostDeleted"), object: self, userInfo: ["postID": favoritePost.id])
                } else {
                    print("Error removing post from favorites")
                }
            }
        deleteAction.image = UIImage(systemName: "star.slash")
        deleteAction.backgroundColor = UIColor(named: "AccentColor")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}