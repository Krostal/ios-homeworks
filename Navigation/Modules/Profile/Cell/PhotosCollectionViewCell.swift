import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    private lazy var photos: UIImageView = {
        let photos = UIImageView(frame: .zero)
        photos.translatesAutoresizingMaskIntoConstraints = false
        
        photos.contentMode = .scaleToFill
        return photos
    }()
    
    private func setupView() {
        contentView.backgroundColor = .white
    }

    private func setupSubviews() {
        contentView.addSubview(photos)
    }

    private func setupLayouts() {
        NSLayoutConstraint.activate([
            photos.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photos.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photos.topAnchor.constraint(equalTo: contentView.topAnchor),
            photos.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupSubviews()
        setupLayouts()
    }
    
    func setup(with photoGallery: PhotoGalery) {
        photos.image = UIImage(named: photoGallery.image)
    }
    
}
