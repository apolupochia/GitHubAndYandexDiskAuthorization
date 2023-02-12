//
//  UrlManagerGitHub.swift
//  GitHubAndYandexDiskAuthorizationTests
//
//  Created by Алёша Виноградов on 11.02.2023.
//


import XCTest
@testable import GitHubAndYandexDiskAuthorization


class UrlManagerGitHubTest: XCTestCase {
    
    let session = MockURLSession()
    var urlManager : ApiManagerForGit!
    
    

    override func setUp() {
        super.setUp()
    
        urlManager = ApiManagerForGit(session: session)

    }

    override func tearDown() {
        urlManager = nil
        super.tearDown()
    }

    func testTakeCommitsFromApiForNetworkError() {
        
        session.response = nil

        urlManager.takeCommitsFromApi(urlString: "http://www.testableurl.com/") { code in
            XCTAssertTrue(code.networkError)
            
        }
 
    }
    
    func testTakeCommitsFromApiForNetworkIsOk() {
        
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
    

        
        urlManager.takeCommitsFromApi(urlString: "http://www.testableurl.com/") { code in
            XCTAssertTrue(!code.networkError)
            
        }
 
    }
    
    func testTakeCommitsFromApiErrorNil() {
        
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
    
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
 
    
        session.error = nil

        
        urlManager.takeCommitsFromApi(urlString: "http://www.testableurl.com/") { code in
            XCTAssertTrue(!code.error)
            
        }
 
    }
    
