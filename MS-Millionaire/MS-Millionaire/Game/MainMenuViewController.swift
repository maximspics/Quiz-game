//
//  MainMenuViewController.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 17.02.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var difficultyControl: UISegmentedControl!
    @IBOutlet weak var lifelineControl: UISegmentedControl!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var lastResultsButton: UIButton!
    @IBOutlet weak var lastResultLabel: UILabel!
    @IBOutlet weak var addQuestionButton: UIButton!
    
    var caretaker = GameCaretaker()
    var userQuestionsCaretaker = UserQuestionsCaretaker()

    override func viewDidLoad() {
        super.viewDidLoad()

        difficultyControl.createSegementControl()
        lifelineControl.createSegementControl()

        let records = try! self.caretaker.loadGame()
        GameResults.shared.getSavedRecords(records)
        
        gameNameLabel.numberOfLines = 3
        self.gameNameLabel.text = """
        Кто
        хочет стать
        миллионером?
        """
        startGameButton.setTitle("Играть", for:  UIControl.State.normal)
        startGameButton.createMainMenuButton()
        lastResultsButton.setTitle("Результаты", for:  UIControl.State.normal)
        lastResultsButton.createMainMenuButton()
        addQuestionButton.setTitle("Добавить вопрос", for: UIControl.State.normal)
        addQuestionButton.createMainMenuButton()
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "StartGameSegue":
            guard let destination = segue.destination as? GameViewController else { return }
            destination.difficulty = self.selectedDifficulty
            destination.lifelineOdds = self.selectedLifelineBenefits
            destination.onGameEnd = { [weak self] result in
                self?.lastResultLabel.text = "Последний результат: \(result)"
                self?.lastResultLabel.createMainMenuLabel()
                try! self?.caretaker.saveGame(GameResults.shared.records)
            }
            break
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    private var selectedDifficulty: Difficulty {
        switch self.difficultyControl.selectedSegmentIndex {
        case 0:
            return .sequence
        case 1:
            return .random
        default:
            return .sequence
        }
    }
    
    private var selectedLifelineBenefits: LifelineOdds {
        switch self.lifelineControl.selectedSegmentIndex {
        case 0:
            return .medium
        case 1:
            return .high
        default:
            return .medium
        }
    }
}
