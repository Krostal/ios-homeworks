
import Foundation

final class DataService<T: Decodable> {
    static func fetchData(from urlString: String, completion: @escaping (Result<T,FetchDataError>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error: error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse(statusCode: 0)))
                return
            }
            
            guard (200..<300).contains(response.statusCode) else {
                completion(.failure(.invalidResponse(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
        
    }
    
}