    func testTakeCommitsFromApiErrorNotNil() {
        
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])

        session.error = NSError(domain: "", code: 1, userInfo: [:])

        
        urlManager.takeCommitsFromApi(urlString: "http://www.testableurl.com/") { code in
            XCTAssertTrue(code.error)
            
        }
 
    }
    
    func testTakeCommitsFromApiDataNotNil() {
        
       
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
    
        let expectedData = "{}".data(using: .utf8, allowLossyConversion: false)
        session.returnData = expectedData
        
        urlManager.takeCommitsFromApi(urlString: "http://www.testableurl.com/") { code in
            XCTAssertTrue(!code.dataError)
        }
 
    }
    
    
    func testTakeCommitsFromApiDecodeError() {
        
       
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        
        let expectedData = "{}".data(using: .utf8, allowLossyConversion: false)
        session.returnData = expectedData
        
        urlManager.takeCommitsFromApi(urlString: "http://www.testableurl.com/") { code in
            XCTAssertTrue(code.decodeError)
        }
 
    }
    
    func testTakeCommitsFromApiDecodeNotError() {
        
       
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        
        let model = CommitsModel(sha: "", node_id: "", commit: Commit(author: CommitAuthor(name: "q", email: "", date: ""), committer: CommitAuthor(name: "", email: "", date: ""), message: "", tree: Tree(sha: "", url: ""), url: "", comment_count: 1))
    
        
        let modelData = try? JSONEncoder().encode([model])

        session.returnData = modelData
        
        urlManager.takeCommitsFromApi(urlString: "http://www.testableurl.com/") { code in
            print(code)
            XCTAssertTrue(!code.decodeError)
        }
 
    }
    
    func testTakeCommitsFromApiReturnModelWithoutAllError() {
        
       
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        
        let model = CommitsModel(sha: "", node_id: "", commit: Commit(author: CommitAuthor(name: "q", email: "", date: ""), committer: CommitAuthor(name: "", email: "", date: ""), message: "", tree: Tree(sha: "", url: ""), url: "", comment_count: 1))
  
        let modelData = try? JSONEncoder().encode([model])
        session.returnData = modelData
        
        urlManager.takeCommitsFromApi(urlString: "http://www.testableurl.com/") { code in
            XCTAssert(code.commitsModel != nil)
        }
 
    }
 
    
    
    func testLoadDataAboutAllRepositoriesForNetworkError() {
        
        session.response = nil
        
        urlManager.loadDataAboutAllRepositories(urlString: "http://www.testableurl.com/", key: "") { code in
            XCTAssertTrue(code.networkError)
        }

 
    }
    
    func testLoadDataAboutAllRepositoriesForNetworkIsOk() {
        
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
    

        urlManager.loadDataAboutAllRepositories(urlString: "http://www.testableurl.com/", key: "") { code in
            XCTAssertTrue(!code.networkError)
        }
 
    }
    
    func testLoadDataAboutAllRepositoriesErrorNil() {
        
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
    
 
    
        session.error = nil

        urlManager.loadDataAboutAllRepositories(urlString: "http://www.testableurl.com/", key: "") { code in
            XCTAssertTrue(!code.error)
        }
 
    }
    
    func testLoadDataAboutAllRepositoriesErrorNotNil() {
        
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])

        session.error = NSError(domain: "", code: 1, userInfo: [:])

        
        urlManager.loadDataAboutAllRepositories(urlString: "http://www.testableurl.com/", key: "") { code in
            XCTAssertTrue(code.error)
        }
 
    }
    
    func testLoadDataAboutAllRepositoriesDataNotNil() {
        
       
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
    
        let expectedData = "{}".data(using: .utf8, allowLossyConversion: false)
        session.returnData = expectedData
        
        urlManager.loadDataAboutAllRepositories(urlString: "http://www.testableurl.com/", key: "") { code in
            XCTAssertTrue(!code.dataError)
        }
 
    }
    
    
    func testLoadDataAboutAllRepositoriesDecodeError() {
        
       
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        
        let expectedData = "{}".data(using: .utf8, allowLossyConversion: false)
        session.returnData = expectedData
        
        urlManager.loadDataAboutAllRepositories(urlString: "http://www.testableurl.com/", key: "") { code in
            
            XCTAssertTrue(code.decodeError)
        }

 
    }
    
    func testLoadDataAboutAllRepositoriesDecodeNotError() {
        
       
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        
        let model = RepoModel(id: 0, node_id: "", name: "", full_name: "", owner: Owner(login: "", id: 0, node_id: "", avatar_url: ""), url: "", forks_count: 0, forks: 0, watchers: 0)
    
       
        
        let modelData = try? JSONEncoder().encode([model])

        session.returnData = modelData
        
        urlManager.loadDataAboutAllRepositories(urlString: "http://www.testableurl.com/", key: "") { code in
            XCTAssertTrue(!code.decodeError)
        }
 
    }
    
    func testLoadDataAboutAllRepositoriesReturnModelWithoutAllError() {
        
       
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        
        let model = RepoModel(id: 0, node_id: "", name: "", full_name: "", owner: Owner(login: "", id: 0, node_id: "", avatar_url: ""), url: "", forks_count: 0, forks: 0, watchers: 0)
    
        let modelData = try? JSONEncoder().encode([model])

        session.returnData = modelData
        
        urlManager.loadDataAboutAllRepositories(urlString: "http://www.testableurl.com/", key: "") { code in
            print(code)
            XCTAssert(code.repoModel != nil)
        }
 
    }
    
    func testRequestForGitErrorString(){
        let request = urlManager.requestForGit(urlString: "")
        XCTAssert(request == nil)
    }
    
    func testRequestForGitString(){
        let urlString = "http://www.testableurl.com/"
        let correctString = "\(urlString)?client_id=\(GitInfo.client_id.rawValue)&redirect_uri=\(GitInfo.redirect_uri.rawValue)&scope=user%20repo"
        let request = urlManager.requestForGit(urlString: urlString)
        XCTAssert((request?.url?.absoluteString ?? "") == correctString)
    }
    
    func testRequestLogOutErrorString(){
        let request = urlManager.requestLogOut(urlString: "")
        XCTAssert(request == nil)
    }
    
    func testRequestLogOutString(){
        let urlString = "http://www.testableurl.com/"
        let correctString = "\(urlString)?client_id=\(GitInfo.client_id.rawValue)&redirect_uri=\(GitInfo.redirect_url_logout.rawValue)&scope=user%20repo"
        let request = urlManager.requestLogOut(urlString: urlString)
        XCTAssert((request?.url?.absoluteString ?? "") == correctString)
    }
    
    func testTakeTokenAndSaveWrongUrl(){
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        urlManager.takeTokenAndSave(url: url, login: "") { bool in
            XCTAssertTrue(!bool)
        }
    }
    
    func testTakeTokenAndSaveRightUrl(){
        
        let login = "login"
        
        guard let url = URL(string: "it.iacopo.github://authentication?code=123") else {
            XCTFail("Invalid URL")
            return
        }
        
        urlManager.takeTokenAndSave(url: url, login: login) { bool in
            XCTAssertTrue(bool)
            KeychainManagerForPerson().delete(login: login)
        }
    }
    
    func testRemakeUrlToTokenAndSavRightString(){
        let login = "login"
        let rightString = "=123&"
        urlManager.remakeUrlToTokenAndSave(tokenComponents: rightString, login: login) { bool in
            XCTAssertTrue(bool)
            KeychainManagerForPerson().delete(login: login)
        }
    }
    
    func testRemakeUrlToTokenAndSavWrongString(){
        let login = "login"
        var wrongString = "123"
        urlManager.remakeUrlToTokenAndSave(tokenComponents: wrongString, login: login) { bool in
            XCTAssertTrue(!bool)
            KeychainManagerForPerson().delete(login: login)
        }
        
        wrongString = ""
        urlManager.remakeUrlToTokenAndSave(tokenComponents: wrongString, login: login) { bool in
            XCTAssertTrue(!bool)
            KeychainManagerForPerson().delete(login: login)
        }
    }
}



