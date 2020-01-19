//
//  AddEditTaskViewController.swift
//  C0761706_LabAssignment2
//
//  Created by Ramanpreet Singh on 2020-01-19.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit

enum TaskType: String {
    case add = "Add Task", edit = "Edit Task"
}

class AddEditTaskViewController: AbstractViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var daysTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    
    private var type: TaskType = .add
    
    class func control(With type: TaskType) -> AddEditTaskViewController {
        let control = self.control as! AddEditTaskViewController
        control.type = type
        return control
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    private func initViews() {
        title = type.rawValue
        Helper.applyGradient(to: saveButton)
        titleTextField.setBottomLine()
        daysTextField.setBottomLine()
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
    }
}
