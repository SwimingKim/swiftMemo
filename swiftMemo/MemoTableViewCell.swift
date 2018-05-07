//
//  MemoTableViewCell.swift
//  swiftMemo
//
//  Created by KimSuyoung on 2018. 5. 7..
//  Copyright © 2018년 KimSuyoung. All rights reserved.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    
    static let identifier = "MemoTableViewCell"

    @IBOutlet weak var memoTitleLabel: UILabel!
    @IBOutlet weak var memoContentLabel: UILabel!
    @IBOutlet weak var memoDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
