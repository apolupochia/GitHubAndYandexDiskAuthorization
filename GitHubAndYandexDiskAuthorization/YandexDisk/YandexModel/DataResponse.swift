//
//  DataResponse.swift
//  Реализация авторизации в приложении
//
//  Created by Алёша Виноградов on 16.08.2022.
//

import Foundation


struct DiskResponse : Codable{
    
    let items : [DiskFile?]
    
}



struct DiskFile : Codable{
    
    let name : String?
    let preview : String?
    let size : Int64?
    
}
