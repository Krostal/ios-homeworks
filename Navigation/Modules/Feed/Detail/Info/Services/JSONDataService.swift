import Foundation

final class JSONDataService {
    
    static func fetchJSONData(from urlString: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print("❌ Error fetching JSON data:", error.localizedDescription)
            }
            guard
                let response = response as? HTTPURLResponse,
                Array(200..<300).contains(response.statusCode)
            else { return }
            
            do {
                if let data = data {
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    completion(.success(jsonObject ?? [:]))
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
