//
//  MovieSceneDIContainer.swift
//  iOS-Clean-Architecture-MVVM-Clone
//
//  Created by hyunndy on 2023/01/30.
//

import Foundation
import UIKit

/*
 MovieScene 의존성 주입
 
 Clean Architecture의 요소들을 주입한다!!!
 
 Persistent Storage
 Use Cases
 Repositiories
 Presentation -> MoviesList
 Presentation -> MovieDetail
 Presentation -> Movies Queries Suggestions List
 
 Flow Coordinators
 */
final class MovieSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    /*
     여기서는 최근검색어를 위한 CoreData를 사용한다.
     */
    
    // MARK: Persistent Storage
    
    
    // MARK: Flow Coordinators
    
    /*
     왜 dependency self일까옹?
     */
    func makeMovieSearchFlowCoordinator(navigationController: UINavigationController) -> MovieSearchFlowCoordinator {
        return MovieSearchFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

/*
 실제 구현을 하지도 않으면서?
 */
extension MovieSceneDIContainer: MovieSearchFlowCoordinatorDependencies {}
