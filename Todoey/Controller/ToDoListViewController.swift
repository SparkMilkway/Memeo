//
//  ViewController.swift
//  Todoey
//
//  Created by Spark Da Capo on 10/25/18.
//  Copyright © 2018 OneSpark. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import SwipeCellKit

class ToDoListViewController: SwipeTableViewController {

    // Attributes
    
    // Using Realm object now
    var toDoItems : Results<Items>?
    let realm = try! Realm()
    var selectedCategory : Categories? {
        // When this property is set, i.e. segue ready
        didSet {
            loadRealm()
        }
    }
    
    // Need a context in the appdelegate which is created by Apple when using core data
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // First inherit from super class then downcast to customized ItemTableCell class
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! ItemTableCell
        
        if let cellItem = toDoItems?[indexPath.row] {
            
            cell.titleLabel.text = cellItem.title
            cell.createdDateLabel.text = cellItem.createdDate?.toString(dateFormat: "MM/dd/yyyy")
            
            cell.accessoryType = cellItem.done ? .checkmark : .none
        }
        else {
            //cell.textLabel?.text = "No items yet"
            cell.titleLabel.text = "No items yet"
            cell.createdDateLabel.text = ""
        }
        
        
        return cell
    }

    // MARK: - TableView Delegates Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If the item exists
        if let item = toDoItems?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error changing done property in Realm: \(error)")
            }
            
        }
        tableView.reloadData()
        
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
//                let newItem = Item(context: self.context)
//                newItem.item = textField.text!
//                newItem.done = false
//                // Set up the category relationship
//                newItem.parentCategory = self.selectedCategory
//                self.itemArray.append(newItem)
//                // Save the new data
//                self.saveData()
                
                if let currentCategory = self.selectedCategory {
                    // If selectedCategory isn't nil then do creating and saving in the same time.
                    do {
                        try self.realm.write {
                            let newItem = Items()
                            newItem.title = textField.text!
                            newItem.createdDate = Date()
                            currentCategory.items.append(newItem)
                        }
                    }catch {
                        print("Error saving new Realm item: \(error)")
                    }
                }
                self.tableView.reloadData()
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
    // Core Data Implementation
//    func saveData() {
//
//        do {
//            try context.save()
//        }catch {
//            print("Error saving context: \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    // This function contains an internal and external and default parameters.
//    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), with predicate: NSPredicate? = nil) {
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        if let otherPredicate = predicate {
//            // Use CompoundPredicate to combine several predicates for query
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [otherPredicate, categoryPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        }catch {
//            print("Error loading context: \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    func loadRealm() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "createdDate", ascending: true)
        tableView.reloadData()
    }
    
    // Delete method using Swipe
    override func deleteAction(at indexPath: IndexPath) {
        
        if let itemForDeletion = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item using Realm: \(error)")
            }
        }
        
    }
    
}



// MARK: - Search Bar Delegate Functions

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Core Data methods
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        // c stands for case insensitive and d stands for diacritc in sensitive
//        let predicate = NSPredicate(format: "item CONTAINS[cd] %@", searchBar.text!)
//
//        // Sort the item in alphabetic order
//        request.sortDescriptors = [NSSortDescriptor(key: "item", ascending: true)]
//
//        loadData(with: request, with: predicate)
        
        // Realm Methods
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: true)
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Only trigger when cross button clicked
        if (searchBar.text?.count == 0) {
            loadRealm()
            // Run the dismiss process asyncly in the main thread
            DispatchQueue.main.async {
                // Let the searchBar resign from the first responder and return the UI back to tableView
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

// MARK: - Date extender
extension Date {
    
    func toString (dateFormat format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
        
    }
}
