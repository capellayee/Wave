//
//  TodoListViewController.swift
//  Wave
//
//  Created by Capella Yee on 1/5/19.
//  Copyright © 2019 Capella Yee. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TodoListViewController : UITableViewController {
    
    var itemsArray = [TodoItem]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        // if you want to delete when selecting. the order matters a huge deal!
//        context.delete(itemsArray[indexPath.row])
//        itemsArray.remove(at: indexPath.row)
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("button pressed")
        let alert = UIAlertController(title: "Add new todo item", message: nil, preferredStyle: .alert)
        
        // create a save action
        let saveItemAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            if let newItemTitle = alert.textFields?.first?.text {
                let newItem = TodoItem(context: self.context)
                newItem.title = newItemTitle
                newItem.isComplete = false
                self.itemsArray.append(newItem)
                
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
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()) {
        do {
            itemsArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        tableView.reloadData()
    }
    
    func createRequest(withPredicate predicate: String, withKeyword keyword: String, withSortKey sortKey: String, sortAscending: Bool) -> NSFetchRequest<TodoItem> {
        let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        // now specify a query
        request.predicate = NSPredicate(format: predicate, keyword)
        
        // now specify sorting
        request.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: sortAscending)]
        
        return request
    }
    
}

//MARK: Search Bar delegate methods
extension TodoListViewController : UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadItems(with: createRequest(withPredicate: "title CONTAINS[cd] %@", withKeyword: searchBar.text!, withSortKey: "title", sortAscending: true))
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
            loadItems(with: createRequest(withPredicate: "title CONTAINS[cd] %@", withKeyword: searchText, withSortKey: "title", sortAscending: true))
        }
    }
}
