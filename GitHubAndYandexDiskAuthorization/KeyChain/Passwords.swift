

import Foundation

class KeychainManagerForPerson{
    
    var error = ""
    
     func saveDataToKeyChain(login : String, password: String){
         
         guard login != "", password != "" else {
             error = "empty login and empty password"
             return
         }
         
         guard login != "" else {
             error = "empty login"
             return
         }
         
         guard password != "" else {
             error = "empty password"
             return
         }
        
        do {
            try KeychainManager.save(login: login, password: password.data(using: .utf8) ?? Data())
        } catch {
            print(error)
        }
    }
    
    
    func loadDataFromKeyChain(login : String) -> String?{
        error = ""
        guard login != "" else {
            error = "empty login"
            return nil
        }
        
        guard let data = KeychainManager.get(login: login) else {
            error = "wrong login / this request without response"
            return nil
        }
        
        let password = String(decoding: data, as: UTF8.self)

        return password

    }
    
    
     func delete(login : String){
         error = ""
         guard login != "" else {
             error = "empty login"
             return
         }
        KeychainManager.delete(login: login)
    
    }
    
    
}



class KeychainManager{
    
    enum KeychainError : Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    static func save(login : String, password : Data) throws{
        
        
        let query : [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : login as AnyObject,
            kSecValueData as String : password as AnyObject
        ]
        
        SecItemDelete(query as CFDictionary)    // если повторяются и нужно удалять прошлые
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else{
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    static func get(login : String)  -> Data?{
        
        let query : [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : login as AnyObject,
         //   kSecAttrAccount as String :account as AnyObject,
            kSecReturnData as String : kCFBooleanTrue,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]
        
        
        var result : AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        
        return result as? Data
    }
    
    
    static func delete(login : String){
        
        let query : [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : login as AnyObject,
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}






