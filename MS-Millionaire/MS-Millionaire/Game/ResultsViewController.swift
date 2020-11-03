//
//  ResultsViewController.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 18.02.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
}

extension ResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameResults.shared.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell
        
        var records = GameResults.shared.records
        records.reverse()
        let record = records[indexPath.row]
        
        let date = record.date
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeZone = .current
        let recordDate = dateFormatter.string(from: date)

        cell.createCell()
        cell.resultsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.resultsLabel.numberOfLines = 5
        cell.resultsLabel.text = """
        Дата: \(recordDate)
        Правильных ответов: \(record.score) (\(record.percent)%)
        Всего вопросов: \(record.questions)
        Вы выиграли: \(record.money) рублей
        Использовано подсказок: \(record.tipsCount)
        """
        cell.hideTwoIncorrectAnswersImage.layer.opacity = record.opacityOfHideTwoIncorrectAnswersImage
        cell.askAudienceImage.layer.opacity = record.opacityOfAskTheAudienceImage
        cell.callFriendImage.layer.opacity = record.opacityOfPhoneAFriendImage
        return cell
    }
}
