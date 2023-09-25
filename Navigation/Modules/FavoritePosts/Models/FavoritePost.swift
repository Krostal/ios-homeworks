import Foundation
import StorageService

struct FavoritePost {
    
    let id: String
    var author: String
    var text: String
    var image: String
    var likes: String
    var views: String
    
    init(id: String, author: String, text: String, image: String, likes: String, views: String) {
        self.id = id
        self.author = author
        self.text = text
        self.image = image
        self.likes = likes
        self.views = views
    }
    
    init(post: Post) {
        self.id = post.id
        self.author = post.author
        self.text = post.text
        self.image = post.image
        self.likes = String(post.likes)
        self.views = String(post.views)
    }
    
    init(postCoreDataModel: PostCoreDataModel) {
        id = postCoreDataModel.id ?? ""
        author = postCoreDataModel.author ?? ""
        text = postCoreDataModel.text ?? ""
        image = postCoreDataModel.image ?? ""
        likes = postCoreDataModel.likes ?? ""
        views = postCoreDataModel.views ?? ""
    }
    
}
