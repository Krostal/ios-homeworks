
import UIKit

final class ResidentsTableViewCell: UITableViewCell {
    
    static let id = "ResidentsTableViewCell"
    
    private lazy var resident: UILabel = {
        let resident = UILabel()
        resident.translatesAutoresizingMaskIntoConstraints = false
        resident.textColor = ColorPalette.textColor
        return resident
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(resident)
    }
   
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([

            resident.topAnchor.constraint(equalTo: topAnchor, constant: 1),
            resident.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            resident.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            resident.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
        ])
    }
    
    func configure(with residentName: String) {
        resident.text = residentName
    }
}
