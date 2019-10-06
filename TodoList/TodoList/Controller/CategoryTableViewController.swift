//
//  CategoryTableViewController.swift
//  TodoList
//
//  Created by احلام المطيري on 02/10/2019.
//  Copyright © 2019 احلام المطيري. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()

    }
    
    //MARK: - ADD NEW CATEGORY

    @IBAction func addBottonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add ", style: .default) { (action) in
            
            
            
       
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
          
            
            self.categoryArray.append(newCategory)
            self.saveItems()
            //    self.itemArray.append(textField.text!)
            //            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
        
        
    }
   
    
    
    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categorycell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        
        
        
        return cell
    }
    
  // MARK: - Table view delegate methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
       performSegue(withIdentifier:"goToItems", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        
        if   let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - DATA MANIPULATION METHODS
    func saveItems(){
        do {
            try context.save()
            
        }catch{
            print ("error saving\(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadItems(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print ("error in reading \(error)")
        }
        tableView.reloadData()
    }



}
