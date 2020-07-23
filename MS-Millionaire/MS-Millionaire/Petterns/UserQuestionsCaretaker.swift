//
//  UserQuestionsCaretaker.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 04.03.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import Foundation

class UserQuestionsCaretaker {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let key = "usersQuestions"
    
    func save(_ questions: [UserQuestions]) throws {
        let data: Data = try encoder.encode(questions)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func load() throws -> [UserQuestions] {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data
            , let game = try? decoder.decode([UserQuestions].self, from: data) else {
                return []
        }
        return game
    }
    
    public enum Error: Swift.Error {
        case gameNotFound
    }
}
