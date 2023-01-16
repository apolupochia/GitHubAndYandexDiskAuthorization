

import Foundation

final class ApiManagerForGit {

    static func requestForGit() -> URLRequest?{
        guard var urlCompanents = URLComponents(string: "https://github.com/login/oauth/authorize") else {return nil}
        
        urlCompanents.queryItems = [
            URLQueryItem(name: "client_id", value: GitInfo.client_id.rawValue),
            URLQueryItem(name: "redirect_uri", value: GitInfo.redirect_uri.rawValue),
            URLQueryItem(name: "scope", value: GitInfo.scope.rawValue)
        ]
        
        guard let url = urlCompanents.url else { return nil }
        return URLRequest(url: url)
    }
    
    static func logOut() -> URLRequest?{
        
        guard var urlCompanents = URLComponents(string: "https://github.com/logout") else {return nil}
        
        urlCompanents.queryItems = [
        
            URLQueryItem(name: "client_id", value: GitInfo.client_id.rawValue),
            URLQueryItem(name: "redirect_uri", value: "https://github.com"),
            URLQueryItem(name: "scope", value: GitInfo.scope.rawValue)
        ]
        
        guard let url = urlCompanents.url else { return nil }
        return URLRequest(url: url)
    }
    
    
    static func loadTokenFromUrl(url : URL, responce: @escaping (Bool) -> Void) {
        
        let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
        guard let components = URLComponents(string: targetString) else { return }
        let code = components.queryItems?.first(where: {$0.name == "code"})?.value
        if let code = code {
            
            guard var components = URLComponents(string: "https://github.com/login/oauth/access_token") else {return}
            
            components.queryItems = [
                URLQueryItem(name: "client_id", value: GitInfo.client_id.rawValue),
                URLQueryItem(name: "client_secret", value: GitInfo.client_secret.rawValue),
                URLQueryItem(name: "code", value: "\(code)"),
                URLQueryItem(name: "redirect_uri", value: GitInfo.redirect_uri.rawValue)
            ]
            
            guard let url = components.url else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard  let data = data else {return}
                var token : String = ""
                var look = false
                let tokenComponents = String(data: data, encoding: .utf8)
                if let tokenComponents = tokenComponents{
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
                }
                DispatchQueue.main.async {
                    KeychainManagerForPerson.saveDataToKeyChain(service: GitInfo.login.rawValue, password: token)
                    responce(true)
                }
            }
            task.resume()
        }
    }
    
    
    static func loadDataAboutAllRepositories(urlString: String, key: String, responce: @escaping ([RepoModel]?, Bool) -> Void) {
        
        guard let components = URLComponents(string: urlString) else { return }
        
        guard let url = components.url else {return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("token \(key)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        
            guard  let data = data else {
                responce(nil, true)
                return
            }

            guard let newFiles = try? JSONDecoder().decode([RepoModel].self, from: data) else {
                KeychainManagerForPerson.delete(service: GitInfo.login.rawValue)
                responce(nil, false)
                return
            }
            responce(newFiles, false)
        }
        task.resume()
    }
    
    
    
    static func commitsInRepositories(urlString: String, responce: @escaping ([CommitsModel]?, Bool) -> Void) {
        
        guard let components = URLComponents(string: "\(urlString)") else {return}
        guard let url = components.url else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"


        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard  let data = data else {
                responce(nil, true)
                return
            }

            guard let newFiles = try? JSONDecoder().decode([CommitsModel].self, from: data) else {
                responce(nil, false)
                return
            }

            responce(newFiles, false)
        }
        task.resume()
        
    }
}
