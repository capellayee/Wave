//
//  CategoryViewController.swift
//  Wave
//
//  Created by Capella Yee on 1/6/19.
//  Copyright © 2019 Capella Yee. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    var categories : Results<Category>?
    var colors = [FlatRed(), FlatRedDark(), FlatOrange(), FlatOrangeDark(), FlatYellow(), FlatYellowDark(), FlatGreen(), FlatGreenDark(), FlatLime(), FlatLimeDark(), FlatSand(), FlatSandDark(), FlatCoffee(), FlatCoffeeDark(), FlatForestGreen(), FlatForestGreenDark()]
    
    lazy var realm = try! Realm() // here the exclamation mark isn't bad. according to realm, the first time you create a realm instance is created it may fail.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateNavBar(withHexCode: FlatPowderBlue().hexValue(), searchBar: nil)
    }
    
    //MARK: Table View data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.backgroundColor) ?? UIColor(hexString: "008F00")
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
        } else {
            cell.textLabel?.text = "No categories yet"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = UIColor.gray
        }
        
        return cell
    }
    
    
    //MARK: Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            let alert = UIAlertController(title: "Add new todo item", message: nil, preferredStyle: .alert)
            
            // create a save action
            let saveCategoryAction = UIAlertAction(title: "Add", style: .default) {
                (action) in
                if let newCategoryName = alert.textFields?.first?.text {
                    let newCategory = Category()
                    newCategory.name = newCategoryName
                    //newCategory.backgroundColor = UIColor.randomFlat.hexValue()
                    newCategory.backgroundColor = self.colors[Int.random(in: 0...self.colors.count)].hexValue()
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
    
    
    //overriding function from swipe table view controller
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
            } catch {
                let nserror = error as NSError
                fatalError("Error deleting category \(nserror), \(nserror.userInfo)")
            }
        }
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
