import UIKit
import StorageService

final class FavoritePostsViewController: UIViewController {
    
    private enum Constants {
        static let separatorInset: CGFloat = 12.0
    }
    
    var currentUser: UserModel?
    
    fileprivate var dataSource = Post.make()

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
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = view.backgroundColor
        tableView.sectionHeaderTopPadding = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
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
    
    @objc func reloadTableView() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
}

extension FavoritePostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePostsTableViewCell.id, for: indexPath) as? FavoritePostsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(dataSource[indexPath.row])
        return cell
    }
}
