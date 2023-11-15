import UIKit
import CoreData

final class FavoritePostsViewController: UIViewController {
    
    private enum Constants {
        static let separatorInset: CGFloat = 12.0
    }

    private let coreDataService = CoreDataService.shared
    
    private var fetchedResultsController: NSFetchedResultsController<FavoritePostCoreDataModel>?

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
        fetchFavoritePosts()
        configureFetchedResultController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFetchedResultController()
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
        tableView.refreshControl = UIRefreshControl()
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
    
    private func setupNavigationBar() {
        navigationItem.title = "Favorite posts"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "AccentColor") ?? .blue]
        
        let setFilterBarButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease"), style: .plain, target: self, action: #selector(setFilterAction))
        let clearFilterButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(clearFilterAction))
        
        navigationItem.rightBarButtonItems = [setFilterBarButton, clearFilterButton]
        
    }
    
    private func fetchFavoritePosts() {
        tableView.refreshControl?.beginRefreshing()
        
        do {
            try fetchedResultsController?.performFetch()
    
            tableView.reloadData()
            tableView.refreshControl?.endRefreshing()
        } catch {
            print("Error fetching favorite posts: \(error.localizedDescription)")
        }
    }
    
    private func configureFetchedResultController() {

        let sortDescriptor = NSSortDescriptor(key: "author", ascending: true)
        let request = FavoritePostCoreDataModel.fetchRequest()
        request.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataService.setContext(),
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        } catch {
            print("Error fetching favorite posts: \(error.localizedDescription)")
        }
        
    }

    private func showFilterByAuthorAlert() {
        let alert = UIAlertController(title: "Enter Author Name", message: "Please enter the name of the author whose posts you want to filter by", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter Author Name"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .words
            textField.becomeFirstResponder()
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Apply", style: .default, handler: { [weak self] _ in
            guard let self, let textField = alert.textFields?.first, let author = textField.text else { return }
            let predicate = NSPredicate(format: "author CONTAINS[c] %@", author)
            self.fetchedResultsController?.fetchRequest.predicate = predicate
            do {
                try self.fetchedResultsController?.performFetch()
                self.tableView.reloadData()
            } catch {
                print("Error fetching posts after filter: \(error.localizedDescription)")
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func setFilterAction(_ sender: UIBarButtonItem) {
        showFilterByAuthorAlert()
    }
    
    @objc private func clearFilterAction(_ sender: UIBarButtonItem) {
        configureFetchedResultController()
    }
    
}

extension FavoritePostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritePostsTableViewCell.id, for: indexPath) as? FavoritePostsTableViewCell else {
            return UITableViewCell()
        }
        
        if let favoritePost = fetchedResultsController?.object(at: indexPath) {
            
            cell.configure(with: favoritePost)
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Remove from favorites"
        ) { [weak self] _,_,_ in
            guard let self else { return }
            if let favoritePost = self.fetchedResultsController?.object(at: indexPath) {
                let context = self.fetchedResultsController?.managedObjectContext
                context?.delete(favoritePost)
                
                do {
                    try context?.save()
                    NotificationCenter.default.post(name: NSNotification.Name("FavoritePostDeleted"), object: self, userInfo: ["postID": favoritePost.id ?? ""])
                } catch {
                    print("Error removing post from favorites: \(error.localizedDescription)")
                }
            }
        }
        deleteAction.image = UIImage(systemName: "star.slash")
        deleteAction.backgroundColor = UIColor(named: "AccentColor")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension FavoritePostsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .left)
        case .delete:
            guard let indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .right)
        case .move:
            guard let indexPath, let newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.insertRows(at: [newIndexPath], with: .left)
        case .update:
            guard let indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade)
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
