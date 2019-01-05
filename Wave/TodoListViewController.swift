//
//  TodoListViewController.swift
//  Wave
//
//  Created by Capella Yee on 1/5/19.
//  Copyright © 2019 Capella Yee. All rights reserved.
//

import Foundation
import UIKit

class TodoListViewController : UITableViewController {
    
    var itemsArray = ["meditate", "cook shroomies", "yoga"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemsArray = items
        }
    }
    
    
    //MARK: TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row]
        return cell
    }
    
    //MARK: TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("button pressed")
        let alert = UIAlertController(title: "Add new todo item", message: nil, preferredStyle: .alert)
        let saveItemAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            if let newItem = alert.textFields?.first?.text {
                self.itemsArray.append(newItem)
                
                self.defaults.set(self.itemsArray, forKey: "TodoListArray")
                
                self.tableView.reloadData()
            }
        }
        alert.addAction(saveItemAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        
        alert.addTextField {
            (textfield) in
            textfield.placeholder = "Type in a new thing to do"
        }
        present(alert, animated: true, completion: nil)
    }
    
}
