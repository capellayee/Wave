//
//  TodoListViewController.swift
//  Wave
//
//  Created by Capella Yee on 1/5/19.
//  Copyright © 2019 Capella Yee. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController : SwipeTableViewController {
    
    var todoItems : Results<TodoItem>?
    var parentCategory : Category? {
        didSet {
            loadItems()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let category = parentCategory else {fatalError("No parent category found")}
        
        // set title
        title = category.name
        
        updateNavBar(withHexCode: category.backgroundColor, searchBar: searchBar)
        
    }
    
    override func willMove(toParent parent: UIViewController?) {
        self.updateNavBar(withHexCode: "B8C9F2", searchBar: searchBar)
    }
    
    //MARK: TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isComplete ? .checkmark : .none
            let color = parentCategory?.backgroundColor ?? "008F00"
            // note it's ok to force unwrap todoItems below because this only gets called if you have an item (see parent if let statement)
            cell.backgroundColor = UIColor(hexString: color)?.darken(byPercentage: CGFloat(Double(indexPath.row) / Double(todoItems!.count)))
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
        } else {
            cell.textLabel?.text = "No todo items yet"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.gray
        }
        
        return cell
    }
    
    //MARK: TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.isComplete = !item.isComplete
                }
            } catch {
                print("error updating the isComplete state: \(error)")
            }
        }
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("button pressed")
        let alert = UIAlertController(title: "Add new todo item", message: nil, preferredStyle: .alert)
        
        // create a save action
        let saveItemAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            if let newItemTitle = alert.textFields?.first?.text {
                
                if let currentCategory = self.parentCategory {
                    do {
                        try self.realm.write {
                            let newItem = TodoItem()
                            newItem.title = newItemTitle
                            newItem.dateCreated = Date()
                            currentCategory.todoItems.append(newItem)
                        }
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                    
                }
            }
            
            self.tableView.reloadData()
        }
        alert.addAction(saveItemAction)
        
        // create a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        
        // add a text field to add in a new todo item
        alert.addTextField {
            (textfield) in
            textfield.placeholder = "Type in a new thing to do"
        }
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        todoItems = parentCategory?.todoItems.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //overriding function from swipe table view controller
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
            } catch {
                let nserror = error as NSError
                fatalError("Error deleting category \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

//MARK: Search Bar delegate methods
extension TodoListViewController : UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText)
        if searchText.count == 0 {
            loadItems()
            
            // use dispatch queue to assign tasks to different threads
            // specifically, run this mehtod in the main queue
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
}
