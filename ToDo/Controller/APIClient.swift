//
//  APIClient.swift
//  ToDo
//
//  Created by hanbaoyu on 2017/2/25.
//  Copyright © 2017年 hanbaoyu. All rights reserved.
//

import Foundation
class APIClient {
    lazy var session: URLSessionProtocol = URLSession.shared
    
    func loginUser(withName username: String, password: String, complete :@escaping (Token?, Error?) -> Void) {
        
        guard let expectedUserName = username.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) else {fatalError() }
        guard let expectedPassword = password.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) else {fatalError() }
        let query = "username=\(expectedUserName)&password=\(expectedPassword)"
        
        guard let url = URL(string: "https://some.com/login?\(query)") else {
            fatalError()
        }
        
        session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                complete(nil, error)
                return
            }
            
            guard let data = data else {
                complete(nil, WebServersError.DataEmptyError)
                return
            }
            do{
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                
                let token: Token?
                if let tokenStrign = dict?["token"] {
                    token = Token(id: tokenStrign)
                } else {
                    token = nil
                }
                complete(token, nil)
            } catch {
                complete(nil, error)
            }
        }.resume()
        
    }
}

protocol URLSessionProtocol {
  func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession:URLSessionProtocol {

}

enum WebServersError: Error {
    case DataEmptyError
    case WebServiceError
}
