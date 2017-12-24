//
//  ViewController.swift
//  TodoLista
//
//  Created by Mac on 12/22/17.
//  Copyright © 2017 shehaboli. All rights reserved.
//

import UIKit

class TodoListaViewController: UITableViewController {

    //VARAIBLES AND LETS   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    var itemArray = [Item]()
     let dataFilePath = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
 
    
    //TABLE VIEW METHODS   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
      
        
        return cell
    }
    
    //FOR HIGHLIGHTING AND CHECKMARKS  @@@@@@@@@@@@@@@@@@@@@@@@@
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
      
        save()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //IBACTIONS  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New ToDoLista Item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.save()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //VIEW DID LOAD!  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadItems()
        
        
    }
//FUNCTION  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    
    func save() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error Encoding Item Array, \(error)")
        }
        self.tableView.reloadData()
    }
  
    func loadItems() {

        if let data = try? Data(contentsOf: dataFilePath!) {
        
            let decoder = PropertyListDecoder()
            do {
           itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print(error)
            }
        }
    }

}







