
import UIKit
import StorageService

protocol ProfileViewControllerDelegate: AnyObject {
    func showPhotoGalleryViewController()
    func profileViewControllerDidDisappear()
}

class ProfileViewController: UIViewController {
    
    weak var delegate: ProfileViewControllerDelegate?
    
    var currentUser: User?
    
    fileprivate let dataSource = Post.make()
    
    static let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.id)
        tableView.register(PhotoGalleryTableViewCell.self, forCellReuseIdentifier: PhotoGalleryTableViewCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupConstraints()
        
        #if DEBUG
        view.backgroundColor = .lightGray
        #else
        view.backgroundColor = .white
        #endif

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.profileViewControllerDidDisappear()
    }
    
    private func setupTableView() {
        view.addSubview(Self.tableView)
        Self.tableView.delegate = self
        Self.tableView.dataSource = self
        Self.tableView.refreshControl = UIRefreshControl()
        Self.tableView.refreshControl?.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
        Self.tableView.separatorInset = UIEdgeInsets(
            top: 12,
            left: 12,
            bottom: 12,
            right: 12
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
    
    @objc func reloadTableView() {
        Self.tableView.reloadData()
        Self.tableView.refreshControl?.endRefreshing()
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return UITableViewCell()
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoGalleryTableViewCell.id, for: indexPath) as? PhotoGalleryTableViewCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
        }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.id, for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(dataSource[indexPath.row-2])
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionZeroHeader = ProfileTableHeaderView()
        sectionZeroHeader.translatesAutoresizingMaskIntoConstraints = false
        sectionZeroHeader.backgroundColor = .clear
        
        if section == 0 {
            sectionZeroHeader.user = currentUser
            return sectionZeroHeader
        } else {
            return nil
        }
        
    }
    
}

extension ProfileViewController: LoginViewControllerDelegate {
    func check(_ sender: LoginViewController, login: String, password: String) -> Bool {
        Checker.shared.check(login: login, password: password)
    }
}
        


extension ProfileViewController: PhotosTableViewCellDelegate {
    func tapArrowClickLabel() {
        delegate?.showPhotoGalleryViewController()
    }
}

