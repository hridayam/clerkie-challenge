//
//  customMessageCell.swift
//  Clerkie Hridayam Bakshi Coding Challenge
//
//  Created by hridayam bakshi on 1/22/19.
//  Copyright © 2019 hridayam bakshi. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var messageBody: UITextView!
    @IBOutlet var messageBackground: UIView!
    @IBOutlet weak var sendMessage: UIView!
    @IBOutlet weak var sendMessageBody: UITextView!
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
