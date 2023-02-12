//
//  UrlManagerYandex.swift
//  GitHubAndYandexDiskAuthorizationTests
//
//  Created by Алёша Виноградов on 12.02.2023.
//

import Foundation
import XCTest
@testable import GitHubAndYandexDiskAuthorization


class ApiManagerForYandexTests: XCTestCase {
    
    let session = MockURLSession()
    var urlManager : ApiManagerForYandex!
    
    
    
    override func setUp() {
        super.setUp()
        
        urlManager = ApiManagerForYandex(session: session)
        
    }
    
    override func tearDown() {
        urlManager = nil
        super.tearDown()
    }
    
    
    func testLoadDataAboutYandexDiskForNetworkError() {
        let urlString = "http://www.testableurl.com/"
        session.response = nil

        urlManager.loadDataAboutYandexDisk(urlString: urlString, key: "") { code in
            XCTAssertTrue(code.networkError)
            XCTAssert(code.repoModel == nil)
        }
    }
    
    
    func testLoadDataAboutYandexDiskForNetworkIsOk() {
        let urlString = "http://www.testableurl.com/"
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])

        urlManager.loadDataAboutYandexDisk(urlString: urlString, key: "") { code in
            XCTAssertTrue(!code.networkError)
            XCTAssert(code.repoModel == nil)
            
        }
    }
    
    
    func testLoadDataAboutYandexDiskErrorNil() {
        let urlString = "http://www.testableurl.com/"
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        session.error = nil
        
        urlManager.loadDataAboutYandexDisk(urlString: urlString, key: "") { code in
            XCTAssertTrue(!code.error)
            XCTAssert(code.repoModel == nil)
            
        }
    }
    
    func testLoadDataAboutYandexDiskErrorNotNil() {
        let urlString = "http://www.testableurl.com/"
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        session.error = NSError(domain: "", code: 1, userInfo: [:])
        
        urlManager.loadDataAboutYandexDisk(urlString: urlString, key: "") { code in
            XCTAssertTrue(code.error)
            XCTAssert(code.repoModel == nil)
            
        }
    }
    
    func testLoadDataAboutYandexDiskDataNotNil() {
        
        let urlString = "http://www.testableurl.com/"
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
    
        let expectedData = "{}".data(using: .utf8, allowLossyConversion: false)
        session.returnData = expectedData
        
        urlManager.loadDataAboutYandexDisk(urlString: urlString, key: "") { code in
            XCTAssertTrue(!code.dataError)
            XCTAssert(code.repoModel == nil)
        }
 
    }
    
    func testLoadDataAboutYandexDiskDataNil() {
        
        let urlString = "http://www.testableurl.com/"
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        session.returnData = nil
        
        urlManager.loadDataAboutYandexDisk(urlString: urlString, key: "") { code in
            XCTAssertTrue(code.dataError)
            XCTAssert(code.repoModel == nil)
        }
    }
    
    func testLoadDataAboutYandexDiskDecodeError() {
        
        let urlString = "http://www.testableurl.com/"
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        let expectedData = "{}".data(using: .utf8, allowLossyConversion: false)
        session.returnData = expectedData
        
        urlManager.loadDataAboutYandexDisk(urlString: urlString, key: "") { code in
            XCTAssertTrue(code.decodeError)
            XCTAssertTrue(code.keyError)
            XCTAssert(code.repoModel == nil)
        }
    }
    
    func testLoadDataAboutYandexDiskDecodeNotError() {
        
        let urlString = "http://www.testableurl.com/"
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        
        let model = DiskResponse(items: [DiskFile(name: "", preview: "", size: 0)])
        let modelData = try? JSONEncoder().encode(model)

        session.returnData = modelData
        
        urlManager.loadDataAboutYandexDisk(urlString: urlString, key: "") { code in
            XCTAssertTrue(!code.decodeError)
            XCTAssertTrue(!code.keyError)
            XCTAssert(code.repoModel != nil)
        }
    }
    
    func testLoadDataAboutYandexDiskWithoutAllError() {
        
       
        let urlString = "http://www.testableurl.com/"
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid URL")
            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        
        let model = DiskResponse(items: [DiskFile(name: "", preview: "", size: 0)])
        let modelData = try? JSONEncoder().encode(model)

        session.returnData = modelData
        
        urlManager.loadDataAboutYandexDisk(urlString: urlString, key: "") { code in
            XCTAssert(code.repoModel != nil)
        }
 
    }
    
    
    func testDownloadingImagesFromUrlForNetworkError() {
        let urlString = "https://proprikol.ru/wp-content/uploads/2020/04/kartinki-vulkany-27.jpg"

        urlManager.downloadingImagesFromUrl(urlString: urlString) { image in
            XCTAssertNil(image)
           
        }
    }
    
    func testDownloadingImagesFromUrlWithErrorData() {
        let urlString = "https://proprikol.ru/wp-content/uploads/2020/04/kartinki-vulkany-27.jpg"
        
        let expectedData = "{}".data(using: .utf8, allowLossyConversion: false)
        session.returnData = expectedData
        
        urlManager.downloadingImagesFromUrl(urlString: urlString) { image in
            XCTAssert(image == UIImage(named: "YandexDiskLogo")!)
           
        }
    }
    
    func testDownloadingImagesFromUrlWithRightData() {
        let urlString = "https://proprikol.ru/wp-content/uploads/2020/04/kartinki-vulkany-27.jpg"
        
        
        let modelData = UIImage(named: "GitHubLogo")!.pngData()
        session.returnData = modelData
        
        urlManager.downloadingImagesFromUrl(urlString: urlString) { image in
            XCTAssert(image != UIImage(named: "YandexDiskLogo")!)
            XCTAssertNotNil(image)
            
        }
    }
    
    func testRequestForYandexWithWrongUrlString() {
        let urlString = ""
        
        let request = urlManager.requestForYandex(urlString: urlString)
        XCTAssertNil(request)
    }
    
    func testRequestForYandexWithUrlString() {
        let urlString = "http://www.testableurl.com/"
        
        let request = urlManager.requestForYandex(urlString: urlString)
        XCTAssertNotNil(request)
    }
    
    func testRequestForYandexWithUrlStringAndRightRequest() {
        let urlString = "http://www.testableurl.com/"
        let endResult = "\(urlString)?response_type=token&client_id=\(YandexInfo.clientId.rawValue)"
        
        let request = urlManager.requestForYandex(urlString: urlString)
        XCTAssert((request?.url?.absoluteString ?? "") == endResult)
    }
    
    func testLogOutWithWrongUrlString() {
        let urlString = ""
        
        let request = urlManager.logOut(urlString: urlString)
        XCTAssertNil(request)
    }
    
    func testLogOutWithRightUrlString() {
        let urlString = "http://www.testableurl.com/"
        
        let request = urlManager.logOut(urlString: urlString)
        XCTAssertNotNil(request)
    }
    
    func testLogOutCheckRightResponse() {
        let urlString = "http://www.testableurl.com/"
        
        guard let url = URL(string: urlString) else {
            XCTFail("Invalid URL")
            return
        }
        
        let request = urlManager.logOut(urlString: urlString)
        XCTAssert((request?.url?.absoluteString ?? "") == url.absoluteString)
    }
    
    
    
}


