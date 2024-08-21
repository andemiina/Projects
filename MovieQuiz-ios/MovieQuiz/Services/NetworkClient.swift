//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Анна Демина on 16.08.2024.
//

import Foundation

//отвечает за загрузку данных по URL

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {
    
    
    //создали свою реализацию протокола
    private enum NetworkError: Error {
        case codeError
    }
    
    //функция запроса(будет загружать что-то по заранее заданному URL
    //вернется либо успех с данными типа Data или провал Error
    func  fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void ) {
        //создали запрос из url
        let request = URLRequest(url: url)
        
        //тк data, response, error - опционалы - мы их каждый распаковываем
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //проверяем пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return  // дальше нет смысла, поэтому заканчивает выполнение кода
            }
            
            //проверяем, что нам пришел успешный код ответа
            if let response = response as? HTTPURLResponse, // здесь мы превращаем response в объект класса HTTPURLResponse
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return  // дальше нет смысла, поэтому заканчивает выполнение кода
            }
            
            //возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
