

import Foundation

class KeychainManagerForPerson{
    static func saveDataToKeyChain(service : String, password: String){
        
        do {
            try KeychainManager.save(service: service, password: password.data(using: .utf8) ?? Data())
        } catch {
            print(error)
        }
    }
    
    
    static func loadDataFromKeyChain(service : String) -> String?{

        
        guard let data = KeychainManager.get(service: service) else {
            print("failed to get")
            return nil
        }
        
        let password = String(decoding: data, as: UTF8.self)

        return password

    }
    
    
    static func delete(service : String){
        KeychainManager.delete(service: service)
    
    }
    
    
}



class KeychainManager{
    
    enum KeychainError : Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    static func save(service : String, password : Data) throws{
        
        
        let query : [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : service as AnyObject,
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
    
    static func get(service : String)  -> Data?{
        
        let query : [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : service as AnyObject,
         //   kSecAttrAccount as String :account as AnyObject,
            kSecReturnData as String : kCFBooleanTrue,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]
        
        
        var result : AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        
        return result as? Data
    }
    
    
    static func delete(service : String){
        
        let query : [String : AnyObject] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrService as String : service as AnyObject,
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}






