//
//  MovieSearchFlowCoordinator.swift
//  iOS-Clean-Architecture-MVVM-Clone
//
//  Created by hyunndy on 2023/01/31.
//

import UIKit

/*
 영화 검색화면 VC의 Flow로직을 관리하는 Coordinator
 
 영화검색화면에서 보이는 화면은
 영화 리스트
 최근 내가 검색한 리스트
 영화 상세
 */
protocol MoviesSearchFlowCoordinatorDependencies  {
    func makeMoviesListViewController(actions: MoviesListViewModelActions) -> MoviesListViewController
    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController
    func makeMoviesQueriesSuggestionsListViewController(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> UIViewController
}

final class MovieSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    
    /// 이동할 VC 객체를 리턴받는 프로토콜
    private let dependencies: MoviesSearchFlowCoordinatorDependencies
    
    private weak var moviesListVC: MoviesListViewController?
    private weak var moviesQueriesSuggestionsVC: UIViewController?
    
    init(navigationController: UINavigationController?, dependencies: MoviesSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    /// 이 start부터 시작하면 좋을듯!!
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = MoviesListViewModelActions(showMovieDetails: showMovieDetails, showMovieQueriesSuggestions: showMovieQueriesSuggestions, closeMovieQueriesSuggestions: closeMovieQueriesSuggestions)
        
        let vc = self.dependencies.makeMoviesListViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        moviesListVC = vc
        
    }
    
    // MARK: VC -> ViewModel -> Flow
    private func showMovieDetails(movie: Movie) {
        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        navigationController?.pushViewController(vc, animated: true)
    }

    /// 이거 코드 무슨뜻인지 아예 이해못함
    private func showMovieQueriesSuggestions(didSelect: @escaping (MovieQuery) -> Void) {
        guard let moviesListViewController = moviesListVC, moviesQueriesSuggestionsVC == nil,
            let container = moviesListViewController.suggestionsListContainer else { return }

        let vc = dependencies.makeMoviesQueriesSuggestionsListViewController(didSelect: didSelect)

        moviesListViewController.add(child: vc, container: container)
        moviesQueriesSuggestionsVC = vc
        container.isHidden = false
    }

    private func closeMovieQueriesSuggestions() {
        moviesQueriesSuggestionsVC?.remove()
        moviesQueriesSuggestionsVC = nil
        moviesListVC?.suggestionsListContainer.isHidden = true
    }
}
