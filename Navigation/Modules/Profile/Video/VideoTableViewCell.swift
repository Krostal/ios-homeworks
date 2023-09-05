
import UIKit
import YouTubeiOSPlayerHelper


final class VideoTableViewCell: UITableViewCell {
    
    static let id = "VideoTableViewCell"
    
    private lazy var youtubePlayer: YTPlayerView = {
        let player = YTPlayerView()
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
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
        contentView.addSubview(youtubePlayer)
    }
   
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([

            youtubePlayer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            youtubePlayer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            youtubePlayer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            youtubePlayer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    func configure(with imageName: String) {
        youtubePlayer.load(withVideoId: imageName)
    }
}
