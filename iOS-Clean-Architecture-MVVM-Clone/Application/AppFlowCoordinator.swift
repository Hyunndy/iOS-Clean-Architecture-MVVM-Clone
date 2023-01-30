//
//  AppFlowCoordinator.swift
//  iOS-Clean-Architecture-MVVM-Clone
//
//  Created by hyunndy on 2023/01/31.
//

import Foundation
import UIKit

/*
 이 저자가 Coordinator 패턴을 만들어서 App, MovieScene Coordinator가 있다.
 */

final class AppFlowCoordinator {
    
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    /*
     이 start() 함수가 DI 세팅하면서 같이 불리는데 이것의 의미가 무엇인지..
     */
    func start() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let movieSceneDIContainer = appDIContainer.makeMovieSceneDIContainer()
        

    }
    
}
