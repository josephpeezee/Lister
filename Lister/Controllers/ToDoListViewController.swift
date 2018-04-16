//
//  ViewController.swift
//  Lister
//
//  Created by Joseph Pizzo on 4/12/18.
//  Copyright © 2018 PEEZEE. All rights reserved.

//section 249 part 19 4152018
//

import UIKit
import CoreData



class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
    }

    //MARK: - Tableview Data Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - Tableview Delegate Messages
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //for checkmark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        //for deletion--- cruD
//        context.delete(itemArray[indexPath.row]) //this alone will crash app becuase the item no longer exists
//        //if it follows itemArray.remove(at: indexPath.row)
//        itemArray.remove(at: indexPath.row)
        
        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Lister Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //down cast as app delegate-- taps into UIApplication class getting dshared singleton object (.shared) cooresponds to the current app as an object- tapping into its delegate with the data type of an optional UIDelegate and casting (as!)it into AppDelegate both inherit from UIAPPLICATION delegate- gives access to AppDelegate as an object and taps into property of persistentcontainer and can grab as its propertyviewContext
            
            //becomes a global variable so that it can be used elsewhere, make sure to use "self" when calling within a closure
            //section 250 part 19- copied to global
            //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            
            //need to set new item = to false because if set to NIL the app will throw an error because data model
            //isnt requiring it as an option
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            //append a new row to the table
            self.itemArray.append(newItem)
            
            // func that was created to be reused section 19 part 246 12:06
            
            self.saveItems()
            
            //save updatedItem array to our user defaults --- consider something other than user defaults this will crash the app-
            //stop using user defaults - section 19 part 244
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
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
        
        do {
            try context.save()
//            no longer needed, from using plist to store date
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
        } catch {
            print("error saving context \(error)")
            //no longer need this either, coresponds to plist error
//            print("Error encoding item array, \(error)")
        }
        //make new item appear in table
        self.tableView.reloadData()
    }
    
    //MARK: -- Load Items
    // Reading data in DB cRud
    // when we call, can call externally or internally with "with" external, "request" internal and provides
    //a default when called without giving any parameters := Item.fetchRequest()
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        //specify data type of output
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //let compoundPreddicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        
        //request.predicate = compoundPreddicate
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        if let additionalPredicate == predicate { -----FUCKING == screwed me up!
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//            }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        request.predicate = compoundPredicate
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        tableView.reloadData() /// UGH!! GAVE ME A HEADACHE- need this to load the search info and then reload the items when x clicked
    
    }
    
    

}


//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //print(searchBar.text!)
        // NSPredicate is a query language that is similar to natural language including modifiers and conditionals %@
        //for example-- CONTAINS is a string comparison operator
        //let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //print(searchBar.text!)
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //request.predicate = predicate //--becomes line above
        
        
        //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) // becomes line below
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //request.sortDescriptors = [sortDescriptor] // sortDescriptors becomes an array of sortDescriptors,
                                                    // add square brackets around NSSortDescriptors in line above
        
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("error fetching data from context \(error)")
//        }
        loadItems(with: request, predicate: predicate)
        
        //tableView.reloadData()
        
        }
    

    //new delegate method related to search bar to return original data when searchBar is crossed with x button
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                // dumps keyboard and cursor- this can freeze the app because background tasks may not be
                //complete move to async method to fix
                searchBar.resignFirstResponder()
            }
            
        }
        
    }
}
