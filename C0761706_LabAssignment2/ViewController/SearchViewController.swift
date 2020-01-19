//
//  SearchViewController.swift
//  C0761706_LabAssignment2
//
//  Created by Ramanpreet Singh on 2020-01-19.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noItemsLabel: UILabel!
    
    private let persistenceManager = PersistenceManager.shared
    
    internal func refresh() {
        fetchData()
    }
    
    private var items: [Todo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        fetchData()
    }
    
    private func fetchData() {
        persistenceManager.fetch(type: Todo.self) { (todos) in
            self.items = todos
            self.noItemsLabel.isHidden = todos.count > 0
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addTaskButtonClicked(_ sender: Any) {
        navigationController?.pushViewController(AddEditTaskViewController.control(With: .add), animated: true)
    }
    
    private var cellClass: TodoCell.Type {
        return TodoCell.self
    }
}

// MARK:- Manage Customer List
typealias CustomerListControl = SearchViewController
extension CustomerListControl: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellClass.reuseId, for: indexPath) as! TodoCell
        cell.todo = items![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(AddEditTaskViewController.control(With: .edit, and: items?[indexPath.row]), animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

