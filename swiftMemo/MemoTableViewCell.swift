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
    
}
