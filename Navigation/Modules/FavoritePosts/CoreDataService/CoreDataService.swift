
import Foundation
import CoreData

final class CoreDataService {
    
    static let shared = CoreDataService()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoritePostCoreDataModel")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("‼️ Can not load persistant stores \(error)")
            }
        }
        return container
    }()
    
    func setContext() -> NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func fetchFavoritePosts() -> [FavoritePostCoreDataModel] {
        let request = FavoritePostCoreDataModel.fetchRequest()
        
        do {
            let favoritePosts = try setContext().fetch(request)
            return favoritePosts
        } catch {
            print("Error fetching favorite posts: \(error.localizedDescription)")
            return []
        }
    }
    
}