class ApiManagerUrlYandexTests : XCTestCase{
    var urlManager : ApiManagerUrlYandex!
    
    
    
    override func setUp() {
        super.setUp()
        urlManager = ApiManagerUrlYandex()
        
    }
    
    override func tearDown() {
        urlManager = nil
        super.tearDown()
    }
    
    func testTakeRequestForLoadDataWithWrongUrlString(){
        let urlString = ""
        let request = urlManager.takeRequestForLoadData(urlString: urlString, key: "")
        XCTAssertNil(request)
    }
    
    func testTakeRequestForLoadDataWithRightUrlString(){
        let urlString = "http://www.testableurl.com/"
        let request = urlManager.takeRequestForLoadData(urlString: urlString, key: "")
        XCTAssertNotNil(request)
    }
   
    
    func testTakeRequestForLoadDataCheckRightResponse(){
        let urlString = "http://www.testableurl.com/"
        let token = "123_token_321"
        
        let rightResponseUrl = "\(urlString)?media_type=image"
        let rightHTTPHeaderFields : [String : String] = ["Authorization": "OAuth \(token)"]
        
        let request = urlManager.takeRequestForLoadData(urlString: urlString, key: token)
    
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.absoluteString ?? "", rightResponseUrl)
        XCTAssertEqual(request?.allHTTPHeaderFields ?? [:], rightHTTPHeaderFields)
        
    }
    
    
}



