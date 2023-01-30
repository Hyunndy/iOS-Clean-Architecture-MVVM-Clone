//
//  AppDIContainer.swift
//  iOS-Clean-Architecture-MVVM-Clone
//
//  Created by hyunndy on 2023/01/30.
//

import Foundation

/*
 App Dependency Injection Class
 
 SceneDelegate에서 주입한다.
 
 
 */
final class AppDIContainer {
    
    // Info.plist에 저장된 App 공통에서 쓰이는 String들
    lazy var appConfiguration = AppConfiguration()
    
    
    // MARK: Network
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!, queryParameters: ["api_key": appConfiguration.apiKey, "language": NSLocale.preferredLanguages.first ?? "en"])
        
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
}
