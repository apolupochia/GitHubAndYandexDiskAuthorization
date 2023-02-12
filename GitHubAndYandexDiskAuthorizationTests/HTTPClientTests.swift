//
//  GitHubAndYandexDiskAuthorizationTests.swift
//  GitHubAndYandexDiskAuthorizationTests
//
//  Created by Алёша Виноградов on 10.02.2023.
//




import XCTest
@testable import GitHubAndYandexDiskAuthorization

class HTTPClientTest: XCTestCase {
    let session = MockURLSession()

    var httpClient: HTTPClient!

    override func setUp() {
        super.setUp()

        httpClient = HTTPClient(session: session)
    }

    override func tearDown() {
        httpClient = nil

        super.tearDown()
    }

    func testHTTPRequest() {
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")

            return
        }
        httpClient.get(url: url) { (data, response, error) in
            // Handler response data
            
        }

        XCTAssert(session.url == url)
    }

    func testDataTaskWasCalled() {
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")

            return
        }
        httpClient.get(url: url) { (data, response,  error) in
            // Handler response data
        }

        XCTAssertTrue(session.dataTask.resumeWasCalled)
    }

    func testDataWasReturned() {
        let expected = expectation(description: "Return data is not nil")

        let expectedData = "{}".data(using: .utf8, allowLossyConversion: false)
        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")

            return
        }

        session.returnData = expectedData
        httpClient.get(url: url) { (data, response, error) in
            // Handler response data
            XCTAssertNotNil(data)

            guard let data = data, let string = String(data: data, encoding: .utf8) else {
                XCTFail("Return string is nil")
                return
            }
            XCTAssertEqual(string, "{}")

            expected.fulfill()
        }

        waitForExpectations(timeout: 5) { error in

        }
    }
    
    func testResponseNil() {

        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")

            return
        }
        session.response = nil
        httpClient.get(url: url) { (data, response, error) in
            // Handler response data
           // XCTAssertNotNil(data)
            XCTAssert(response == nil)
 
        }
    }
    
    func testResponseNotNil() {

        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")

            return
        }
        session.response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "", headerFields: [:])
        httpClient.get(url: url) { (data, response, error) in
            // Handler response data
           // XCTAssertNotNil(data)
            XCTAssert(response != nil)
 
        }
    }
    
    
    func testErrorNil() {

        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")

            return
        }
        session.error = nil
        httpClient.get(url: url) { (data, response, error) in
            // Handler response data
           // XCTAssertNotNil(data)
            XCTAssert(error == nil)
 
        }
    }
    
    func testErrorNotNil() {

        guard let url = URL(string: "http://www.testableurl.com/") else {
            XCTFail("Invalid URL")

            return
        }
        session.error = NSError(domain: "", code: 1, userInfo: [:])
        httpClient.get(url: url) { (data, response, error) in
            // Handler response data
           // XCTAssertNotNil(data)
            XCTAssert(error != nil)
 
        }
    }
  
}
