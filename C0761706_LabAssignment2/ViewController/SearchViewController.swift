//
//  SearchViewController.swift
//  C0761706_LabAssignment2
//
//  Created by Ramanpreet Singh on 2020-01-19.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import UIKit

class SearchViewController: AbstractViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noItemsLabel: UILabel!
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // Variables
    private let persistenceManager = PersistenceManager.shared
    
    private var items: [Todo]? {
        didSet {
            noItemsLabel.isHidden = items!.count > 0
        }
    }
    
    private enum SortType: String {
        case byDate = "Sort by Title", byTitle = "Sort by Date"
    }
    
    private var sortType: SortType = .byDate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }

    private func initViews() {
        tableView.tableFooterView = UIView()
        fetchData()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func fetchData() {
        persistenceManager.fetch(type: Todo.self) { (todos) in
            self.items = todos
            self.sortTodo()
        }
    }
    
    @IBAction func addTaskButtonClicked(_ sender: Any) {
        navigationController?.pushViewController(AddEditTaskViewController.control(With: .add), animated: true)
    }
    
    @IBAction func sortButtonClicked(_ sender: UIBarButtonItem) {
        sortButton.title = sortType.rawValue
        sortTodo()
    }
    
    private var cellClass: TodoCell.Type {
        return TodoCell.self
    }
    
    private func sortTodo() {
        switch sortType {
        case .byDate:
            sortType = .byTitle
            items?.sort { (($0.dateTime).compare($1.dateTime)) == .orderedDescending }
        case .byTitle:
            sortType = .byDate
            items?.sort { ($0.title).lowercased() < ($1.title).lowercased() }
        }
        tableView.reloadData()
    }
    
    internal func refresh() {
        reshuffleSortType()
        fetchData()
    }
    
    private func reshuffleSortType() {
        if sortType == .byDate {
            sortType = .byTitle
        } else {
            sortType = .byDate
        }
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let todo = self.items?[indexPath.row]
        let deleteItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.persistenceManager.delete(type: Todo.self, todo: todo!) { (flag) in
                if flag {
                    self.items?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    Helper.showAlert(with: "Todo deleted successfully.", controller: self)
                }
            }
        }
        
        let editDayItem = UIContextualAction(style: .normal, title: "Add a day") {  (contextualAction, view, boolValue) in
            let todo = self.items?[indexPath.row]
            self.persistenceManager.update(type: Todo.self, todo: todo!) { (todoObject) in
                if let todo = todoObject as? Todo {
                    todo.daysWorked += 1
                    if todo.totalDays == todo.daysWorked {
                        todo.isDone = true
                    }
                }
            }
            do {
                try self.persistenceManager.context.save()
            } catch {
                Helper.showAlert(with: error.localizedDescription, controller: self)
            }
            tableView.reloadData()
        }
        var swipeActions = UISwipeActionsConfiguration()
        if todo!.totalDays > todo!.daysWorked  && !todo!.isDone {
            swipeActions = UISwipeActionsConfiguration(actions: [deleteItem, editDayItem])
        } else {
            swipeActions = UISwipeActionsConfiguration(actions: [deleteItem])
        }
        return swipeActions
    }
}

/*
 Manage search bar delegates
 */
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let search = searchBar.text else { return }
        persistenceManager.search(type: Todo.self, keyword: search) { (todos) in
            self.items = todos
            self.reshuffleSortType()
            self.sortTodo()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        refresh()
    }
}
