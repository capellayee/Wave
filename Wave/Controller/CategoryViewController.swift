//
//  CategoryViewController.swift
//  Wave
//
//  Created by Capella Yee on 1/6/19.
//  Copyright © 2019 Capella Yee. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    //MARK: Table View data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        return cell
    }
    
    
    //MARK: Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            print("button pressed")
            let alert = UIAlertController(title: "Add new todo item", message: nil, preferredStyle: .alert)
            
            // create a save action
            let saveCategoryAction = UIAlertAction(title: "Add", style: .default) {
                (action) in
                if let newCategoryName = alert.textFields?.first?.text {
                    let newCategory = Category(context: self.context)
                    newCategory.name = newCategoryName
                    self.categoryArray.append(newCategory)
                    
                    self.saveData()
                }
            }
            alert.addAction(saveCategoryAction)
            
            // create a cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
                (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancelAction)
            
            // add a text field to add in a new category
            alert.addTextField {
                (textfield) in
                textfield.placeholder = "Type your new todo list name here"
            }
            
            // show the alert
            present(alert, animated: true, completion: nil)
        }
    
    
    
        //MARK: Table view data manipulation methods
        func saveData() {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            tableView.reloadData()
        }
        
        func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
            do {
                categoryArray = try context.fetch(request)
            } catch {
                print("Error fetching data from context: \(error)")
            }
            tableView.reloadData()
        }
        
        func createRequest(withPredicate predicate: String, withKeyword keyword: String, withSortKey sortKey: String, sortAscending: Bool) -> NSFetchRequest<Category> {
            let request : NSFetchRequest<Category> = Category.fetchRequest()
            // now specify a query
            request.predicate = NSPredicate(format: predicate, keyword)
            
            // now specify sorting
            request.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: sortAscending)]
            
            return request
        }
    
    
    
    //MARK: Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        print(categoryArray[indexPath.row])
        print("performing segue")
        performSegue(withIdentifier: "goToTodoItems", sender: self)
        print("finished segue")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.parentCategory = categoryArray[indexPath.row]
        }
        
    }
    
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        self.segue
//    }
    
    

}
