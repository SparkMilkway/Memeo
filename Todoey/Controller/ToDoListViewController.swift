//
//  ViewController.swift
//  Todoey
//
//  Created by Spark Da Capo on 10/25/18.
//  Copyright © 2018 OneSpark. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category? {
        // When this property is set, i.e. segue ready
        didSet {
            loadData()
        }
    }
    
    // Need a context in the appdelegate which is created by Apple when using core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let cellItem = itemArray[indexPath.row]
        cell.textLabel?.text = cellItem.item
        cell.accessoryType = cellItem.done ? .checkmark : .none
        
        return cell
    }

    // MARK: - TableView Delegates Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default, handler: { (action) in
            // Do something
            
            if textField.text != "" {

                // This operation creates a new Item object(NSMangedObject)
                let newItem = Item(context: self.context)
                newItem.item = textField.text!
                newItem.done = false
                // Set up the category relationship
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                // Save the new data
                self.saveData()
                
            }
        })
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Item"
            textField = alertTextField
        }
        alert.addAction(action)
                
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Data Manipulating Methods
    
    func saveData() {

        do {
            try context.save()
        }catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    // This function contains an internal and external and default parameters.
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), with predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let otherPredicate = predicate {
            // Use CompoundPredicate to combine several predicates for query
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [otherPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        }catch {
            print("Error loading context: \(error)")
        }
        
        tableView.reloadData()
    }
    
}
// MARK: - Search Bar Delegate Functions

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // c stands for case insensitive and d stands for diacritc in sensitive
        let predicate = NSPredicate(format: "item CONTAINS[cd] %@", searchBar.text!)
        
        // Sort the item in alphabetic order
        request.sortDescriptors = [NSSortDescriptor(key: "item", ascending: true)]
        
        loadData(with: request, with: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Only trigger when cross button clicked
        if (searchBar.text?.count == 0) {
            loadData()
            // Run the dismiss process asyncly in the main thread
            DispatchQueue.main.async {
                // Let the searchBar resign from the first responder and return the UI back to tableView
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

