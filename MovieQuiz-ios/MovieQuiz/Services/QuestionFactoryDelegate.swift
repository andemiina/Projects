//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Анна Демина on 11.08.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() //сообщение об успешной загрузке
    func didFailToLoadData(with error: Error)
}
