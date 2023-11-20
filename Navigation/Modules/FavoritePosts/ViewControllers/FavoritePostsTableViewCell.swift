
import UIKit

protocol Configurable {
    associatedtype Model
    func configure(with model: Model)
}

class FavoritePostsTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let padding: CGFloat = 16.0
    }
    
    static let id = "FavoritePostsTableViewCell"
    
    private lazy var postAuthor: UILabel = {
        let postAuthor = UILabel()
        postAuthor.translatesAutoresizingMaskIntoConstraints = false
        postAuthor.font = .systemFont(ofSize: 20, weight: .bold)
        postAuthor.tintColor = .black
        postAuthor.numberOfLines = 2
        
        return postAuthor
    }()
    
    private lazy var postDescription: UILabel = {
        let postDescription = UILabel()
        postDescription.translatesAutoresizingMaskIntoConstraints = false
        postDescription.font = .systemFont(ofSize: 14, weight: .regular)
        postDescription.textColor = .systemGray
        postDescription.numberOfLines = 0
        return postDescription
    }()
    
    private lazy var postImage: UIImageView = {
        let postImage = UIImageView()
        postImage.translatesAutoresizingMaskIntoConstraints = false
        postImage.contentMode = .scaleAspectFit
        postImage.backgroundColor = ColorPalette.profileBackgroundColor
        return postImage
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(postAuthor)
        addSubview(postDescription)
        addSubview(postImage)
    }
   
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            postAuthor.topAnchor.constraint(equalTo: topAnchor, constant: Constants.padding),
            postAuthor.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            postAuthor.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            postAuthor.heightAnchor.constraint(equalToConstant: 24),
            
            postImage.topAnchor.constraint(equalTo: postAuthor.bottomAnchor, constant: Constants.padding),
            postImage.widthAnchor.constraint(equalTo: widthAnchor),
            postImage.heightAnchor.constraint(equalTo: postImage.widthAnchor),
            
            postDescription.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: Constants.padding),
            postDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            postDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            postDescription.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.padding)
            
        ])
    }
    
}

extension FavoritePostsTableViewCell: Configurable {
    func configure(with model: FavoritePostCoreDataModel) {
        postAuthor.text = model.author
        postDescription.text = model.text
        postImage.image = UIImage(named: model.image ?? "apple.logo")
    }
}
