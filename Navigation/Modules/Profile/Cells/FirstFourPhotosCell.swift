
import UIKit

final class FirstFourPhotosCell: UICollectionViewCell {
    
    private lazy var firstFourPhotos: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupView()
        setupSubviews()
        setupLayouts()
    }
    
    private func setupView() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 6
        contentView.backgroundColor = .white
    }
    
    private func setupSubviews() {
        contentView.addSubview(firstFourPhotos)
    }
    
    private func setupLayouts() {
        NSLayoutConstraint.activate([
            firstFourPhotos.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstFourPhotos.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            firstFourPhotos.topAnchor.constraint(equalTo: contentView.topAnchor),
            firstFourPhotos.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func setup(with photos: PhotoGalery) {
        firstFourPhotos.image = UIImage(named: photos.image)
    }
    
}



