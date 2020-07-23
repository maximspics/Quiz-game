//
//  RecordCell.swift
//  MS-Millionaire
//
//  Created by Maxim Safronov on 22.02.2020.
//  Copyright © 2020 Maxim Safronov. All rights reserved.
//

import UIKit

class RecordCell: UITableViewCell {
    
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var hideTwoIncorrectAnswersImage: UIImageView!
    @IBOutlet weak var askAudienceImage: UIImageView!
    @IBOutlet weak var callFriendImage: UIImageView!
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
