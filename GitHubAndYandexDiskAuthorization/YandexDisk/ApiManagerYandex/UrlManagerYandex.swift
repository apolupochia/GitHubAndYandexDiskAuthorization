
import Foundation
import UIKit



struct InformationAboutDownloadYandex{
    let repoModel : DiskResponse?
    let networkError : Bool
    let keyError : Bool
    let dataError : Bool
}



 class ApiManagerForYandex {
    
     func requestForYandex(urlString : String) -> URLRequest?{
        
        guard var urlCompanents = URLComponents(string: urlString) else {return nil}

        urlCompanents.queryItems = [
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "client_id", value: "\(YandexInfo.clientId.rawValue)")

        ]
        guard let url = urlCompanents.url else { return nil }
        return URLRequest(url: url)
    
    }
    
    func logOut(urlString : String) -> URLRequest?{
    
        guard let urlCompanents = URLComponents(string: urlString) else {return nil}

        guard let url = urlCompanents.url else { return nil }
        return URLRequest(url: url)
    
    }
    
    
    static func loadDataAboutYandexDisk(urlString : String, key: String, responce: @escaping (InformationAboutDownloadYandex) -> Void) {
        

        guard let request = ApiManagerUrlYandex().takeRequestForLoadData(urlString: urlString, key: key) else {return}
        
        HTTPClient().get(request: request) { data, response, error in
            
            guard (response as? HTTPURLResponse)?.statusCode != nil else {
                responce(InformationAboutDownloadYandex(repoModel: nil, networkError: true, keyError: false, dataError: false))
                return
            }
            
            guard  let data = data else {
                responce(InformationAboutDownloadYandex(repoModel: nil, networkError: false, keyError: false, dataError: true))
                return
            }
            
            guard let newFiles = try? JSONDecoder().decode(DiskResponse.self, from: data) else { 
                responce(InformationAboutDownloadYandex(repoModel: nil, networkError: false, keyError: true, dataError: false))
                return
            }
            
            responce(InformationAboutDownloadYandex(repoModel: newFiles, networkError: false, keyError: false, dataError: false))
        }
        
        
        
    }
    
    static func downloadingImagesFromUrl(urlString : String, responce: @escaping (UIImage?) -> Void) {
       
        guard let request = ApiManagerUrlYandex().takeRequestForDownloadImages(urlString: urlString) else {return}
  
        HTTPClient().get(request: request) { data, response, error in
            guard let data = data else {
                responce(nil)
                return
            }
            let image = UIImage(data: data)
            responce(image)
        }
    }
    

}



class ApiManagerUrlYandex {
    
    func takeRequestForLoadData(urlString : String, key : String) -> URLRequest?{
        var components = URLComponents(string: urlString)
        components?.queryItems = [URLQueryItem(name: "media_type", value: "image")]

        guard let url = components?.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.setValue("OAuth \(key)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func takeRequestForDownloadImages(urlString : String) -> URLRequest?{
        guard  let url = URL(string: (urlString)) else {
            return nil
        }
        let request = URLRequest(url: url)
        
        return request
    }
    
}
