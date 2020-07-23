//
//  UIbutton+Extention.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 18.02.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit

extension UIButton {
    func createAnswerButton() {
        let button = self
        button.setTitleColor(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), for: UIControl.State.init())
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byTruncatingTail
        button.titleLabel?.numberOfLines = 3
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.cornerRadius = button.bounds.height / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        button.layer.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 0.7)
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        button.contentEdgeInsets.left = 20
    }
    
    func createMainMenuButton() {
        let button = self
        button.setTitleColor(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), for: UIControl.State.init())
        button.layer.cornerRadius = button.bounds.height / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        button.layer.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.2, blue: 1, alpha: 0.7)
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    }
}

extension UILabel {
    func createMainMenuLabel() {
        let label = self
        label.layer.cornerRadius = label.bounds.height / 2
        label.layer.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.1983509958, blue: 1, alpha: 0.7)
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        label.layer.shadowRadius = 4.0
        label.layer.shadowOpacity = 0.6
        label.layer.shadowOffset = CGSize.zero
        label.layer.shadowColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    }
    func createAddQuestionLabel() {
        let label = self
        label.layer.cornerRadius = label.bounds.height / 2
        label.layer.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.1983509958, blue: 1, alpha: 0.7)
        label.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        label.layer.borderWidth = 0
        label.layer.shadowRadius = 1.0
        label.layer.shadowOpacity = 0.6
        label.layer.shadowOffset = CGSize.zero
        label.layer.shadowColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    }
}

extension UIView {
    func createQuestionView() {
        let view = self
        view.layer.cornerRadius = view.bounds.height / 2
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        view.layer.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.2, blue: 1, alpha: 0.7)
        view.layer.shadowRadius = 4.0
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    }
    func createMoneyView() {
        let view = self
        view.layer.cornerRadius = view.bounds.height / 0.8
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        view.layer.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        view.layer.shadowRadius = 4.0
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    }
    func createAddQuestionView() {
        let view = self
        view.layer.cornerRadius = view.bounds.height / 2
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        view.layer.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.2, blue: 1, alpha: 0.7)
        view.layer.shadowRadius = 4.0
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    }
}

extension UITableViewCell {
    func createCell() {
        let cell = self
        cell.layer.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 0.5)
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        cell.layer.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 0.5)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 0.6
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    }
}

extension UISegmentedControl {
    func createSegementControl() {
        let segmentControl = self
        let titleIsNormal = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let titleIsSelected = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)]
        segmentControl.setTitleTextAttributes(titleIsNormal, for: .normal)
        segmentControl.setTitleTextAttributes(titleIsSelected, for: .selected)
        segmentControl.layoutMargins.top = 120.0
        segmentControl.layer.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 0.8)
        segmentControl.layer.borderWidth = 1
        segmentControl.layer.borderColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        segmentControl.layer.shadowRadius = 4.0
        segmentControl.layer.shadowOpacity = 0.6
        segmentControl.layer.shadowOffset = CGSize.zero
        segmentControl.layer.shadowColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
    }
}

extension UITextField {
    func createTextField() {
        let textField = self
        textField.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.2, blue: 1, alpha: 0)
    }
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

