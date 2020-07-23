//
//  AddQuestion.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 02.03.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit
import QuartzCore

class AddQuestionController: UIViewController {
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var firstAnswerTextField: UITextField!
    @IBOutlet weak var secondAnswerTextField: UITextField!
    @IBOutlet weak var thirdAnswerTextField: UITextField!
    @IBOutlet weak var fourthAnswerTextField: UITextField!
    @IBOutlet weak var correctAnswerSegmentedControl: UISegmentedControl!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var addQuestionButton: UIButton!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet var views: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for labels in labels {
            labels.createAddQuestionLabel()
        }
        
        for textFields in textFields {
            textFields.createTextField()
        }
        
        for views in views {
            views.createAddQuestionView()
        }
        
        correctAnswerSegmentedControl.createSegementControl()
        addQuestionButton.createMainMenuButton()
        addQuestionButton.setTitle("Добавить", for: UIControl.State.normal)
        
    }
    
    @IBAction func addQuestion(_ sender: Any) {
        if let question = questionTextField.text,
            let firstAnswer = firstAnswerTextField.text,
            let secondAnswer = secondAnswerTextField.text,
            let thirdAnswer = thirdAnswerTextField.text,
            let fourthAnswer = fourthAnswerTextField.text,
            let money = moneyTextField.text,
            !question.isEmpty,
            !firstAnswer.isEmpty,
            !secondAnswer.isEmpty,
            !thirdAnswer.isEmpty,
            !fourthAnswer.isEmpty,
            !money.isEmpty
        {
            if moneyTextField.text?.isInt == true {
                
                GameResults.shared.userQuestions.append(UserQuestions(questionsInCategory: [Question(question: "Вопрос от пользователя: " + question, answers: [firstAnswer,secondAnswer,thirdAnswer,fourthAnswer],  correctAnswer: (correctAnswerSegmentedControl.selectedSegmentIndex), money: Int(money) ?? 0)]))
                
                print("userQuestions in addQuestionButton: \(GameResults.shared.userQuestions)")
                
                questionTextField.text = ""
                firstAnswerTextField.text = ""
                secondAnswerTextField.text = ""
                thirdAnswerTextField.text = ""
                fourthAnswerTextField.text = ""
                correctAnswerSegmentedControl.selectedSegmentIndex = 0
                moneyTextField.text = ""
                
                let alert = UIAlertController(title: "Вопрос добавлен!", message: "Добавить еще один вопрос?", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Да", style: .default, handler: nil)
                let noAction = UIAlertAction(title: "Нет", style: .cancel) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(yesAction)
                alert.addAction(noAction)
    
                present(alert, animated: true)
                
            } else {
                let alert = UIAlertController(title: "Стоимость", message: "Необходимо ввести число!", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
                alert.addAction(yesAction)
                
                present(alert, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "", message: "Пожалуйста, заполните все поля!", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
            alert.addAction(yesAction)
            
            present(alert, animated: true)
        }
    }
}
