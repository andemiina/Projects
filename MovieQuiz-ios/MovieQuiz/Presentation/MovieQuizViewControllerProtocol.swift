//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Анна Демина on 21.08.2024.
//

import Foundation


protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
       func show(quiz result: QuizResultsViewModel)
       
       func highlightImageBorder(isCorrectAnswer: Bool)
       
       func showLoadingIndicator()
       func hideLoadingIndicator()
       
       func showNetworkError(message: String)
    func enableButtons()
}
