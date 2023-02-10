

import Foundation

struct InformationAboutDownloadGitHub{
    let repoModel : [RepoModel]?
    let commitsModel : [CommitsModel]?
    let networkError : Bool
    let keyError : Bool
    let dataError : Bool
    let decodeError : Bool
    
    init(repoModel: [RepoModel]? = nil,
         commitsModel: [CommitsModel]? = nil,
         networkError: Bool = false,
         keyError: Bool = false,
         dataError: Bool = false,
         decodeError : Bool = false
    ){
            self.repoModel = repoModel
            self.commitsModel = commitsModel
            self.networkError = networkError
            self.keyError = keyError
            self.dataError = dataError
            self.decodeError = decodeError
    }
}

class ApiManagerForGit{
    
    func requestForGit(urlString : String) -> URLRequest?{
        guard var urlCompanents = URLComponents(string: urlString) else {return nil}
        
        urlCompanents.queryItems = [
            URLQueryItem(name: "client_id", value: GitInfo.client_id.rawValue),
            URLQueryItem(name: "redirect_uri", value: GitInfo.redirect_uri.rawValue),
            URLQueryItem(name: "scope", value: GitInfo.scope.rawValue)
        ]
        
        guard let url = urlCompanents.url else { return nil }
        return URLRequest(url: url)
    }
    
    func requestLogOut(urlString : String) -> URLRequest?{
        
        guard var urlCompanents = URLComponents(string: urlString) else {return nil}
        
        urlCompanents.queryItems = [
        
            URLQueryItem(name: "client_id", value: GitInfo.client_id.rawValue),
            URLQueryItem(name: "redirect_uri", value: "https://github.com"),
            URLQueryItem(name: "scope", value: GitInfo.scope.rawValue)
        ]
        
        guard let url = urlCompanents.url else { return nil }
        return URLRequest(url: url)
    }
    
    
    
    func takeTokenAndSave(url : URL, answerAboutSaving: @escaping (Bool) -> Void) {
                
        guard let url  = ApiManagerUrlGitHub().takeUrlForLoadToken(url: url) else {
            answerAboutSaving(false)
            return }
        
        HTTPClient().get(url: url) { data, response, error in
            
            guard  let data = data else {return}
            guard let tokenComponents = String(data: data, encoding: .utf8) else {return}
            self.remakeUrlToTokenAndSave(tokenComponents: tokenComponents) { responce in
                answerAboutSaving(responce)
            }
            
        }
    }
    
    func takeCommitsFromAri(urlString : String, completion: @escaping (InformationAboutDownloadGitHub) -> Void){
        
        guard let url = ApiManagerUrlGitHub().takeUrlFromString(urlString: urlString) else { return }
        HTTPClient().get(url: url) { data, response, error in
            
            guard (response as? HTTPURLResponse)?.statusCode != nil else {
                completion(InformationAboutDownloadGitHub(networkError: true))
                return
            }
            
            guard  let data = data else {
                completion(InformationAboutDownloadGitHub(dataError: true))
                return
            }

            guard let newFiles = try? JSONDecoder().decode([CommitsModel].self, from: data) else {
                completion(InformationAboutDownloadGitHub(decodeError: true))
                return
            }
            
            completion(InformationAboutDownloadGitHub(commitsModel: newFiles))
            
            
        }
    }
   
    func loadDataAboutAllRepositories(urlString: String, key: String, responce: @escaping (InformationAboutDownloadGitHub) -> Void) {
        guard let request = ApiManagerUrlGitHub().requestFromUrlAndKey(urlString: urlString, key: key) else {return}
        HTTPClient().get(request: request) { data, response, error in

            guard (response as? HTTPURLResponse)?.statusCode != nil else {
                responce(InformationAboutDownloadGitHub(repoModel: nil, networkError: true, keyError: false, dataError: false))
                return
            }
            
            guard  let data = data else {
                responce(InformationAboutDownloadGitHub(repoModel: nil, networkError: false, keyError: false, dataError: true))
                return
            }

            guard let newFiles = try? JSONDecoder().decode([RepoModel].self, from: data) else {
                responce(InformationAboutDownloadGitHub(repoModel: nil, networkError: false, keyError: true, dataError: false))
                return
            }
            
            responce(InformationAboutDownloadGitHub(repoModel: newFiles, networkError: false, keyError: false, dataError: false))
        }
    }
    
    
    private func remakeUrlToTokenAndSave(tokenComponents : String , responce: @escaping (Bool) -> Void){
        var token : String = ""
        var look = false
        for tokenComponent in tokenComponents{
                
            if tokenComponent == "&"{
                look = false
                break
            }
                
            if look == true{
                token.append(tokenComponent)
            }
            
            if tokenComponent == "="{
                look = true
            }
        }
        DispatchQueue.main.async {
            KeychainManagerForPerson.saveDataToKeyChain(service: GitInfo.login.rawValue, password: token)
            responce(true)
        }
        
    }
    
}



class ApiManagerUrlGitHub {
    
    func takeUrlForLoadToken(url : URL) -> URL?{
        
        let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
        guard let components = URLComponents(string: targetString) else { return nil }
        let code = components.queryItems?.first(where: {$0.name == "code"})?.value
        if let code = code {
            
            guard var components = URLComponents(string: "https://github.com/login/oauth/access_token") else {return nil }
            
            components.queryItems = [
                URLQueryItem(name: "client_id", value: GitInfo.client_id.rawValue),
                URLQueryItem(name: "client_secret", value: GitInfo.client_secret.rawValue),
                URLQueryItem(name: "code", value: "\(code)"),
                URLQueryItem(name: "redirect_uri", value: GitInfo.redirect_uri.rawValue)
            ]
            
            guard let url = components.url else {return nil}
            
            return url
        }
        
        return nil
    }
    
    func takeUrlFromString(urlString : String) -> URL?{
        
        guard let components = URLComponents(string: urlString) else {return nil}
        guard let url = components.url else {return nil}
        return url
        
    }
    
    func requestFromUrlAndKey(urlString: String, key: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("token \(key)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    
}

