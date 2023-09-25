
import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func savePost(_ favoritePost: FavoritePost) -> Bool
    func fetchPosts() -> [FavoritePost]
    func removePost(withID id: String) -> Bool
    func updatePost(_ favoritePost: FavoritePost) -> Bool
    func isPostFavorite(postId: String) -> Bool
    func fetchPostById(_ postId: String) -> PostCoreDataModel?
    func removeAllPosts() -> Bool
}

final class CoreDataService {
    
    private let modelName: String
    private let objectModel: NSManagedObjectModel
    private let storeCoordinator: NSPersistentStoreCoordinator
    
    private lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = storeCoordinator
        return context
    }()
    
    init() {
        
        // 1. NSManagerObjectModel
        guard let url = Bundle.main.url(forResource: "Navigation", withExtension: "momd") else {
            fatalError("Can not fetch URL of Navigation.momd")
        }
        
        let name = url.deletingPathExtension().lastPathComponent
        modelName = name
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Can not create NSManagedObjectModel")
        }
        objectModel = model
        
        // 2. NSPersistentStoreCoordinator
        storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        
        // 3. NSPersistentStore
        
        let storeName = name + ".sqlite"
        
        let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let persistantStoreUrl = documentDirectoryUrl?.appendingPathComponent(storeName)
                
        guard let persistantStoreUrl else { return }
        
        do {
            let _ = try storeCoordinator.addPersistentStore(
                type: .sqlite,
                at: persistantStoreUrl,
                options: [NSMigratePersistentStoresAutomaticallyOption: true]
            )
        } catch {
            fatalError("storeCoordinator.addPersistantStore error")
        }

    }

}

extension CoreDataService: CoreDataServiceProtocol {
 
    func savePost(_ favoritePost: FavoritePost) -> Bool {
        
        if fetchPostById(favoritePost.id) != nil {
            return false
        } else {
            let model = PostCoreDataModel(context: context)
            model.id = favoritePost.id
            model.author = favoritePost.author
            model.text = favoritePost.text
            model.image = favoritePost.image
            
            guard context.hasChanges else { return false }
            
            do {
                try context.save()
                return true
            } catch {
                return false
            }
        }
        
    }
    
    func fetchPosts() -> [FavoritePost] {
        let request = PostCoreDataModel.fetchRequest()
        
        do {
            let models = try context.fetch(request)
            return models.map { FavoritePost(postCoreDataModel: $0) }
        } catch {
            return []
        }
    }
    
    func removePost(withID id: String) -> Bool {
        let request = PostCoreDataModel.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        request.predicate = predicate
        
        do {
            let models = try context.fetch(request)
            models.forEach {
                context.delete($0)
            }
    
            guard context.hasChanges else { return false }
            
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    func updatePost(_ favoritePost: FavoritePost) -> Bool {
        let request = PostCoreDataModel.fetchRequest()
        
        do {
            let models = try context.fetch(request)
            let updatedModels = models.filter { $0.id == favoritePost.id }
            
            updatedModels.forEach {
                $0.author = favoritePost.author
                $0.text = favoritePost.text
                $0.image = favoritePost.image
            }
            
            guard context.hasChanges else { return false }
            
            try context.save()
            
            return true
        } catch {
            return false
        }
    }
    
    func isPostFavorite(postId: String) -> Bool {
        let request = PostCoreDataModel.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", postId)
        request.predicate = predicate
        
        do {
            let models = try context.fetch(request)
            return !models.isEmpty
        } catch {
            return false
        }
    }
    
    func fetchPostById(_ postId: String) -> PostCoreDataModel? {
        let request = PostCoreDataModel.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", postId)
        request.predicate = predicate
        
        do {
            let models = try context.fetch(request)
            return models.first
        } catch {
            return nil
        }
    }
    
    func removeAllPosts() -> Bool {
        let request = PostCoreDataModel.fetchRequest()
        
        do {
            let models = try context.fetch(request)
            models.forEach {
                context.delete($0)
            }
    
            guard context.hasChanges else { return false }
            
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
}
