
import UIKit
import StorageService

class PostTableViewCell: UITableViewCell {
    
    private enum Constants {
        static let padding: CGFloat = 16.0
    }
    
    static let id = "PostTableViewCell"
    
    var currentLikes: Int = 0
    var currentViews: Int = 0
    
    private var timer: Timer?
    
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
    
    private lazy var postPopularity: UIStackView = {
        let postPopularity = UIStackView()
        postPopularity.translatesAutoresizingMaskIntoConstraints = false
        postPopularity.spacing = 10
        postPopularity.axis = .horizontal
        postPopularity.addArrangedSubview(postLikes)
        postPopularity.addArrangedSubview(postViews)
        postPopularity.addArrangedSubview(starMark)
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
    
    private lazy var starMark: UIImageView = {
        let starMark = UIImageView()
        starMark.image = UIImage(systemName: "")
        starMark.translatesAutoresizingMaskIntoConstraints = false
        starMark.tintColor = .systemYellow
        return starMark
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopTimer()
    }
    
    private func addSubviews() {
        addSubview(postAuthor)
        addSubview(postDescription)
        addSubview(postImage)
        addSubview(postPopularity)
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
            
            postPopularity.topAnchor.constraint(equalTo: postDescription.bottomAnchor, constant: Constants.padding),
            postPopularity.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            postPopularity.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding),
            postPopularity.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    func startTimer() {
        if timer == nil {
            DispatchQueue.global().async { [ weak self ] in
                guard let self else {
                    return
                }
                timer = Timer.scheduledTimer(
                    withTimeInterval: 2.0,
                    repeats: true,
                    block: { [weak self ] timer in
                        guard let self else {
                            return
                        }
                        DispatchQueue.main.async { [ weak self ] in
                            guard let self else {
                                return
                            }
                            currentLikes += 2
                            currentViews += 1
                            updateLikesAndViews()
                        }
                    })
                
                guard let timer = timer else {
                    return
                }
                timer.tolerance = 0.3
                RunLoop.current.add(timer, forMode: .common)
                RunLoop.current.run()
            }
            
        }
    }
        
    private func updateLikesAndViews() {
        postLikes.text = String.localizedStringWithFormat("Likes".localized, currentLikes)
        postViews.text = String.localizedStringWithFormat("Views".localized, currentViews)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func configure(_ post: Post) {
        postAuthor.text = post.author
        postImage.image = post.image
        postDescription.text = post.text
        currentLikes = post.likes
        currentViews = post.views
        updateLikesAndViews()
        startTimer()
    }
    
    func fillStarMarkImage() {
        starMark.image = UIImage(systemName: "star.fill")
    }
    
    func emptyStarMarkImage() {
        starMark.image = UIImage(systemName: "star")
    }
    
}
