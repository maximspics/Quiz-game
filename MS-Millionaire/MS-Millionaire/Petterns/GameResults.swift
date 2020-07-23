//
//  GameResults.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 20.02.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import Foundation

class GameResults {
    
    var records: [Record] = []
    static var shared = GameResults()
    let usersQuestionCaretaker = UserQuestionsCaretaker()
    private init() {
        userQuestions = []
        do {
            self.userQuestions = try usersQuestionCaretaker.load()
        } catch {
            print("Can't load users questions")
        }
    }
    
    var userQuestions: [UserQuestions] {
        didSet {
            if self.userQuestions.count > 0 {
                do {
                    try usersQuestionCaretaker.save(self.userQuestions)
                } catch {
                    print("Can't save users question")
                }
            }
        }
    }
    
    func addRecord(_ result: Int,
                   _ questionAmount: Int,
                   _ moneyAmount: Int,
                   _ percentOfCorrectAnswers: Int,
                   _ tipsCount: Int,
                   _ opacityOfHideTwoIncorrectAnswersImage: Float,
                   _ opacityOfAskTheAudienceImage: Float,
                   _ opacityOfPhoneAFriendImage: Float) {
        
        let record = Record(date: Date(),
                            score: result,
                            questions: questionAmount,
                            money: moneyAmount,
                            percent: percentOfCorrectAnswers,
                            tipsCount: tipsCount,
                            opacityOfHideTwoIncorrectAnswersImage: opacityOfHideTwoIncorrectAnswersImage,
                            opacityOfAskTheAudienceImage: opacityOfAskTheAudienceImage,
                            opacityOfPhoneAFriendImage: opacityOfPhoneAFriendImage)
        self.records.append(record)
    }
    
   func getSavedRecords(_ savedRecords: [Record]) {
       records.removeAll()
       records.append(contentsOf: savedRecords)
   }
}

struct Record: Codable {
    let date: Date
    let score: Int
    let questions: Int
    let money: Int
    let percent: Int
    let tipsCount: Int
    let opacityOfHideTwoIncorrectAnswersImage: Float
    let opacityOfAskTheAudienceImage: Float
    let opacityOfPhoneAFriendImage: Float
}
