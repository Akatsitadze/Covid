//
//  NetworkLayer.swift
//  covid19api
//
//  Created by Anzori Katsitadze on 8/5/20.
//  Copyright © 2020 Anzori Katsitadze. All rights reserved.
//

import Foundation


enum NetworkError: Error {
    case invalidURL
    case noData
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct RequestData {
    let path: String
    let baseURL: String
    var method: HTTPMethod
    var params: [String: Any?]?
    var headers: [String: String]?

    var url: String {
        get {
            return baseURL.appending(path)
        }
    }
    
    init(path: String,
         baseURL: String = AppConfig.shared().BaseUrl,
         method: HTTPMethod = .post,
         params: [String: Any?]? = nil,
         headers: [String: String]? = ["referer": "https://www.arcgis.com/apps/opsdashboard/index.html"]
    ) {
        self.path = path
        self.baseURL = baseURL
        self.method = method
        self.params = params
        self.headers = headers
    }
}

protocol RequestType {
    associatedtype ResponseType: Decodable
    var data: RequestData { get }
}

protocol DataRequestType {
    associatedtype ResponseType: Decodable
    var data: RequestData { get }
}

extension RequestType {
    public func execute(dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher(),
                        success: @escaping (ResponseType)->Void,
                        failure: ((Error)->Void)?) {
        dispatcher.dispatch(request: data, success: { data in
            do {
                let result = try JSONDecoder().decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    success(result)
                }
            } catch let error {
                DispatchQueue.main.async {
                    failure?(error)
                }
            }
        }) { error in
            DispatchQueue.main.async {
                failure?(error)
            }
        }
    }
}

extension DataRequestType {
    public func execute(dispatcher: NetworkDispatcher = URLSessionNetworkDispatcher(),
                        success: @escaping (Data?)->Void,
                        failure: ((Error)->Void)?) {
        dispatcher.dispatch(request: data, success: { data in
            DispatchQueue.main.async {
                success(data)
            }
        }) { error in
            DispatchQueue.main.async {
                failure?(error)
            }
        }
    }
}

protocol NetworkDispatcher {
    func dispatch(request: RequestData, success: @escaping (Data)->Void, failure: @escaping (Error)->Void)
}

struct URLSessionNetworkDispatcher: NetworkDispatcher {
    func dispatch(request: RequestData, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) {
        guard let url = URL(string: request.url) else {
            failure(NetworkError.invalidURL)
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        do {
            if let params = request.params, params.count > 0 {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
            }
        } catch let error {
            failure(error)
            return
        }
        
        if let headers = request.headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in            
            if let error = error {
                failure(error)
                return
            }
            
            guard let data = data else {
                failure(NetworkError.noData)
                return
            }
            
            success(data)
        }.resume()
    }
}
