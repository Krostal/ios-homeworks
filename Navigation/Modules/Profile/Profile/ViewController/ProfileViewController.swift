import UIKit
import StorageService

protocol ProfileViewControllerDelegate: AnyObject {
    func showPhotoGalleryViewController()
    func profileViewControllerDidDisappear()
}

class ProfileViewController: UIViewController {
    
    private enum Constants {
        static let separatorInset: CGFloat = 12.0
    }
    
    weak var delegate: ProfileViewControllerDelegate?
    
    var currentUser: User?
    
    private let sectionZeroHeader = ProfileTableHeaderView()
    
    fileprivate let dataSource = Post.make()
    
    static let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.id)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        setupTableView()
        setupConstraints()
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
        Self.tableView.backgroundColor = view.backgroundColor
        Self.tableView.separatorStyle = .none
        Self.tableView.delegate = self
        Self.tableView.dataSource = self
        Self.tableView.refreshControl = UIRefreshControl()
        Self.tableView.refreshControl?.addTarget(self, action: #selector(reloadTableView), for: .valueChanged)
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
    
    @objc func reloadTableView() {
        Self.tableView.reloadData()
        Self.tableView.refreshControl?.endRefreshing()
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
            cell.configure(dataSource[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return sectionZeroHeader.intrinsicContentSize.height
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 {
            sectionZeroHeader.user = currentUser
            sectionZeroHeader.translatesAutoresizingMaskIntoConstraints = false
            
            #if DEBUG
            sectionZeroHeader.backgroundColor = .lightGray
            #else
            sectionZeroHeader.backgroundColor = .white
            #endif
            
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

