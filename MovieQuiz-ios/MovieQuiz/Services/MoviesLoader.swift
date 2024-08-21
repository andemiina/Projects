//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Анна Демина on 16.08.2024.
//

import Foundation


//создадим сервис для загрузки фильмов

protocol MoviesLoading {
    func loadMovies(handler: @escaping ( Result <MostPopularMovies, Error> ) -> Void)
}

struct MoviesLoader: MoviesLoading {  //MoviesLoader это клиент NetworkClient
    //MARK: - NetworkCLient
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
         self.networkClient = networkClient
     }
       
    
    
    //MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Если мы не смогли преобразовать строку в URL, то приложение упадёт с ошибкой
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
            
        }
        return url
    }
    
    
    func loadMovies(handler: @escaping ( Result <MostPopularMovies, Error> ) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
