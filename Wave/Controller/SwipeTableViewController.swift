//
//  SwipeTableViewController.swift
//  Wave
//
//  Created by Capella Yee on 1/9/19.
//  Copyright © 2019 Capella Yee. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = CGFloat(80)
    }
    
    // Table View Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") {
            (action, indexPath) in
            
            self.updateModel(at: indexPath)
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func updateModel(at: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .drag
        return options
    }
    
    //MARK: - Update NavBar colors
    func updateNavBar(withHexCode hexCode: String, searchBar: UISearchBar?) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation bar does not exist.")}
        guard let color = UIColor(hexString: hexCode) else {fatalError("Couldn't create the color for the navigation bar")}
        
        // set nav bar header background color
        navBar.barTintColor = color
        
        // set search bar background
        searchBar?.barTintColor = color
        
        // set text in nav bar to be contrasting
        navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)
        
        // set title text to be contrasting
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(contrastingBlackOrWhiteColorOn: color, isFlat: true)]
        navBar.largeTitleTextAttributes = textAttributes
    }
    
}
