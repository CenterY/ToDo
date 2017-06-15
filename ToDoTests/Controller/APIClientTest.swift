//
//  APIClientTest.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/25.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import XCTest
@testable import ToDo


class APIClientTest: XCTestCase {
    
    var sut = APIClient()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Login_UsesExpectURL()  {
        let mockURLSection = MockURLSession(data: nil, urlresponse:nil, error: nil)
        sut.session = mockURLSection
        
        let complete = {(token: Token?, error: Error?) in}
        sut.loginUser(withName: "name", password: "1%3&4", complete: complete)
        guard let url = mockURLSection.url else {
            XCTFail()
            return
        }
        
        let urlcomp = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        XCTAssertEqual(urlcomp?.host, "some.com")
        XCTAssertEqual(urlcomp?.path, "/login")
        XCTAssertEqual(urlcomp?.query, "username=name&password=1%3&4")
    }
    
    func test_Login_WhenSucessful_CreatesToken() {
        let jsonData = "{\"token\":\"1234567890\"}".data(using: .utf8)
        let mockSession = MockURLSession(data: jsonData, urlresponse: nil, error: nil)
        
        sut.session = mockSession
        let tokenExpectation = expectation(description: "Token")
        
        var catchToken: Token?
        
        sut.loginUser(withName: "name", password: "pwd") { (token, error) in
           catchToken = token
            tokenExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertEqual(catchToken?.id, "1234567890")
        }
        
    }
    
    func test_Login_WhenJsonIsInvalid_ReturnsError() {
        let mockSession = MockURLSession(data: Data(), urlresponse: nil, error: nil)
        
        sut.session = mockSession
        let errorExpectation = expectation(description: "Error")
        
        var catchError: Error? = nil
        
        sut.loginUser(withName: "name", password: "pwd") { (token, error) in
            catchError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(catchError)
        }
    }
    
    func test_Login_WhenDataIsNil_ReturnsError() {
        
        let mockSession = MockURLSession(data: nil, urlresponse: nil, error: nil)
        
        sut.session = mockSession
        let errorExpectation = expectation(description: "Error")
        
        var catchError: Error? = nil
        
        sut.loginUser(withName: "name", password: "pwd") { (token, error) in
            catchError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(catchError)
        }
    }
    func test_Login_WhenResponseHasError_ReturnsError() {
        let jsonData = "{\"token\":\"1234567890\"}".data(using: .utf8)
        
        let error = NSError(domain: "ServerError",code:123, userInfo:nil)
        
        let mockSession = MockURLSession(data: jsonData, urlresponse: nil, error: error)
        
        sut.session = mockSession
        let errorExpectation = expectation(description: "Error")
        
        var catchError: Error? = nil
        
        sut.loginUser(withName: "name", password: "pwd") { (token, error) in
            catchError = error
            errorExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(catchError)
        }
    }
    
}

extension APIClientTest {
    class MockURLSession: URLSessionProtocol {
        var url: URL?
        private let dataTask: MockTask
        
        init(data: Data?, urlresponse: URLResponse?, error: Error?) {
            dataTask = MockTask(data: data, urlresponse: urlresponse, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            
            dataTask.complete = completionHandler
            return dataTask
        }
        
    }
    
    class MockTask: URLSessionDataTask {
        private let data: Data?
        private let urlresponse: URLResponse?
        private let responseError: Error?
        
        typealias CompleteHandle = (Data?, URLResponse?, Error?)->Void
        
        var complete: CompleteHandle?
        
        init(data: Data?, urlresponse: URLResponse?, error: Error?) {
            self.data = data
            self.urlresponse = urlresponse
            self.responseError = error
            
            
        }
        
        override func resume() {
            DispatchQueue.main.async() {
                self.complete?(self.data, self.urlresponse, self.responseError)
            }
        }
        
    }
}
