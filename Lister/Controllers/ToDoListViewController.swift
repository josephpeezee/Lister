//
//  ViewController.swift
//  Lister
//
//  Created by Joseph Pizzo on 4/12/18.
//  Copyright © 2018 PEEZEE. All rights reserved.

//section 249 part 19 4152018
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        print(dataFilePath)
        
//        let newItem = Item()          using loadItems() func
//        newItem.title = "Log In"
//        itemArray.append(newItem)
//        
//        let newItem2 = Item()
//        newItem2.title = "Register"
//        itemArray.append(newItem2)
//        
//        let newItem3 = Item()
//        newItem3.title = "Tech for PeeZee"
//        itemArray.append(newItem3)
        
        //code that loads up Items.plist
        loadItems()
        
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
    }

   //MARK - Tableview Data Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title

        //Ternary operator below does the same thing as the if/else commented out below this code
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK - Tableview Delegate Messages
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)-- prints only the row number
        
        // print corresponding item in item array
        //print("\(itemArray[indexPath.row])")
        
        
        //this does the same as the if else statement following this line that is commented out
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        
        
        //adds checkmark as accessory, checks for check mark and removes checkmark
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        //removes the checkmark
        //tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Lister Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on alert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            //append a new row to the table
            self.itemArray.append(newItem)
            
            // func that was created to be reused section 19 part 246 12:06
            
            self.saveItems()
            
            //save updatedItem array to our user defaults --- consider something other than user defaults this will crash the app-
            //stop using user defaults - section 19 part 244
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            //encoder-- exists inside of func savedItems
//            let encoder = PropertyListEncoder()
//
//            do {
//                let data = try encoder.encode(self.itemArray)
//                try data.write(to: self.dataFilePath!)
//            } catch {
//                print("Error encoding item array, \(error)")
//            }
//            //make new item appear in table
//            self.tableView.reloadData()
        }
        
        //created as a local variable inside of this closure
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK -- Model Manipulation methods
    //MARK -- SAVE DATA METHOD
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        //make new item appear in table
        self.tableView.reloadData()
    }
    
    //MARK -- Load Items
    
    func loadItems() {
        // can throw error, mark with tray? turning result into an optional you will
        //need optional binding to safely unwrap data dataFilePath!
        if let data = try? Data(contentsOf: dataFilePath!) {
            // need decoder
            let decoder = PropertyListDecoder()
            do {
                try itemArray = decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

