
import Foundation

struct NetworkService {
    static func request(for configuration: AppConfiguration) {
        
        if let url = configuration.url {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error {
                    print("❌", error.localizedDescription)
                }
                
                guard
                    let response = response as? HTTPURLResponse,
                      Array(200..<300).contains(response.statusCode)
                else {
                    return
                }
              
                guard let data else { return }
             
            }.resume()
        }
    }
}



