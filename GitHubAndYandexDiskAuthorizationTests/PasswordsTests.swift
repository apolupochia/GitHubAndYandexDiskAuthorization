//
//  PasswordsTests.swift
//  GitHubAndYandexDiskAuthorizationTests
//
//  Created by Алёша Виноградов on 12.02.2023.
//

import Foundation
import XCTest
@testable import GitHubAndYandexDiskAuthorization


class KeychainManagerForPersonTests: XCTestCase {
    
    var urlManager : KeychainManagerForPerson!
    
    
    
    override func setUp() {
        super.setUp()
        
        urlManager = KeychainManagerForPerson()
        
    }
    
    override func tearDown() {
        urlManager = nil
        super.tearDown()
    }
    
    func testSaveDataToKeyChainWithEmptyLoginAndEmptyPassword(){
        urlManager.saveDataToKeyChain(login: "", password: "")
        XCTAssertTrue(urlManager.error != "", urlManager.error)
    }
    
    func testSaveDataToKeyChainWithEmptyLogin(){
        urlManager.saveDataToKeyChain(login: "", password: "123")
        XCTAssertTrue(urlManager.error != "", urlManager.error)
    }
    
    func testSaveDataToKeyChainWithEmptyPassword(){
        urlManager.saveDataToKeyChain(login: "login", password: "")
        XCTAssertTrue(urlManager.error != "", urlManager.error)
    }
    
    func testSaveDataToKeyChainWithRightPasswordAndRightLogin(){
        let login = "login"
        let password = "password"
        urlManager.saveDataToKeyChain(login: login, password: password)
        XCTAssertTrue(urlManager.error == "", urlManager.error)
        
       
        
        let getPassword = urlManager.loadDataFromKeyChain(login: login)
        XCTAssertNotNil(getPassword)
        XCTAssertTrue(urlManager.error == "")
        
        urlManager.delete(login: "")
        XCTAssertTrue(urlManager.error != "", urlManager.error)
        
        
        urlManager.delete(login: login)
        XCTAssertTrue(urlManager.error == "")
        
    }
    
    func testLoadDataFromKeyChainWithWrongLogin(){
        let getPasswordWithWrongLogin = urlManager.loadDataFromKeyChain(login: "wrongLogin")
        XCTAssertNil(getPasswordWithWrongLogin)
        XCTAssertTrue(urlManager.error != "", urlManager.error)
    }
    
    func testLoadDataFromKeyChainWithRightLogin(){
        let login = "login"
        let password = "password"
        urlManager.saveDataToKeyChain(login: login, password: password)
        
        let getPassword = urlManager.loadDataFromKeyChain(login: login)
        XCTAssertNotNil(getPassword)
        XCTAssertTrue(urlManager.error == "", urlManager.error)
        
        urlManager.delete(login: login)
    }
    
    func testDeleteWithWrongLogin(){
        let login = "login"
        let password = "password"
        urlManager.saveDataToKeyChain(login: login, password: password)
        
        urlManager.delete(login: "wrongLogin")
        
        var getPassword = urlManager.loadDataFromKeyChain(login: login)
        XCTAssertNotNil(getPassword)
        XCTAssertTrue(urlManager.error == "", urlManager.error)
        
        urlManager.delete(login: login)
        
        getPassword = urlManager.loadDataFromKeyChain(login: login)
        XCTAssertNil(getPassword)
        XCTAssertTrue(urlManager.error != "", urlManager.error)
        
    }
    
    
    
}
