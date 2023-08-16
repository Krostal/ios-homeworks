
import UIKit

typealias Action = () -> Void?

class PhotosTableViewCell: UITableViewCell {
    
    static let id = "PhotosTableViewCell"
    
    var onLabelTapped: Action?
    
    fileprivate lazy var photoGalery = PhotoGalery.makeImage()
    
    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(FirstFourPhotosCell.self, forCellWithReuseIdentifier: FirstFourPhotosCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
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
        titleForSection.backgroundColor = .white
        titleForSection.addArrangedSubview(photosLabel)
        titleForSection.addArrangedSubview(arrowClickLabel)
        return titleForSection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
        setupConstraints()
        addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        contentView.addSubview(titlePhotoSectionView)
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([

            titlePhotoSectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titlePhotoSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titlePhotoSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                        
            collectionView.topAnchor.constraint(equalTo: titlePhotoSectionView.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            collectionView.heightAnchor.constraint(equalToConstant: frame.width / 4 + 8)
        ])
    }
    
    private func addTarget() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOnLabel))
        arrowClickLabel.isUserInteractionEnabled = true
        arrowClickLabel.addGestureRecognizer(gesture)
    }
    
    @objc
    private func tapOnLabel() {
        onLabelTapped?()
    }
    
}

extension PhotosTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoGalery.index(before: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstFourPhotosCell.identifier, for: indexPath) as! FirstFourPhotosCell
        let photos = photoGalery[indexPath.row]
        cell.setup(with: photos)
        
        return cell
    }
}
    
extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    
    
    private func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 4
        let padding: CGFloat = 12
        
        let totalSpacing: CGFloat = (itemsInRow - 1) * spacing + (2 * padding)
        let finalWidth = (width - totalSpacing) / itemsInRow
        
        return floor(finalWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemWidth(for: frame.width, spacing: 8)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}

