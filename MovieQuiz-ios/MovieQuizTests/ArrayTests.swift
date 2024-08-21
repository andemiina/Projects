//
//  ArrayTest.swift
//  MovieQuizTests
//
//  Created by Анна Демина on 19.08.2024.
//

import Foundation
import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
       //given
        let array = [1,1,2,3,5]
        
        //when
        let value = array[safe: 2]
        
        //then
        XCTAssertNotNil(value)
        XCTAssertEqual(value,2)
    }
    
    
    func testGetValueOutOfRange() throws {
        //given
         let array = [1,1,2,3,5]
        
        // When
           let value = array[safe: 20]
        
        // Then
          XCTAssertNil(value)
    }
}
