//
//  AppConfiguration.swift
//  iOS-Clean-Architecture-MVVM-Clone
//
//  Created by hyunndy on 2023/01/30.
//

import Foundation

/*
 AppDIContainer()에서 호출하는 App Configuration
 
 App 공통에서 쓰는 Config를 저장한다. Info.plist에 저장되어있는.
 */
final class AppConfiguration {
    
    lazy var apiKey: String = {
        guard let apikey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("APIkey must not be empty in plist)")
        }
        return apikey
    }()
    
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    lazy var imagesBaseURL: String = {
        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return imageBaseURL
    }()
}
