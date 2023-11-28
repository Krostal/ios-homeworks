
import Foundation

final class PostStorage {
    
    static let shared = PostStorage()
    private var posts: [Post] = []

    private init() {
        self.posts = Post.make()
    }

    func getAllPosts() -> [Post] {
        return posts
    }

    func addPost(_ post: Post) {
        posts.append(post)
    }
}

