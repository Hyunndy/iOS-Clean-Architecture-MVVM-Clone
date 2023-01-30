//
//  NetworkConfig.swift
//  iOS-Clean-Architecture-MVVM-Clone
//
//  Created by hyunndy on 2023/01/30.
//

import Foundation

/*
 이 클래스랑 Reuqestable의 차이를 잘 모르겠음
 */

// 이런 기본 세팅을 다 프로토콜로 빼는 구나..
public protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}


// 기본 세팅이 있는 프로토콜을 상속하는 구조체를 만들 때는 init()을 써주는게 좋다.
public struct ApiDataNetworkConfig: NetworkConfigurable {
    public var baseURL: URL
    public var headers: [String : String]
    public var queryParameters: [String : String]
    
    public init(baseURL: URL,
                headers: [String: String] = [:],
                queryParameters: [String: String] = [:]) {
       self.baseURL = baseURL
       self.headers = headers
       self.queryParameters = queryParameters
   }
}


