//
//  AppFlowCoordinator.swift
//  iOS-Clean-Architecture-MVVM-Clone
//
//  Created by hyunndy on 2023/01/31.
//

import Foundation
import UIKit

/*
 one-high-level Coordinator
 최상위 Coordinator
 
 Coordinator란? ViewController에서 Flow 로직을 따로 분리한 객체
 
 모든 Coordinator는 하위 Coordinator가 있으며,
 각 Coordinator는 부모에 의해서만 생성된다.
 */
final class AppFlowCoordinator {
    
    var navigationController: UINavigationController
    
    /// 앱 전반에서 사용하는 DI Container
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    /// 메인화면인 MovieScene으로 가는 Coordinator를 Spawn한다.
    func start() {
        
        let movieSceneDIContainer = appDIContainer.makeMovieSceneDIContainer()

        // MovieSceneFlowCoordinator를 리턴하는 함수가 DIContainer에 존재한다.
        let flow = movieSceneDIContainer.makeMovieSearchFlowCoordinator(navigationController: navigationController)
        
        flow.start()
    }
}
