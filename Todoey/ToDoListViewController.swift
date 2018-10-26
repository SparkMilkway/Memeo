//
//  ViewController.swift
//  Todoey
//
//  Created by Spark Da Capo on 10/25/18.
//  Copyright © 2018 OneSpark. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let someArray = ["Someting", "Comes", "With", "Love"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return someArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = someArray[indexPath.row]
        
        return cell
    }


    // MARK: - TableView Delegates Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

