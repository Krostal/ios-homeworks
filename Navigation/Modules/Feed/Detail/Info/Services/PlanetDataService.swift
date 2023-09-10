
import Foundation

final class PlanetDataService {
    
    static func fetchPlanetData(from urlString: String, completion: @escaping (Result<Planet, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("❌ Error fetching Planet data:", error.localizedDescription)
            }
            
            guard
                let response = response as? HTTPURLResponse,
                Array(200..<300).contains(response.statusCode)
            else { return }
            
            do {
                if let data = data {
                    let decoder = JSONDecoder()
                    let planet = try decoder.decode(Planet.self, from: data)
                    completion(.success(planet))
                } else {
                    completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    static func fetchResidentData(from urlString: String, completion: @escaping (Result<Resident, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("❌ Error fetching Resident data:", error.localizedDescription)
            }
            
            guard
                let response = response as? HTTPURLResponse,
                Array(200..<300).contains(response.statusCode)
            else { return }
            
            do {
                if let data = data {
                    let decoder = JSONDecoder()
                    let resident = try decoder.decode(Resident.self, from: data)
                    completion(.success(resident))
                } else {
                    completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
