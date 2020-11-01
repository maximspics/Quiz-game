//
//  RandomQuestionStrategy.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 27.02.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import Foundation

class RandomQuestionStrategy: QuestionStrategy {
    func shuffleVariationOfQuestions(_ questions: [QuestionsCategory]) -> [QuestionsCategory] {
        return questions.shuffled()
    }
}
