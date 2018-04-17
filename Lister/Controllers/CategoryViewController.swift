//
//  CategoryViewController.swift
//  Lister
//
//  Created by Joseph Pizzo on 4/16/18.
//  Copyright © 2018 PEEZEE. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    let realm = try! Realm()
    
    var categories = [Category]()
    
    let categoryContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as!ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print("error saving context \(error)")
        }
        //make new item appear in table
        self.tableView.reloadData()
    }
    
    func loadCategories(/*with request: NSFetchRequest<Category> = Category.fetchRequest()*/) {
        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            categories = try categoryContext.fetch(request)
//        } catch {
//            print("error fetching data from context \(error)")
//        }
//        tableView.reloadData() /// UGH!! GAVE ME A HEADACHE- need this to load the search info and then reload the items when x clicked
//        
    }
    
    //MARK: - Add new Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.save(category: newCategory)
           
        }
        
        alert.addAction(action)

        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create New Item"
        
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - TableView Datasource Methods
    
    //MARK: - TableView Delegate Methods -- HOLD
    
    //MARK: - Data Manipulation Methods
}
