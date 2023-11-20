import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    private lazy var photos: UIImageView = {
        let photos = UIImageView(frame: .zero)
        photos.translatesAutoresizingMaskIntoConstraints = false
        photos.backgroundColor = ColorPalette.profileBackgroundColor
        photos.contentMode = .scaleAspectFit
        return photos
    }()

    private func setupSubviews() {
        contentView.addSubview(photos)
    }

    private func setupLayouts() {
        NSLayoutConstraint.activate([
            photos.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photos.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photos.topAnchor.constraint(equalTo: contentView.topAnchor),
            photos.heightAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSubviews()
        setupLayouts()
    }
    
    func setup(with photoGallery: UIImage) {
        photos.image = photoGallery
    }
    
}
