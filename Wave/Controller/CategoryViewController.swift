//
//  CategoryViewController.swift
//  Wave
//
//  Created by Capella Yee on 1/6/19.
//  Copyright © 2019 Capella Yee. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    var categories : Results<Category>?
    
    lazy var realm = try! Realm() // here the exclamation mark isn't bad. according to realm, the first time you create a realm instance is created it may fail.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
    //MARK: Table View data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        if let categoryName = categories?[indexPath.row].name {
            cell.textLabel?.text = categoryName
        } else {
            cell.textLabel?.text = "No categories yet"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.gray
        }
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
                    let newCategory = Category()
                    newCategory.name = newCategoryName
                    
                    self.save(category: newCategory)
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
    func save(category: Category) {
            do {
                try realm.write {
                    realm.add(category)
                }
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
            tableView.reloadData()
        }
        
        func loadItems() {
            categories = realm.objects(Category.self)
            tableView.reloadData()
        }
    
    //MARK: Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.parentCategory = categories?[indexPath.row]
        }
        
    }
}
