//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Анна Демина on 12.08.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int {get}
    var bestGame: GameResult {get}
    var totalAccuracy: Double {get}
    
    func store(correct count: Int, total amount: Int)
}
