//
//  CareTaker.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 20.02.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import Foundation

class GameCaretaker {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let key = "results"
    
    func saveGame(_ results: [Record]) throws {
        let data: Data = try encoder.encode(results)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    func loadGame() throws -> [Record] {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data
            , let game = try? decoder.decode([Record].self, from: data) else {
                return []
        }
        return game
    }
    
    public enum Error: Swift.Error {
        case gameNotFound
    }
}
