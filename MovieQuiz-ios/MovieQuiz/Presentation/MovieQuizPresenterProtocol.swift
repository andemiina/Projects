//
//  MovieQuizPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Анна Демина on 21.08.2024.
//

import Foundation


protocol MovieQuizPresenterProtocol {
    func isLastQuestion() -> Bool
    func didAnswer(isCorrectAnswer: Bool)
    func restartGame()
    func noButtonClicked()
    func yesButtonClicked()
    func didAnswer(isYes: Bool)
    func proceedWithAnswer(isCorrect: Bool)
    func proceedToNextQuestionOrResults()
    func makeResultsMessage() -> String


}

