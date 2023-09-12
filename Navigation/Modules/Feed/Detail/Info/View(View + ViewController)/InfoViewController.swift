
import UIKit

protocol InfoViewControllerDelegate: AnyObject {
    func infoViewControllerDismissed()
}

class InfoViewController: UIViewController {
    
    private enum Constants {
        static let height: CGFloat = 40
    }
    
    weak var infoDelegate: InfoViewControllerDelegate?
    
    var planet: Planet?
    var planetName: String?
    var residents: [String] = []
    
    private lazy var infoView = InfoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchJsonData()
        fetchPlanetData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        infoDelegate?.infoViewControllerDismissed()
    }
    
    private func setupView() {
        view.backgroundColor = .systemGray
        view = infoView
        infoView.tableView.delegate = self
        infoView.tableView.dataSource = self
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Attention!",
            message: "Are you sure you want to delete this new?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            print("The new successfully deleted")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("Deletion canceled")
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func fetchJsonData() {
        JSONSerializationDataService.fetchJSONData(from: "https://jsonplaceholder.typicode.com/todos/123") { result in
            switch result {
            case .success(let jsonObject):
                if let title = jsonObject["title"] as? String {
                    DispatchQueue.main.async {
                        self.infoView.updateTitleLabel(text: "Exercise 1: \(title)")
                    }
                }
            case .failure(let error):
                print("❌ JSONSerialization", error.localizedDescription)
            }
        }
    }
    
    private func fetchPlanetData() {
        DataService<Planet>.fetchData(from: "https://swapi.dev/api/planets/1") { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let planet):
                self.planetName = planet.name
                
                DispatchQueue.main.async {
                    self.infoView.updatePlanetLabel(text: "Exercise 2: Orbital Period is \(planet.orbitalPeriod) days")
                    self.infoView.tableView.reloadData()
                }
                
                self.fetchResidents(residentsURLs: planet.residents)
                
            case .failure(let error):
                print("❌ Network Error:", error.description)
            }
        }
    }
    
    private func fetchResidents(residentsURLs: [String]) {
        
        for url in residentsURLs {
            DataService<Resident>.fetchData(from: url) { [weak self] result in
                guard let self else { return }
                
                switch result {
                    
                case .success(let resident):
                    self.residents.append(resident.name)
                    
                    DispatchQueue.main.async {
                        self.infoView.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print("❌ Network Error:", error.description)
                    
                }
            }
        }
    }
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResidentsTableViewCell.id, for: indexPath) as? ResidentsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: residents[indexPath.row])
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.height
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = "Exercise 3. Residents of planet \(planetName ?? "Error"):"
        return header
    }
    
}

extension InfoViewController: InfoViewDelegate {
    
    func showDeleteAlert() {
        self.showAlert()
    }
}
