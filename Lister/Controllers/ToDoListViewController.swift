//
//  ViewController.swift
//  Lister
//
//  Created by Joseph Pizzo on 4/12/18.
//  Copyright © 2018 PEEZEE. All rights reserved.

//section 249 part 19 4152018
//

import UIKit
import RealmSwift



class ToDoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
    }

    //MARK: - Tableview Data Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No iItems Added"
        }
        
        
        
        return cell
    }
    
    //MARK: - Tableview Delegate Messages
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
        
        //for deletion--- cruD
//        context.delete(todoItems[indexPath.row]) //this alone will crash app becuase the item no longer exists
//        //if it follows todoItems.remove(at: indexPath.row)
//        todoItems.remove(at: indexPath.row)
        
        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Lister Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items")
                }
                
            }
            
            self.tableView.reloadData()
        }
        
        //created as a local variable inside of this closure
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: -- Model Manipulation methods
    //MARK: -- SAVE DATA METHOD
    //Creating data in database Crud
    
    func saveItems() {
        //no longer using encoder, can remove
        //let encoder = PropertyListEncoder()
        
//        do {
//            try context.save()
////            no longer needed, from using plist to store date
////            let data = try encoder.encode(todoItems)
////            try data.write(to: dataFilePath!)
//        } catch {
//            print("error saving context \(error)")
//            //no longer need this either, coresponds to plist error
////            print("Error encoding item array, \(error)")
//        }
//        //make new item appear in table
//        self.tableView.reloadData()
    }
    
    //MARK: -- Load Items
    // Reading data in DB cRud
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData() /// UGH!! GAVE ME A HEADACHE- need this to load the search info and then reload the items when x clicked

    }
    
    

}


//MARK: - Search bar methods
//extension ToDoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        //print(searchBar.text!)
//        // NSPredicate is a query language that is similar to natural language including modifiers and conditionals %@
//        //for example-- CONTAINS is a string comparison operator
//        //let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        //print(searchBar.text!)
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        //request.predicate = predicate //--becomes line above
//
//
//        //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) // becomes line below
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        //request.sortDescriptors = [sortDescriptor] // sortDescriptors becomes an array of sortDescriptors,
//                                                    // add square brackets around NSSortDescriptors in line above
//
////        do {
////            itemArray = try context.fetch(request)
////        } catch {
////            print("error fetching data from context \(error)")
////        }
//        loadItems(with: request, predicate: predicate)
//
//        //tableView.reloadData()
//
//        }
//
//
//    //new delegate method related to search bar to return original data when searchBar is crossed with x button
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            DispatchQueue.main.async {
//                // dumps keyboard and cursor- this can freeze the app because background tasks may not be
//                //complete move to async method to fix
//                searchBar.resignFirstResponder()
//            }
//
//        }
//
//    }
//}
