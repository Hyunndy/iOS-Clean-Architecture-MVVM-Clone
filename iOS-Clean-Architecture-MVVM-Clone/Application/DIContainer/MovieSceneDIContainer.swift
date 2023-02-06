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
    
    // MARK: - Persistent Storage
    lazy var moviesQueriesStorage: MoviesQueriesStorage = CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
    lazy var moviesResponseCache: MoviesResponseStorage = CoreDataMoviesResponseStorage()
    
    
    // MARK: - Repositories
    func makeMoviesRepository() -> MoviesRepository {
        return DefaultMoviesRepository(dataTransferService: dependencies.apiDataTransferService, cache: moviesResponseCache)
    }
    func makeMoviesQueriesRepository() -> MoviesQueriesRepository {
        return DefaultMoviesQueriesRepository(dataTransferService: dependencies.apiDataTransferService,
                                              moviesQueriesPersistentStorage: moviesQueriesStorage)
    }
    func makePosterImagesRepository() -> PosterImagesRepository {
        return DefaultPosterImagesRepository(dataTransferService: dependencies.imageDataTransferService)
    }
    
    // MARK: Use Cases
    func makeSearchMoviesUseCase() -> SearchMoviesUseCase {
        return DefaultSearchMoviesUseCase(moviesRepository: makeMoviesRepository(), moviesQueriesRepository: makeMoviesQueriesRepository())
    }
    
    // MARK: Flow Coordinators
    func makeMovieSearchFlowCoordinator(navigationController: UINavigationController) -> MovieSearchFlowCoordinator {
        return MovieSearchFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

/*
 Flow Coordinator에서 Flow 로직을 실행했을 때 이동할 VC 생성을 DI Container에서 한다.
 완전 분리하는군
 */
extension MovieSceneDIContainer: MoviesSearchFlowCoordinatorDependencies {
    // MARK: - Movies List
    /*
     ViewController와 ViewModel을 모두 여기서 생성해서 만들어준다.
     그리고 ViewModel이 프로토콜이다.
     */
    func makeMoviesListViewController(actions: MoviesListViewModelActions) -> MoviesListViewController {
        
        /// 뷰모델에 VC -> ViewModel -> Flow로 가는 액션 + ImageRepository를 주입한다.
        return MoviesListViewController.create(with: makeMoviesListViewModel(actions: actions),
                                               posterImagesRepository: makePosterImagesRepository())
    }
    
    
    /// 뷰 모델에 UseCase, actions을 넣는다.
    func makeMoviesListViewModel(actions: MoviesListViewModelActions) -> MoviesListViewModel {
        return DefaultMoviesListViewModel(searchMoviesUseCase: makeSearchMoviesUseCase(),
                                          actions: actions)
    }
    
    // MARK: - Movie Details
    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController {
        return MovieDetailsViewController.create(with: makeMoviesDetailsViewModel(movie: movie))
    }
    
    func makeMoviesDetailsViewModel(movie: Movie) -> MovieDetailsViewModel {
        return DefaultMovieDetailsViewModel(movie: movie,
                                            posterImagesRepository: makePosterImagesRepository())
    }
    
    // MARK: - Movies Queries Suggestions List
    func makeMoviesQueriesSuggestionsListViewController(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> UIViewController {
        if #available(iOS 13.0, *) { // SwiftUI
            let view = MoviesQueryListView(viewModelWrapper: makeMoviesQueryListViewModelWrapper(didSelect: didSelect))
            return UIHostingController(rootView: view)
        } else { // UIKit
            return MoviesQueriesTableViewController.create(with: makeMoviesQueryListViewModel(didSelect: didSelect))
        }
    }
    
    func makeMoviesQueryListViewModel(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> MoviesQueryListViewModel {
        return DefaultMoviesQueryListViewModel(numberOfQueriesToShow: 10,
                                               fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase,
                                               didSelect: didSelect)
    }

    @available(iOS 13.0, *)
    func makeMoviesQueryListViewModelWrapper(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> MoviesQueryListViewModelWrapper {
        return MoviesQueryListViewModelWrapper(viewModel: makeMoviesQueryListViewModel(didSelect: didSelect))
    }
}

//----
protocol Serializer {
    func serialize(data: Any) -> Data?
}

class ImageRequestSerializer: Serializer {
    func serialize(data: Any) -> Data? {
        return nil
    }
}

class DataRequestSerializer: Serializer {
    func serialize(data: Any) -> Data? {
        return nil
    }
}


class DataManager {
    
    func serialRequest(_ request: URLRequest, with serializer: Serializer) -> Data? {
        return nil
    }
}
