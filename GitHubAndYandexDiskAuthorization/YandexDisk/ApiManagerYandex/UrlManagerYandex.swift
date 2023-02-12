
import Foundation
import UIKit



struct InformationAboutDownloadYandex{
    let repoModel : DiskResponse?
    let networkError : Bool
    let keyError : Bool
    let dataError : Bool
    let decodeError : Bool
    let error : Bool
    
    init(repoModel : DiskResponse? = nil,
         networkError : Bool = false,
         keyError : Bool = false,
         dataError : Bool = false,
         decodeError : Bool = false,
         error : Bool = false )
    {
        self.repoModel = repoModel
        self.networkError = networkError
        self.keyError = keyError
        self.dataError = dataError
        self.decodeError = decodeError
        self.error = error
    }
}



 class ApiManagerForYandex {
     
     private let session: URLSessionProtocol
     init(session: URLSessionProtocol = URLSession.shared) {
         self.session = session
     }
    
     func requestForYandex(urlString : String) -> URLRequest?{
         guard let _ = URL(string: urlString) else { return nil }
        
        guard var urlCompanents = URLComponents(string: urlString) else {return nil}

        urlCompanents.queryItems = [
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "client_id", value: "\(YandexInfo.clientId.rawValue)")

        ]
        guard let url = urlCompanents.url else { return nil }
        return URLRequest(url: url)
    
    }
    
    func logOut(urlString : String) -> URLRequest?{
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    
    }
    
    
    func loadDataAboutYandexDisk(urlString : String, key: String, completion: @escaping (InformationAboutDownloadYandex) -> Void) {
        guard let _ = URL(string: urlString) else { return }

        guard let request = ApiManagerUrlYandex().takeRequestForLoadData(urlString: urlString, key: key) else {return}
        
        HTTPClient(session: session).get(request: request) { data, response, error in
            
            guard (response as? HTTPURLResponse)?.statusCode != nil else {
                completion(InformationAboutDownloadYandex( networkError: true))
                return
            }
            
            guard  error == nil else {
                completion(InformationAboutDownloadYandex(error : true))
                return
            }
            
            guard  let data = data else {
                completion(InformationAboutDownloadYandex(dataError: true))
                return
            }
            
            guard let newFiles = try? JSONDecoder().decode(DiskResponse.self, from: data) else { 
                completion(InformationAboutDownloadYandex( keyError: true , decodeError: true))
                return
            }
            
            completion(InformationAboutDownloadYandex(repoModel: newFiles))
        }
        
        
        
    }
    
    func downloadingImagesFromUrl(urlString : String, completion: @escaping (UIImage?) -> Void) {
     //   print(urlString)
        guard let _ = URL(string: urlString) else {
            completion(nil)
            return
        }
        guard let request = ApiManagerUrlYandex().takeRequestForDownloadImages(urlString: urlString) else {return}
  
        HTTPClient(session: session).get(request: request) { data, response, error in
            
//            guard (response as? HTTPURLResponse)?.statusCode != nil else {
//                completion(nil)
//                return
//            }
//            guard  error == nil else {
//                completion(nil)
//                return
//            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            guard let image = UIImage(data: data) else {
                completion(UIImage(named: "YandexDiskLogo")!)
                return
            }
            completion(image)
        }
    }
    

}



class ApiManagerUrlYandex {
    
    func takeRequestForLoadData(urlString : String, key : String) -> URLRequest?{
        guard  let _ = URL(string: urlString) else { return nil }
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
        guard  let url = URL(string: urlString) else { return nil }

        return URLRequest(url: url)
    }
    
}
