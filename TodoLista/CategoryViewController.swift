//
//  CategoryViewController.swift
//  TodoLista
//
//  Created by Mac on 12/28/17.
//  Copyright © 2017 shehaboli. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeViewController {

    //MARK: - Properties
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
    //MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        loadCategories()
    
    }
    
    //MARK: - Tableview Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let Cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
        
        Cell.textLabel?.text = category.name

            guard let categoryColor = UIColor(hexString: category.colour) else { fatalError() }
            
        Cell.backgroundColor = categoryColor
            
        Cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
            
            Cell.layer.cornerRadius = 30.0
        }
      
        
        return Cell
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
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(ar indexPath: IndexPath) {
       
        if let categoryForDeletion = self.categories?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }
            catch {
                print("Error deleting category, \(error)")
            }
            
        }
    }
    
    //MARK: - ADD BUTTON
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        let alert = UIAlertController(title: "Add New ToDoLista Item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            newCategory.colour = UIColor.randomFlat.hexValue()
        
            
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




