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
    
    var itemsArray = [TodoItem]()
    
    let defaults = UserDefaults.standard
    // create a url to the documents folder
    //file manager provides an interface to file system
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        itemsArray.append(TodoItem(titleText: "Grate cauliflower rice"))
        
        loadItems()
    }
    
    
    //MARK: TableView Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        let item = itemsArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.isComplete ? .checkmark : .none
        return cell
    }
    
    //MARK: TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemsArray[indexPath.row].isComplete = !itemsArray[indexPath.row].isComplete

        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("button pressed")
        let alert = UIAlertController(title: "Add new todo item", message: nil, preferredStyle: .alert)
        
        // create a save action
        let saveItemAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            if let newItem = alert.textFields?.first?.text {
                self.itemsArray.append(TodoItem(titleText: newItem))
                
                //self.defaults.set(self.itemsArray, forKey: "TodoListArray")
                self.saveData()
            }
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
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemsArray)
            // write data to file path
            try data.write(to: self.dataFilePath!)
        }
        catch {
            print("Error encoding item array: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        // read the saved data and populate the screen
        if let dataContents = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                try itemsArray = decoder.decode([TodoItem].self, from: dataContents)
            }
            catch {
                print("Error decoding items array: \(error)")
            }
        }
    }
    
}
