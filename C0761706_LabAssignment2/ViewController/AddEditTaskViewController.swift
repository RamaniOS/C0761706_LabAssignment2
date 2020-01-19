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
    private let persistenceManager = PersistenceManager.shared
    private var task: Todo?
    
    class func control(With type: TaskType, and todo: Todo? = nil) -> AddEditTaskViewController {
        let control = self.control as! AddEditTaskViewController
        control.type = type
        control.task = todo
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
        if let todo = task { self.todo = todo }
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        if !titleTextField.hasText {
            Helper.showAlert(with: "Please enter todo title.", controller: self)
        } else if !daysTextField.hasText {
            Helper.showAlert(with: "Please enter total number of days to complete todo.", controller: self)
        } else if !descTextView.hasText {
            Helper.showAlert(with: "Please enter todo desc.", controller: self)
        } else {
            let todo = Todo(context: persistenceManager.context)
            todo.title = titleTextField.text!
            todo.totalDays = (daysTextField.text! as NSString).doubleValue
            todo.dateTime = Date()
            todo.desc = descTextView.text!
            do {
                try persistenceManager.context.save()
                previousControl?.refresh()
                navigationController?.popViewController(animated: true)
                Helper.showAlert(with: "Todo Saved Successfully.", controller: self)
            } catch {
                Helper.showAlert(with: error.localizedDescription, controller: self)
            }
        }
    }
    
    // MARK: Get previous controller
    private var previousControl: SearchViewController? {
        let viewControls = navigationController?.viewControllers
        if let count = viewControls?.count, count >= 2 {
            let control = viewControls?[count - 2]
            if control is SearchViewController, let customer = control as? SearchViewController {
                return customer
            }
        }
        return nil
    }
    
    var todo: Todo? {
        didSet {
            guard let todo = todo else { return }
            titleTextField.text = todo.title
            daysTextField.text = "\(todo.totalDays)"
            descTextView.text = todo.desc
        }
    }
}
