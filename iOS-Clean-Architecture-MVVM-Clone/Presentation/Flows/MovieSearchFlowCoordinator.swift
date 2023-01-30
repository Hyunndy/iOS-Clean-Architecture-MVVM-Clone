//
//  MovieSearchFlowCoordinator.swift
//  iOS-Clean-Architecture-MVVM-Clone
//
//  Created by hyunndy on 2023/01/31.
//

import UIKit

/*
 저자가 Coordinator 패턴의 창시자라서 FlowCoordinator가 나온다.
 */

/*
 영화 검색화면에서 어느 화면으로 갈지에 대한 프로토콜
 */
protocol MovieSearchFlowCoordinatorDependencies {
}

final class MovieSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MovieSearchFlowCoordinatorDependencies
    
    init(navigationController: UINavigationController?, dependencies: MovieSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
}
