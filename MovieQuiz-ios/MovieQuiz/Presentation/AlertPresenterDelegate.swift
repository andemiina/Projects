//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Анна Демина on 11.08.2024.
//

import Foundation

protocol AlertPresenterDelegate: AnyObject {
    func show(quiz result: AlertModel)
}
