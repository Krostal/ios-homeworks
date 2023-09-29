//import Foundation
//import StorageService
//
//struct FavoritePost {
//    
//    let id: String
//    var author: String
//    var text: String
//    var image: String
//
//    
//    init(id: String, author: String, text: String, image: String) {
//
//        self.id = id
//        self.author = author
//        self.text = text
//        self.image = image
//
//    }
//    
//    init(post: Post) {
//        self.id = post.id
//        self.author = post.author
//        self.text = post.text
//        self.image = post.image
//
//    }
//    
//    init(favoritePostCoreDataModel: FavoritePostCoreDataModel) {
//        id = favoritePostCoreDataModel.id ?? ""
//        author = favoritePostCoreDataModel.author ?? ""
//        text = favoritePostCoreDataModel.text ?? ""
//        image = favoritePostCoreDataModel.image ?? ""
//
//    }
//    
//}
