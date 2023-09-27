
import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func savePost(_ favoritePost: FavoritePost, completion: @escaping (Bool) -> Void)
    func removePost(withID id: String, completion: @escaping (Bool) -> Void)
    func updatePost(_ favoritePost: FavoritePost, completion: @escaping (Bool) -> Void)
    func isPostFavorite(postId: String, completion: @escaping (Bool) -> Void)
    func fetchPosts(withPredicate predicate: NSPredicate?, completion: @escaping ([FavoritePost]) -> Void)
}

final class CoreDataService {
    
    private let modelName: String
    private let objectModel: NSManagedObjectModel
    private let storeCoordinator: NSPersistentStoreCoordinator
    
    private lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = storeCoordinator
        return context
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
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
    
    func savePost(_ favoritePost: FavoritePost, completion: @escaping (Bool) -> Void) {
        
        backgroundContext.perform { [weak self] in
            guard let self else { return }
            
            let postIdPredicate = NSPredicate(format: "id == %@", favoritePost.id)
            self.fetchPosts(withPredicate: postIdPredicate) { posts in
                if posts.count != 0 {
                    self.mainContext.perform {
                        completion(false)
                    }
                } else {
                    let model = PostCoreDataModel(context: self.backgroundContext)
                    model.id = favoritePost.id
                    model.author = favoritePost.author
                    model.text = favoritePost.text
                    model.image = favoritePost.image
                    
                    guard self.backgroundContext.hasChanges else {
                        self.mainContext.perform {
                            completion(false)
                        }
                        return
                    }
                    
                    do {
                        try self.backgroundContext.save()
                        self.mainContext.perform {
                            completion(true)
                        }
                    } catch {
                        self.mainContext.perform {
                            completion(false)
                        }
                    }
                }
            }
        }
    }
    
    func removePost(withID id: String, completion: @escaping (Bool) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self else { return }
            let request = PostCoreDataModel.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", id)
            request.predicate = predicate
            
            do {
                let models = try self.backgroundContext.fetch(request)
                models.forEach {
                    self.backgroundContext.delete($0)
                }
                
                guard backgroundContext.hasChanges else {
                    self.mainContext.perform {
                        completion(false)
                    }
                    return
                }
                
                try backgroundContext.save()
                    
                self.mainContext.perform {
                    completion(true)
                }
                
            } catch {
                mainContext.perform {
                    completion(false)
                }
            }
        }
    }
    
    func updatePost(_ favoritePost: FavoritePost, completion: @escaping (Bool) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self else { return }
        
            let request = PostCoreDataModel.fetchRequest()
        
            do {
                let models = try self.backgroundContext.fetch(request)
                let updatedModels = models.filter { $0.id == favoritePost.id }
                
                updatedModels.forEach {
                    $0.author = favoritePost.author
                    $0.text = favoritePost.text
                    $0.image = favoritePost.image
                }
                
                guard self.backgroundContext.hasChanges else {
                    self.mainContext.perform {
                        completion(false)
                    }
                    return
                }
                    
                try self.backgroundContext.save()
                    
                self.mainContext.perform {
                    completion(true)
                }
            } catch {
                self.mainContext.perform {
                    completion(false)
                }
            }
        }
    }
    
    func isPostFavorite(postId: String, completion: @escaping (Bool) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self else { return }
            
            let request = PostCoreDataModel.fetchRequest()
            let predicate = NSPredicate(format: "id == %@", postId)
            request.predicate = predicate
            
            do {
                let models = try self.backgroundContext.fetch(request)
                self.mainContext.perform {
                    completion(!models.isEmpty)
                }
            } catch {
                self.mainContext.perform {
                    completion(false)
                }
            }
        }
    }
    
    func fetchPosts(withPredicate predicate: NSPredicate?, completion: @escaping ([FavoritePost]) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self else { return }
            
            let request = PostCoreDataModel.fetchRequest()
            request.predicate = predicate
            
            do {
                let models = try self.backgroundContext.fetch(request)
                self.mainContext.perform {
                    completion(models.map { FavoritePost(postCoreDataModel: $0) })
                }
            } catch {
                self.mainContext.perform {
                    completion([])
                }
            }
        }
    }
    
}
