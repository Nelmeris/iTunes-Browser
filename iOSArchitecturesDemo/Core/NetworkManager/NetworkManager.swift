//
//  NetworkManager.swift
//  iOSArchitecturesDemo
//
//  Created by ekireev on 19.02.2018.
//  Copyright © 2018 ekireev. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    public typealias DataCompletion = (Result<Data>) -> Void
    public typealias JSONCompletion = (Result<[String: Any]?>) -> Void
    
    public func dataRequest(_ request: WebRequest, then completion: DataCompletion?) {
        Alamofire.request(request.url, method: request.method, parameters: request.parameters).validate().responseData { [weak self] response in
            response.result
                .withValue { data in
                    completion?(.success(data))
                }
                .withError {
                    self?.logError($0, request: request)
                    completion?(.failure($0))
            }
        }
    }
    
    public func jsonRequest(_ request: WebRequest, then completion: JSONCompletion?) {
        Alamofire.request(request.url, method: request.method, parameters: request.parameters).validate().responseJSON { [weak self] response in
            response.result
                .withValue { json in
                    completion?(.success(json as? [String: Any]))
                }
                .withError {
                    self?.logError($0, request: request)
                    completion?(.failure($0))
            }
        }
    }
    
    private func logError(_ error: Error, request: WebRequest) {
        print("Error while executing request \(request.url), error: \(error.localizedDescription)")
    }
}
