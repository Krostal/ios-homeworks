
import UIKit

class PostTableViewCell: UITableViewCell {
    
    static let id = "PostTableViewCell"
    
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
        postImage.backgroundColor = .black
        return postImage
    }()
    
    private lazy var postPopularity: UIStackView = {
        let postPopularity = UIStackView()
        postPopularity.translatesAutoresizingMaskIntoConstraints = false
        postPopularity.spacing = 10
        postPopularity.axis = .horizontal
        postPopularity.addArrangedSubview(postLikes)
        postPopularity.addArrangedSubview(postViews)
        return postPopularity
    }()
    
    private lazy var postLikes: UILabel = {
        let postLikes = UILabel()
        postLikes.translatesAutoresizingMaskIntoConstraints = false
        postLikes.font = .systemFont(ofSize: 16, weight: .regular)
        postLikes.tintColor = .black
        return postLikes
    }()
    
    private lazy var postViews: UILabel = {
        let postViews = UILabel()
        postViews.translatesAutoresizingMaskIntoConstraints = false
        postViews.font = .systemFont(ofSize: 16, weight: .regular)
        postViews.tintColor = .black
        return postViews
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
        addSubview(postPopularity)
    }
   
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            postAuthor.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            postAuthor.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            postAuthor.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            postImage.topAnchor.constraint(equalTo: postAuthor.bottomAnchor, constant: 16),
            postImage.widthAnchor.constraint(equalTo: widthAnchor),
            postImage.heightAnchor.constraint(equalTo: widthAnchor),
            
            postDescription.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 16),
            postDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            postDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            postPopularity.topAnchor.constraint(equalTo: postDescription.bottomAnchor, constant: 16),
            postPopularity.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            postPopularity.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            postPopularity.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
        
    func configure(_ post: Post) {
        postAuthor.text = post.author
        postImage.image = UIImage(named: post.image)
        postDescription.text = post.description
        postLikes.text = "Likes: \(post.likes)"
        postViews.text = "Views: \(post.views)"
    }
    
}
