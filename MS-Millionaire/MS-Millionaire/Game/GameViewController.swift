//
//  GameViewController.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 18.02.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var moneyView: UIView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var hideTwoIncorrectAnswersButton: UIButton!
    @IBOutlet weak var askAudienceButton: UIButton!
    @IBOutlet weak var phoneAFriendButton: UIButton!
    @IBOutlet var answerButtons: [UIButton]!
    
    var strategy = RandomQuestionStrategy()
    var difficulty: Difficulty = .sequence
    var lifelineOdds: LifelineOdds = .medium
    var onGameEnd: ((Int) -> Void)?
    
    var userQuestions = GameResults.shared.userQuestions
    let letters = ["A: ", "B: ", "C: ", "D: "]
    var categoryIndex = Int()
    var questionIndexInCategory = Int()
    var correctAnswer = Int()
    
    var correctAnswersAmount = Int()
    var money = Int()
    var moneyAmount = Int()
    var percentOfCorrectAnswers = Int()
    
    var answersArray: [Int] = []
    var audiencePercents: [Int] = []
    var audienceAnswerInPercents = Int()
    
    var odds = Int()
    var closeToCorrect = Int()
    
    var lifelinesCount: Int = 0
    
    var opacityOfHideTwoIncorrectAnswersImage: Float = 1.0
    var opacityOfAskTheAudienceImage: Float = 1.0
    var opacityOfPhoneAFriendImage: Float = 1.0
    
    var storedCategoryIndex = Int()
    
    let networkDataFetcher = NetworkDataFetcher()
    var questionCategory: [QuestionCategory]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://raw.githubusercontent.com/maximspics/Quiz-game/master/MS-Millionaire/MS-Millionaire/questions.json"
        
        networkDataFetcher.fetchQuestions(urlString: urlString) { (questionsCategory) in
            guard let questionsCategory = questionsCategory else { return }
            self.questionCategory = questionsCategory
            self.loadStrategy()
            self.createViews()
            self.loadQuestion()
        }
    }
    
    func createViews() {
        for button in answerButtons {
            button.createAnswerButton()
        }
        
        moneyView.createMoneyView()
        questionView.createQuestionView()
    }
    
    func loadStrategy() {
        if userQuestions.count > 0 {
            questionCategory = questionCategory! + userQuestions
        }
        
        var strategy: QuestionStrategy {
            if self.difficulty == .random {
                return RandomQuestionStrategy()
            } else {
                return SequenceQuestionStrategy()
            }
        }
        
        var lifelineStrategy: OddsStrategy {
            if self.lifelineOdds == .high {
                return HighOddsStrategy()
            } else {
                return MediumOddsStrategy()
            }
        }
        
        odds = lifelineStrategy.doOdds()
        print("odds: \(odds)")
        
        questionCategory = strategy.shuffleVariationOfQuestions(questionCategory!)

    }
    
    func loadQuestion() {
        print(questionCategory?.count ?? 0)
        if categoryIndex < questionCategory!.count {
            
            // Return the buttons to their original appearance if a lifelines was taken
            for i in 0..<answerButtons.count {
                answerButtons[i].createAnswerButton()
                answerButtons[i].isHidden = false
                answerButtons[i].isEnabled = true
            }
            
            // Return answers array for lifelines
            answersArray.removeAll()
            for i in 0..<answerButtons.count {
                answersArray.append(i)
            }
            
            // Take the random question in category
            guard let randomElement = questionCategory?[categoryIndex].questions.randomElement() else { return}
            questionIndexInCategory = questionCategory![categoryIndex].questions.firstIndex(of: randomElement)!
            
            // Fill answer buttons with text
            for i in 0..<answerButtons.count {
                answerButtons[i].setTitle(letters[i] + questionCategory![categoryIndex].questions[questionIndexInCategory].answers[i], for: UIControl.State.normal)
            }
            
            // Fill question label with text and Display font size to fit width
            questionLabel.text = questionCategory![categoryIndex].questions[questionIndexInCategory].question
            questionLabel.adjustsFontSizeToFitWidth = true
            
            // Fill money label with text
            money = questionCategory![categoryIndex].questions[questionIndexInCategory].money
            moneyLabel.text = String(money)
            
            // Take the correct answer number
            correctAnswer = questionCategory![categoryIndex].questions[questionIndexInCategory].correctAnswer
            
        } else {
            
            endGame()
        }
    }
    
    // Lifeline: 50:50
    @IBAction func hideTwoIncorrectAnswers(_ sender: UIButton) {
        
        var hiddenIncorrectAnswersCount = 0
        answersArray.remove(at: correctAnswer)
        
        repeat {
            guard let randomElement = answersArray.randomElement() else { return }
            answerButtons[randomElement].setTitle("", for: UIControl.State.normal)
            answerButtons[randomElement].isEnabled = false
            
            guard let firstIndex = answersArray.firstIndex(of: randomElement) else { return }
            answersArray.remove(at: firstIndex)
            hiddenIncorrectAnswersCount += 1
        } while hiddenIncorrectAnswersCount < 2
        
        // Change the appearance of hideTwoIncorrectAnswersButton
        hideTwoIncorrectAnswersButton.layer.opacity = 0.8
        hideTwoIncorrectAnswersButton.isEnabled = false
        guard let image = UIImage(named: "fifty-fifty_used") else { return }
        hideTwoIncorrectAnswersButton.setImage(image, for: .normal)
        
        // Sum the lifelines
        lifelinesCount += 1
        
        storedCategoryIndex = categoryIndex
    }
    
    // Lifeline: Ask the Audience
    @IBAction func askTheAudience(_ sender: UIButton) {
        
        // First condition if we hide two incorrect answers, answersArray.count == 1
        // Second condition if we have all answers to display, answersArray.count == 4
        if answersArray.count == 1 {
            
            if phoneAFriendButton.isEnabled == false {
                closeToCorrect = Int.random(in: 60...80)
            } else {
                closeToCorrect = odds
            }
            
            let mayNotCloseToCorrect = 100 - closeToCorrect
            
            for i in 0..<answerButtons.count {
                if answerButtons[i].tag == correctAnswer && answerButtons[i].isEnabled != false {
                    answerButtons[i].setTitle(letters[i] + questionCategory![categoryIndex].questions[questionIndexInCategory].answers[i] + ": " + String(closeToCorrect) + "%", for:  UIControl.State.normal)
                }
                if answerButtons[i].tag != correctAnswer && answerButtons[i].isEnabled != false {
                    answerButtons[i].setTitle(letters[i] + questionCategory![categoryIndex].questions[questionIndexInCategory].answers[i] + ": " + String(mayNotCloseToCorrect) + "%", for:  UIControl.State.normal)
                }
            }
            
        } else if answersArray.count == 4 {
            
            if phoneAFriendButton.isEnabled == false {
                
                let randomNumber = Int.random(in: 1...100)
                if randomNumber <= 80 {
                    closeToCorrect = Int.random(in: 60...80)
                } else {
                    closeToCorrect = odds
                }
            } else {
                closeToCorrect = odds
            }
            
            let prepareForSecondOption = 100 - closeToCorrect
            let secondOption = Int((Double(Int.random(in: 0...prepareForSecondOption))/1.6))
            let prepareForThirdOption = 100 - closeToCorrect - secondOption
            let thirdOption = Int((Double(Int.random(in: 0...prepareForThirdOption))/1.6))
            let fourthOption = 100 - closeToCorrect - secondOption - thirdOption
            var arrayOfIncorrectOptions = [secondOption, thirdOption, fourthOption]
            
            // For Correct Button Answer we set value between 30% and 90%, it depends of many factors =))
            // For All Other 3 Buttons we randomly set percents
            for i in 0..<answerButtons.count {
                if answerButtons[i].tag == correctAnswer {
                    answerButtons[i].setTitle(letters[i] + questionCategory![categoryIndex].questions[questionIndexInCategory].answers[i] + ": " + String(closeToCorrect) + "%", for:  UIControl.State.normal)
                } else {
                    guard let randomElement = arrayOfIncorrectOptions.randomElement() else { return }
                    answerButtons[i].setTitle(letters[i] + questionCategory![categoryIndex].questions[questionIndexInCategory].answers[i] + ": " + String(randomElement) + "%", for:  UIControl.State.normal)
                    guard let firstIndex = arrayOfIncorrectOptions.firstIndex(of: randomElement) else { return }
                    arrayOfIncorrectOptions.remove(at: firstIndex)
                }
            }
        }
        
        // Change the appearance of askAudienceButton
        askAudienceButton.layer.opacity = 0.8
        askAudienceButton.isEnabled = false
        guard let image = UIImage(named: "ask_audience_used") else { return }
        askAudienceButton.setImage(image, for: .normal)
        
        // Sum the lifelines count
        lifelinesCount += 1
        
        storedCategoryIndex = categoryIndex
    }
    
    // Lifeline: Phone A Friend
    @IBAction func phoneAFriend(_ sender: UIButton) {
        
        func changeButtonColor() {
            for i in 0..<answerButtons.count {
                if answerButtons[i].tag == correctAnswer {
                    answerButtons[i].backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 0.7)
                    answerButtons[i].setTitleColor(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), for: UIControl.State.init())
                    answerButtons[i].layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                }
            }
        }
        
        func chooseBetweenCorrectAnswerAndAllAnswers() {
            let closeToCorrect = Bool.random()
            if closeToCorrect == true {
                changeButtonColor()
            } else {
                guard let randomElement = answersArray.randomElement() else { return }
                answerButtons[randomElement].backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 0.7)
                answerButtons[randomElement].setTitleColor(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), for: UIControl.State.init())
                answerButtons[randomElement].layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            }
        }
        
        // If the User already use one of the lifelines at the same question we increase the chance to highlight the correct answer
        if askAudienceButton.isEnabled == false && storedCategoryIndex == categoryIndex || hideTwoIncorrectAnswersButton.isEnabled == false && storedCategoryIndex == categoryIndex {
            let randomNumber = Int.random(in: 1...100)
            if randomNumber <= 70 || odds >= randomNumber {
                changeButtonColor()
            } else {
                chooseBetweenCorrectAnswerAndAllAnswers()
            }
        } else {
            chooseBetweenCorrectAnswerAndAllAnswers()
        }
        
        // Change the appearance of phoneAFriendButton
        phoneAFriendButton.layer.opacity = 0.8
        phoneAFriendButton.isEnabled = false
        guard let image = UIImage(named: "call_friend_used") else { return }
        phoneAFriendButton.setImage(image, for: .normal)
        
        // Sum the lifelines amount
        lifelinesCount += 1
    }
    
    // Checking the answer - is it correct or not
    @IBAction func chooseAnswer(_ sender: UIButton) {
        if ((sender as UIButton).tag == correctAnswer) {
            categoryIndex += 1
            correctAnswersAmount += 1
            percentOfCorrectAnswers = Int((Double(correctAnswersAmount) / Double(questionCategory!.count)) * 100)
            moneyAmount += money
            loadQuestion()
        } else {
            percentOfCorrectAnswers = Int((Double(correctAnswersAmount) / Double(questionCategory!.count)) * 100)
            
            endGame()
        }
    }
    
    func endGame() {
        if hideTwoIncorrectAnswersButton.isEnabled == false {
            opacityOfHideTwoIncorrectAnswersImage = 0.5
        }
        if askAudienceButton.isEnabled == false {
            opacityOfAskTheAudienceImage = 0.5
        }
        if phoneAFriendButton.isEnabled == false {
            opacityOfPhoneAFriendImage = 0.5
        }
        
        GameResults.shared.addRecord(correctAnswersAmount, questionCategory!.count, moneyAmount, percentOfCorrectAnswers, lifelinesCount, opacityOfHideTwoIncorrectAnswersImage, opacityOfAskTheAudienceImage, opacityOfPhoneAFriendImage)
        
        onGameEnd?(correctAnswersAmount)
        dismiss(animated: true, completion: nil)
    }
}
