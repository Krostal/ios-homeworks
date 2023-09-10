import Foundation

enum AppConfiguration {
    case people
    case starships
    case planets
    
    var url: URL? {
        switch self {
        case .people:
            return URL(string: "https://swapi.dev/api/people/8")
        case .planets:
            return URL(string: "https://swapi.dev/api/starships/3")
        case .starships:
            return URL(string: "https://swapi.dev/api/planets/5")
        }
    }
}
