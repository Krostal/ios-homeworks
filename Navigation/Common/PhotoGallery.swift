import UIKit

struct PhotoGalery {
    var image: String
    
    static var photoNames: [String] {
        return (1...20).map { String($0) }
    }
    
    static func makeImage() -> [UIImage] {
        let images = photoNames.map { PhotoGalery(image: $0) }
        return images.compactMap { UIImage(named: $0.image) }
    }
}
