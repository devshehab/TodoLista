//
//  SwipeViewController.swift
//  TodoLista
//
//  Created by Mac on 12/30/17.
//  Copyright © 2017 shehaboli. All rights reserved.
//

import UIKit
import SwipeCellKit
class SwipeViewController: UITableViewController, SwipeTableViewCellDelegate {
 
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
               let categoryCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
               categoryCell.delegate = self
        
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
       
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
          
                self.updateModel(ar: indexPath)
            
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for
        
        orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        
        options.expansionStyle = .destructive
        
        return options
    }
    
    func updateModel(ar indexPath: IndexPath) {
        
    }

}

