//
//  OddsStrategy.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 05.03.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit

protocol OddsStrategy {
    func doOdds() -> Int
}

class HighOddsStrategy: OddsStrategy {
    func doOdds() -> Int {
        return Int.random(in: 50...70)
    }
}

class MediumOddsStrategy: OddsStrategy {
    func doOdds() -> Int {
        return Int.random(in: 30...50)
    }
}

class GetOdds: OddsStrategy {
    func doOdds() -> Int {
        return odds.doOdds()
    }
    
    private var odds: OddsStrategy
    init(odds: OddsStrategy) {
        self.odds = odds
    }
    
    func setOdds(odds: OddsStrategy) {
        self.odds = odds
    }
}
