//
//  AppAPI.swift
//  TrainningIOS112017
//
//  Created by TuyenVX on 12/7/17.
//  Copyright © 2017 TuyenVX. All rights reserved.
//

import Foundation

enum ApiType {
    case register
    case login
    case logout
    case token
    case getChatRoom
    case dowloadImage
    case userInfo
}
enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
enum RequestResult {
    case success([String: Any])
    case unSuccess([String: Any])
    case failure(Error?)
}
struct AppAPI {
    private static let baseURL = "https://thl.herokuapp.com/api/v1"
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    private var dataTask: URLSessionDataTask?
    //
    func getURL(api: ApiType, param: [String: Any]?) -> String {
        var url: String = ""
        switch api {
        case .register:
            url = "/users"
        case .login:
            url = "/login"
        case .logout:
            url = "/logout"
        case .token:
            url = "/token"
        case .getChatRoom:
            url = "/chatroom?page=\(param![AppKey.page] ?? 0)&page_size=\(param![AppKey.pageSize] ?? 10)"
        case .dowloadImage:
            if let imageURL = param![AppKey.avatarUrl] as? String {
                return imageURL
            }
        case .userInfo:
            url = "/users/me"
        }
        return AppAPI.baseURL + url
    }
    // request login/ register
    mutating func requestURLEncoded(httpMethod: HttpMethod, param: [String: String], apiType: ApiType, completionHandle: @escaping (RequestResult) -> Void) {
        dataTask?.cancel()
        let urlString = self.getURL(api: apiType, param: param)
        guard let url = URL(string: urlString) else {
            return
        }
        var request = URLRequest.init(url: url)
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: AppKey.contentType)
        request.setValue("application/json", forHTTPHeaderField: AppKey.accept)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = encodeParameters(parameters: param)
        dataTask = session.dataTask(with: request) { (data, _, error) in
            if let jsonData = data {
                // success
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    guard let responseData = jsonObject as? [String: Any] else {
                        completionHandle(.failure(error))
                        return
                    }
                    if responseData[AppKey.success] as? Int == 1 {
                        completionHandle(.success(responseData))
                    } else {
                        completionHandle(.unSuccess(responseData))
                    }
                } catch let error {
                    completionHandle(.failure(error))
                }
            } else {
                completionHandle(.failure(error))
            }
        }
        dataTask?.resume()
    }
    private func encodeParameters(parameters: [String: String]) -> Data {
        let array = Array(parameters.keys.map { "\($0)=\(parameters[$0]!)" })
        print(array.joined(separator: "&"))
        let data = array.joined(separator: "&").data(using: String.Encoding.utf8)
        return data!
    }
    mutating func request(httpMethod: HttpMethod, param: [String: Any]?, apiType: ApiType, completionHandle: @escaping (RequestResult) -> Void) {
        dataTask?.cancel()
        let url = self.getURL(api: apiType, param: param)
        var request = URLRequest.init(url: URL(string: url)!)
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: AppKey.contentType)
        request.setValue("application/json", forHTTPHeaderField: AppKey.accept)
        request.httpMethod = httpMethod.rawValue
        if apiType != .register {
            if let token = UserDefaults.standard.value(forKey: AppKey.token) as? [String: String] {
                let accessToken = token[AppKey.accessToken]
                let tokenString = "JWT" + " " + accessToken!
                request.setValue(tokenString, forHTTPHeaderField: AppKey.authorization)
            }
        }
        if param != nil && httpMethod == .post {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: param!, options: .prettyPrinted)
                request.httpBody = jsonData
            } catch {
                print(error)
            }
        }
        dataTask = session.dataTask(with: request) { (data, _, error) in
            if let jsonData = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    guard let responseData = jsonObject as? [String: Any] else {
                        completionHandle(.failure(error))
                        return
                    }
                    if responseData[AppKey.success] as? Int == 1 {
                        completionHandle(.success(responseData))
                    } else {
                        completionHandle(.unSuccess(responseData))
                    }
                } catch let error {
                    completionHandle(.failure(error))
                }
            } else {
                completionHandle(.failure(error))
            }
        }
        dataTask?.resume()
    }
    mutating func getImage( httpMethod: HttpMethod, param: [String: Any]?, apiType: ApiType, completionHandle: @escaping (AnyObject?, Error?) -> Void) {
        let url = self.getURL(api: apiType, param: param)
        var request = URLRequest.init(url: URL(string: url)!)
        request.httpMethod = httpMethod.rawValue
        dataTask = session.dataTask(with: request) { (data, _, error) in
            if let jsonData = data {
                // success
                completionHandle(jsonData as AnyObject, error)
            } else {
                completionHandle(nil, error)
            }
        }
        dataTask?.resume()
    }
}
