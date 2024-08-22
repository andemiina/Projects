//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Анна Демина on 19.08.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    //эта переменная символизирует приложение, которое мы тестируем
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        //чтобы быть уверенными, что эта переменная будет проинициализирована на момент использования
        app = XCUIApplication()
        //откроет приложение
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошёл,
                // то следующие тесты запускаться не будут
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        //закроет приложение
        app.terminate()
        app = nil
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }
    
    
    func testYesButtom() {
        sleep(3)
        let firstPoster = app.images["Poster"] //находим первый постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap() //находим кноку да и нажимаем ее
        sleep(3)
        
        let secondPoster = app.images["Poster"] //еще раз находим постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData) //проверяем, что постеры разные
        XCTAssertEqual(indexLabel.label, "2/10")
        
    }
 
    func testNoButtom() {
        sleep(3)
        let firstPoster = app.images["Poster"] //находим первый постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap() //находим кноку нет и нажимаем ее
        sleep(3)
        
        let secondPoster = app.images["Poster"] //еще раз находим постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData) //проверяем, что постеры разные
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    
    func testGameFinish() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }

        let alert = app.alerts["Game results"]
        
        sleep(2)
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }

    
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        let alert = app.alerts["Game results"]
        
        XCTAssertTrue(alert.exists)
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
    
}
