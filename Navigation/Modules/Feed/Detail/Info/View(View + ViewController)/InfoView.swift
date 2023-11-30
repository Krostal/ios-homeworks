
import UIKit

protocol InfoViewDelegate: AnyObject {
    func showDeleteAlert()
}

final class InfoView: UIView {
    
    private enum Constants {
        static let spacing: CGFloat = 16
        static let height: CGFloat = 50
    }
    
    weak var delegate: InfoViewDelegate?
    
    lazy var buttonDelete: CustomButton = {
        let button = CustomButton(
            title: "Delete this new".localized,
            backgroundColor: .systemCyan,
            action: { [weak self] in
                self?.showAlert()
            })
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.textColor = .black
        title.backgroundColor = .systemBlue
        title.numberOfLines = 0
        return title
    }()
    
    lazy var planetLabel: UILabel = {
        let planetLabel = UILabel()
        planetLabel.translatesAutoresizingMaskIntoConstraints = false
        planetLabel.textAlignment = .center
        planetLabel.textColor = ColorPalette.labelColor
        planetLabel.backgroundColor = ColorPalette.textColor
        planetLabel.numberOfLines = 0
        return planetLabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ResidentsTableViewCell.self, forCellReuseIdentifier: ResidentsTableViewCell.id)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviews()
        setupTableView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = ColorPalette.feedViewBackgroundColor
    }
    
    private func addSubviews() {
        addSubview(buttonDelete)
        addSubview(titleLabel)
        addSubview(planetLabel)
        addSubview(tableView)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = ColorPalette.feedViewBackgroundColor
        tableView.separatorInset = UIEdgeInsets(
            top: Constants.spacing,
            left: Constants.spacing,
            bottom: Constants.spacing,
            right: Constants.spacing
        )
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            buttonDelete.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.spacing),
            buttonDelete.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.spacing),
            buttonDelete.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.spacing),
            buttonDelete.heightAnchor.constraint(equalToConstant: Constants.height),
            
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.spacing),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.spacing),
            titleLabel.topAnchor.constraint(equalTo: buttonDelete.bottomAnchor, constant: Constants.spacing),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.height),
            
            planetLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.spacing),
            planetLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.spacing),
            planetLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
            planetLabel.heightAnchor.constraint(equalToConstant: Constants.height),
            
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.spacing),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.spacing),
            tableView.topAnchor.constraint(equalTo: planetLabel.bottomAnchor, constant: Constants.spacing),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.spacing)
        ])
    }
    
    private func showAlert() {
        self.delegate?.showDeleteAlert()
    }
    
    func updateTitleLabel(text: String) {
        titleLabel.text = text
    }
    
    func updatePlanetLabel(text: String) {
        planetLabel.text = text
    }
}
