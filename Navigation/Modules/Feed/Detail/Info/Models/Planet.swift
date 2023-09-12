
import Foundation

struct Planet: Decodable {
    let name: String
    let orbitalPeriod: String
    let residents: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case orbitalPeriod = "orbital_period"
        case residents
    }

}

