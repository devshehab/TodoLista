//
//  CategoryViewController.swift
//  TodoLista
//
//  Created by Mac on 12/28/17.
//  Copyright © 2017 shehaboli. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    //MARK: - Properties
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadCategories()
    }
    
    //MARK: - Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categoryCell = tableView.dequeueReusableCell(withIdentifier: "CategroyCell", for: indexPath)

        
        categoryCell.textLabel?.text = categories?[indexPath.row].name ?? "NO Category added"
        
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
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    
    
    //MARK: - Data Manipulating (save and load) Method
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving items \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    //MARK: - ADD BUTTON
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        let alert = UIAlertController(title: "Add New ToDoLista Item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
            
    }
    
    
   
    
    
}
