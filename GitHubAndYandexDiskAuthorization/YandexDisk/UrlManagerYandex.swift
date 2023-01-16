

import Foundation


final class ApiManagerForYandex {
    
    static func requestForYandex() -> URLRequest?{
        
        guard var urlCompanents = URLComponents(string: "https://oauth.yandex.ru/authorize?") else {return nil}

        urlCompanents.queryItems = [
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "client_id", value: "\(YandexInfo.clientId.rawValue)")

        ]
        guard let url = urlCompanents.url else { return nil }
        return URLRequest(url: url)
    
    }
    
    static func logOut() -> URLRequest?{
    
        guard let urlCompanents = URLComponents(string: YandexInfo.logoutCallbackUrl.rawValue) else {return nil}

        guard let url = urlCompanents.url else { return nil }
        return URLRequest(url: url)
    
    }
    
    
    static func loadDataAboutYandexDisk( key: String, responce: @escaping (DiskResponse?, Bool) -> Void) {
        
        var components = URLComponents(string: YandexInfo.urlDiskFiles.rawValue)
        components?.queryItems = [URLQueryItem(name: "media_type", value: "image")]

        guard let url = components?.url else {
            responce(nil, false)
            return
        }

        var request = URLRequest(url: url)
        request.setValue("OAuth \(key)", forHTTPHeaderField: "Authorization")


        let task = URLSession.shared.dataTask(with: request) {  data, response, error in
            guard let data = data else {
                
                responce(nil, true)
                return
                
            }
            guard let newFiles = try? JSONDecoder().decode(DiskResponse.self, from: data) else {
                KeychainManagerForPerson.delete(service: YandexInfo.login.rawValue)
                responce(nil, false)
                
                return
                
            }
            responce(newFiles, false)

        }
        task.resume()
        
        
    }
    
    static func downloadingImagesFromUrl(urlString : String, responce: @escaping (Data?) -> Void) {
       
        
        guard  let url = URL(string: (urlString)) else {
            responce(nil)
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                responce(nil)
                return
            }
            responce(data)
        }
        task.resume()
    }
    

}
