//
//  CategoryViewController.swift
//  TodoLista
//
//  Created by Mac on 12/28/17.
//  Copyright © 2017 shehaboli. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    //MARK: - Properties
    
    var category = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK: - Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategroyCell", for: indexPath)
        
        let names = category[indexPath.row]
        
        categoryCell.textLabel?.text = names.name
        
        return categoryCell
    }
    
    
    
    
     //MARK: - Tableview Delegat Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        // hatha 7g el t'9lel el rmady
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListaViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = category[indexPath.row]
        }
    }
    
    
    
    
    //MARK: - Data Manipulating (save and load) Method
    
    func saveItems() {
        
        do {
            try context.save()
        }
        catch {
            print("Error saving items \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            category = try context.fetch(request)
        }
        catch {
            print("Error Loading Items \(error)")
        }
        tableView.reloadData()
    }
    
    
    //MARK: - ADD BUTTON
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        let alert = UIAlertController(title: "Add New ToDoLista Item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            
            self.category.append(newCategory)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
            
    }
    
    
   
    
    
}
