//
//  DeprecatedGameTest.swift
//  QuizEngineTests
//
//  Created by Oğuz Kaan Altun on 23.07.2023.
//

import Foundation
import XCTest
import QuizEngine

class QuizTest: XCTestCase {
    
    private let delegate = DelegateSpy()
    private var quiz: Game<String, String, DelegateSpy>!
    
    override func setUp() {
        super.setUp()
        
        quiz = startGame(question: ["Q1", "Q2"], router: delegate, correctAnswers: ["Q1": "A1", "Q2": "A2"])
    }
    
    override func tearDown() {
        super.tearDown()
        
        quiz = nil
    }
    
    func test_startQuiz_answerZeroOutOfTwoCorrectly_scoresZero() {
        delegate.answerCallback("wrong")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 0)
    }
    
    func test_startQuiz_answerOneOutOfTwoCorrectly_scoresOne() {
        delegate.answerCallback("A1")
        delegate.answerCallback("wrong")
        
        XCTAssertEqual(delegate.handledResult!.score, 1)
    }
    
    func test_startQuiz_answerTwoOutOfTwoCorrectly_scoresTwo() {
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledResult!.score, 2)
    }
    
    
    private class DelegateSpy: Router {
        var handledResult: Result<String, String>? = nil
        
        var answerCallback: ((String) -> Void) = { _ in }
        
        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            self.answerCallback = answerCallback
        }
        
        func routeTo(result: Result<String, String>) {
            handledResult = result
        }
    }
}
