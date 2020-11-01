//
//  Question.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 17.02.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import Foundation

class Question: Equatable, Codable {
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.question == rhs.question
    }
    
    internal init(question: String, answers: [String], correctAnswer: Int, money: Int) {
        self.question = question
        self.answers = answers
        self.correctAnswer = correctAnswer
        self.money = money
    }
    
    var question: String
    var answers: [String]
    var correctAnswer: Int
    var money: Int
}

class QuestionsCategory: Codable {
    
    internal init(category: [Question]) {
        self.category = category
    }
    
    var category: [Question]
}

class UserQuestions: QuestionsCategory {
    
}
