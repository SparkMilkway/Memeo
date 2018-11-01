//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Spark Da Capo on 10/29/18.
//  Copyright © 2018 OneSpark. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    // Handled by Realm
    var categoryArray: Results<Categories>?
    let realm = try! Realm()
    // Intermediate context
    // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadRealm()
        
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // Has a default value of 1 if categoryArray is nil
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No category added yet"
        
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let toDoListVC = segue.destination as! ToDoListViewController
            // set the destination vc based on category
            if let indexPath = tableView.indexPathForSelectedRow {
                toDoListVC.selectedCategory = categoryArray?[indexPath.row]
            }
        }
    }
    
    // MARK: - Add new categories
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        // Shared textField Instance
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
//            let newCategory = Category(context: self.context)
//            newCategory.name = textField.text!
//
//            self.categoryArray.append(newCategory)
//            self.saveData()
            let newCategory = Categories()
            newCategory.name = textField.text!
            self.saveRealm(with: newCategory)
        }
        
        alert.addAction(alertAction)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Data manipulation methods
    
    func saveData() {
//        do{
//            try context.save()
//        }catch{
//            print("Error saving Category Data: \(error)")
//        }
//        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//        do {
//            categoryArray = try context.fetch(request)
//        }catch {
//            print("Error fetching Category Data: \(error)")
//        }
//        tableView.reloadData()
    }
    
    func saveRealm(with categories: Categories){
        do {
            try realm.write {
                realm.add(categories)
            }
        }catch {
            print("Error saving in Realm: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadRealm() {
        
        categoryArray = realm.objects(Categories.self)
        
        tableView.reloadData()
    }
    
}