class ApiManagerUrlGitHubTest: XCTestCase {
    
    var urlManager : ApiManagerUrlGitHub!
    
    override func setUp() {
        super.setUp()
        urlManager = ApiManagerUrlGitHub()
    }
    
    override func tearDown() {
        urlManager = nil
        super.tearDown()
    }
    
    
    func testTakeUrlForLoadTokenWrongUrl(){
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")
            return
        }
        let request = urlManager.takeUrlForLoadToken(url: url)
        XCTAssert(request == nil)
    }
    
    func testTakeUrlForLoadTokenRightUrl(){
        let codeUrlToKey = "123"
        guard let url = URL(string: "it.iacopo.github://authentication?code=\(codeUrlToKey)") else {
            XCTFail("Invalid URL")
            return
        }

        let endUrl = "https://github.com/login/oauth/access_token?client_id=\(GitInfo.client_id.rawValue)&client_secret=\(GitInfo.client_secret.rawValue)&code=\(codeUrlToKey)&redirect_uri=\(GitInfo.redirect_uri.rawValue)"

        let request = urlManager.takeUrlForLoadToken(url: url)
        XCTAssert((urlManager.codeFromUrl ?? "") == codeUrlToKey)
        XCTAssert(endUrl == request?.absoluteURL.absoluteString)
    }
    
    func testTakeUrlFromStringWrongString(){
        let wrongString = ""
        let url = urlManager.takeUrlFromString(urlString: wrongString)
        XCTAssert(url == nil)
    }
    
    func testTakeUrlFromStringRightString(){
        let rightString = "http://www.testableurl.com/"
        let url = urlManager.takeUrlFromString(urlString: rightString)
        XCTAssert(url != nil)
    }
    
    func testRequestFromUrlAndKeyWrongString(){
        let wrongString = ""
        let request = urlManager.requestFromUrlAndKey(urlString: wrongString, key: "")
        XCTAssert(request == nil)
    }
    
    func testRequestFromUrlAndKeyRightString(){
        let rightString = "http://www.testableurl.com/"
        let token = "123_token_321"
        let request = urlManager.requestFromUrlAndKey(urlString: rightString, key: token)
        
        let allHTTPHeader : [String : String] = ["Authorization": "token \(token)"]
        XCTAssert((request?.allHTTPHeaderFields ?? ["":""]) == allHTTPHeader)
        
        XCTAssert((request?.url?.absoluteString ?? "") == rightString)
        XCTAssert((request?.httpMethod ?? "") == "GET")
        
    }
    
}
