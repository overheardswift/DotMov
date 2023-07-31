//
//  SceneDelegate.swift
//  DotMov
//
//  Created by Bayu Kurniawan on 22/07/23.
//

import UIKit
import DMNetworking
import DMNowPlaying
import DMNowPlayingiOS
import DMCommoniOS
import DMMedia
import DMMovieDetail
import DMMovieDetailiOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	
	private lazy var baseURL = URL(string: "https://api.themoviedb.org")!
	private lazy var navigationController = UINavigationController()
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		UIFont.loadCustomFonts
		
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		let window = UIWindow(windowScene: windowScene)
		
		navigationController.setViewControllers([makeNowPlayingScene()], animated: true)
		window.rootViewController = navigationController
		
		self.window = window
		window.makeKeyAndVisible()
	}
}

private extension SceneDelegate {
	func makeNowPlayingScene() -> NowPlayingViewController {
		let client = URLSessionHTTPClient()
		let nowPlayingLoader = RemoteNowPlayingLoader(baseURL: baseURL, client: client)
		let genresLoader = RemoteGenresLoader(baseURL: baseURL, client: client)
		let imageLoader = RemoteImageDataLoader(client: client)
		let searchMoviesLoader = RemoteSearchMovieLoader(baseURL: baseURL, client: client)
		
		let viewController = NowPlayingUIComposer.compose(
			loader: nowPlayingLoader,
			genresLoader: genresLoader,
			imageLoader: imageLoader,
			searchMoviesLoader: searchMoviesLoader,
			onSelectCallback: { [weak self] movieID in
				guard let self = self else { return }
				let detailsViewController = self.makeMovieDetailScene(for: movieID)
				self.navigationController.pushViewController(detailsViewController, animated: true)
			}
		)
		
		return viewController
	}
	
	func makeMovieDetailScene(for id: Int) -> MovieDetailsViewController {
		let client = URLSessionHTTPClient()
		let movieLoader = RemoteMovieLoader(baseURL: baseURL, client: client)
		let castLoader = RemoteCastLoader(baseURL: baseURL, client: client)
		let imageLoader = RemoteImageDataLoader(client: client)
		
		let viewController = MovieDetailsUIComposer.compose(
			id: id,
			movieLoader: movieLoader,
			castLoader: castLoader,
			imageLoader: imageLoader
		)
		
		return viewController
	}
}

