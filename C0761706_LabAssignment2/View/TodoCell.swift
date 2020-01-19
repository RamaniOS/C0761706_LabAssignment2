//
//  TodoCell.swift
//  C0761706_LabAssignment2
//
//  Created by Ramanpreet Singh on 2020-01-19.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    class var reuseId: String {
        return String(describing: self)
    }
    
    var todo: Todo? {
        didSet {
            if let todo = todo {
                titleLabel.text = todo.title
                daysLabel.text = "\(todo.totalDays)"
                descLabel.text = todo.desc
            }
        }
    }
}
