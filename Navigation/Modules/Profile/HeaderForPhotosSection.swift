import UIKit

class HeaderForPhotoSection: UIView {
    
    private lazy var photosLabel: UILabel = {
        let photosLabel = UILabel()
        photosLabel.translatesAutoresizingMaskIntoConstraints = false
        photosLabel.text = "Photos"
        photosLabel.textColor = .black
        photosLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        return photosLabel
    }()
    
    private lazy var arrowClickLabel: UILabel = {
        let arrowClickLabel = UILabel()
        arrowClickLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowClickLabel.text = "→"
        arrowClickLabel.font = .systemFont(ofSize: 24)
        arrowClickLabel.textColor = .black
        return arrowClickLabel
    }()
    
    private lazy var titlePhotoSectionView: UIStackView = {
        let titleForSection = UIStackView()
        titleForSection.translatesAutoresizingMaskIntoConstraints = false
        titleForSection.axis = .horizontal
        titleForSection.spacing = 10
        titleForSection.addArrangedSubview(photosLabel)
        titleForSection.addArrangedSubview(arrowClickLabel)
        return titleForSection
    }()
    
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: frame.width,
            height: 24
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        addSubview(titlePhotoSectionView)
        
        NSLayoutConstraint.activate([
            
            titlePhotoSectionView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titlePhotoSectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titlePhotoSectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titlePhotoSectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
}
