//
//  ViewController.swift
//  TodoLista
//
//  Created by Mac on 12/22/17.
//  Copyright © 2017 shehaboli. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class TodoListaViewController: SwipeViewController {
    
    //MARK: - VARAIBLES AND LETS
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
       
        didSet {
            loadItems()
        }
    }
    
    //MARK: - TABLE VIEW METHODS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                
                cell.backgroundColor = color
                
                // for contrastic the text
                
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                
            cell.layer.cornerRadius = 30.0
            }
            
            
            
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TABLE VIEW DELEGATE METHODS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch {
                print("Error saving data data, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Search Bar Outlet
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    
    //MARK: - IBACTIONS 
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New ToDoLista Item", message: "", preferredStyle: .alert)
        
        var textField = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        
                        newItem.title = textField.text!
                        
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error saving Items \(error)")
                }
                
            }
            
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
        
            alertTextField.placeholder = "Create New Item"
            
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - VIEW DID LOAD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        
    }
    //MARK: - VIEW WILL APPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.colour else { fatalError() }
        
        updateNavBar(withHexCode: colorHex)
    }
    //MARK: - View Will Disapear
    
    override func viewWillDisappear(_ animated: Bool) {
        
       updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Error")}
        
        if let colorHex = self.selectedCategory?.colour {
            
            
            if let navBarColor = UIColor(hexString: colourHexCode) {
                
                navBar.barTintColor = navBarColor
                
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                
                navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                
                searchBar.barTintColor = navBarColor
            }
        }
        
    }
    
    
    //MARK: - FUNCTION
    
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete data
    
    override func updateModel(ar indexPath: IndexPath) {
        if let categoryForDeletion = todoItems?[indexPath.row] {
            
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
    
}
//MARK: - Search Bar Methods
extension TodoListaViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)

        tableView.reloadData()
    }
    // a function to restart process when X is pressed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if searchBar.text?.count == 0 {
          
            loadItems()
           
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}





