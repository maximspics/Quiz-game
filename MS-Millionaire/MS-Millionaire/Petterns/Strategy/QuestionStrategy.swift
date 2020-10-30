//
//  QuestionStrategy.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 27.02.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import Foundation

protocol QuestionStrategy {
    func shuffleVariationOfQuestions(_ questions: [VariationOfQuestions]) -> [VariationOfQuestions]
}
