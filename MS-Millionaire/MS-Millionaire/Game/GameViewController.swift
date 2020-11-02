//
//  GameViewController.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 18.02.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

protocol GameSceneDelegate: class {
    func didEndGame(with result: Int)
}

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
    
    var questions = [QuestionCategory]()
    var userQuestions = GameResults.shared.userQuestions
    let letters = ["A: ", "B: ", "C: ", "D: "]
    var categoryIndex = Int()
    var questionIndexInCategory = Int()
    var correctAnswer = Int()
    
    var questionsAmount = Int()
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
    
    var questionNumberStore = Int()
    
    let networkDataFetcher = NetworkDataFetcher()
    var questionCategory: [QuestionCategory]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://raw.githubusercontent.com/maximspics/Quiz-game/master/MS-Millionaire/MS-Millionaire/questions.json"
        
        networkDataFetcher.fetchQuestions(urlString: urlString) { [weak self] (questionsCategory) in
            guard let questionsCategory = questionsCategory else { return }
            self?.questionCategory = questionsCategory
            
            self?.loadStrategy()
            self?.loadNewQuestion()
            print("questionsCategory:", questionsCategory)
            questionsCategory.map { c in
                c.questions.map { q in
                    print(q.answers)
                }
            }
        }
        
        
        
        for button in answerButtons {
            button.createAnswerButton()
        }
        
        moneyView.createMoneyView()
        questionView.createQuestionView()
        
        
        questions = [
            QuestionCategory(questions: [
                Question(question: "Каким термином определяют троих людей связанных любовными отношениями?",
                         answers: ["Порочный круг",
                                   "Любовный треугольник",
                                   "Бермудский треугольник",
                                   "Любовное троеборье"],
                         correctAnswer: 1,
                         money: 100),
                Question(question: "Как правильно закончить пословицу: «Не откладывай на завтра то, что можешь сделать...»?",
                         answers: ["Сейчас",
                                   "Сегодня",
                                   "Послезавтра",
                                   "Никогда"],
                         correctAnswer: 1,
                         money: 100),
                Question(question: "О чем предлагалось не думать свысока в песне из сериала «Семнадцать мгновений весны»?",
                         answers: ["О секундах",
                                   "О моментах",
                                   "О минутах",
                                   "О веках"],
                         correctAnswer: 0,
                         money: 100)
                ]
            ),
            QuestionCategory(questions: [
                Question(question: "Что вылетает из праздничной хлопушки?",
                         answers: ["Брызги",
                                   "Мишура",
                                   "Пробка",
                                   "Конфетти"],
                         correctAnswer: 3,
                         money: 200),
                Question(question: "Какой туман кажется В.Добрынину похожим на обман в одной из его песен?",
                         answers: ["Синий",
                                   "Сиреневый",
                                   "Утренний",
                                   "Жетлый"],
                         correctAnswer: 0,
                         money: 200),
                Question(question: "Как правильно продолжить припев детской песни: «Тили-тили...»?",
                         answers: ["Хали-гали",
                                   "Трали-вали",
                                   "Жили-были",
                                   "Ели-пили"],
                         correctAnswer: 1,
                         money: 200)
            ]),
            QuestionCategory(questions: [
                Question(question: "Как называется экзотическое животное из Южной Америки?",
                         answers: ["Пчеложор", "Термитоглот", "Муравьед", "Комаролов"],
                         correctAnswer: 2,
                         money: 300)
            ]),
            QuestionCategory(questions: [
                Question(question: "Во что превращается гусеница?",
                         answers: ["В мячик", "В пирамидку", "В машинку", "В куколку"],
                         correctAnswer: 3,
                         money: 400)
            ]),
            QuestionCategory(questions: [
                Question(question: "К какой группе музыкальных инструментов относится валторна?",
                         answers: ["Струнные", "Клавишные", "Ударные", "Духовые"],
                         correctAnswer: 3,
                         money: 500
                )
            ]),
            QuestionCategory(questions: [
                Question(question: "В какой басне Крылова среди действующих лиц есть человек?",
                         answers: ["«Лягушка и Вол»", "«Свинья под Дубом»", "«Осел и Соловей»", "«Волк на псарне»"],
                         correctAnswer: 3,
                         money: 1000
                )
            ])
        ]
        
        
        loadNewQuestion()
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
        print("odds in viewDidLoad: \(odds)")
        
        questionCategory = strategy.shuffleVariationOfQuestions(questionCategory!)

    }
    
    func loadNewQuestion() {
        print(questionCategory?.count ?? 0)
        if categoryIndex < questionCategory?.count ?? 1 {
            
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
            
            // Take the random element in the same money category of question
        //    guard let randomElement = questions[questionIndex].category.randomElement() else { return}
        //    questionIndexInCategory = questions[questionIndex].category.firstIndex(of: randomElement)!
            guard let randomElement = questionCategory?[categoryIndex].questions.randomElement() else { return}
            questionIndexInCategory = (questionCategory?[categoryIndex].questions.firstIndex(of: randomElement))!
            
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
            
            if hideTwoIncorrectAnswersButton.isEnabled == false {
                opacityOfHideTwoIncorrectAnswersImage = 0.5
            }
            if askAudienceButton.isEnabled == false {
                opacityOfAskTheAudienceImage = 0.5
            }
            if phoneAFriendButton.isEnabled == false {
                opacityOfPhoneAFriendImage = 0.5
            }
            
            questionsAmount = questionCategory!.count
            
            GameResults.shared.addRecord(correctAnswersAmount, questionsAmount, moneyAmount, percentOfCorrectAnswers, lifelinesCount, opacityOfHideTwoIncorrectAnswersImage, opacityOfAskTheAudienceImage, opacityOfPhoneAFriendImage)
            didEndGame(with: correctAnswersAmount)
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
        
        questionNumberStore = categoryIndex
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
        
        questionNumberStore = categoryIndex
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
        if askAudienceButton.isEnabled == false && questionNumberStore == categoryIndex || hideTwoIncorrectAnswersButton.isEnabled == false && questionNumberStore == categoryIndex {
            let randomNumber = Int.random(in: 1...100)
            if randomNumber <= 80 || odds >= 50 {
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
            questionsAmount = questions.count
            percentOfCorrectAnswers = Int((Double(correctAnswersAmount) / Double(questionsAmount)) * 100)
            moneyAmount = moneyAmount + money
            loadNewQuestion()
        } else {
            categoryIndex += 1
            questionsAmount = questions.count
            percentOfCorrectAnswers = Int((Double(correctAnswersAmount) / Double(questionsAmount)) * 100)
            
            if hideTwoIncorrectAnswersButton.isEnabled == false {
                opacityOfHideTwoIncorrectAnswersImage = 0.5
            }
            if askAudienceButton.isEnabled == false {
                opacityOfAskTheAudienceImage = 0.5
            }
            if phoneAFriendButton.isEnabled == false {
                opacityOfPhoneAFriendImage = 0.5
            }
            
            GameResults.shared.addRecord(correctAnswersAmount, questionsAmount, moneyAmount, percentOfCorrectAnswers, lifelinesCount, opacityOfHideTwoIncorrectAnswersImage, opacityOfAskTheAudienceImage, opacityOfPhoneAFriendImage)
            didEndGame(with: correctAnswersAmount)
        }
    }
}

extension GameViewController: GameSceneDelegate {
    func didEndGame(with result: Int) {
        self.onGameEnd?(result)
        self.dismiss(animated: true, completion: nil)
    }
}
