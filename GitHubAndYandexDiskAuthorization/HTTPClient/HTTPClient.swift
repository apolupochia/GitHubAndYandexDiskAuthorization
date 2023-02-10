

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completion)
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

class HTTPClient {

    typealias completeClosure = (_ data: Data?,_ response: URLResponse?, _ error: Error?) -> Void

    private let session: URLSessionProtocol


    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func get(url: URL, callback: @escaping completeClosure) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            callback(data, response, error)
        }
        task.resume()
    }
    
    func get(request:URLRequest , callback: @escaping completeClosure) {
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            callback(data, response, error)
        }
        task.resume()
    }
    
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private(set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}

class MockURLSession: URLSessionProtocol {
    private(set) var url: URL?

    var returnData: Data?
    var dataTask = MockURLSessionDataTask()

    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        url = request.url
        completion(returnData, nil, nil)

        return dataTask
    }
}







