//
//  ViewController.swift
//  TodoList
//
//  Created by احلام المطيري on 28/09/2019.
//  Copyright © 2019 احلام المطيري. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     //   searchBar.delegate = self // alternative i will do it in story board
      
        loadItems()
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.text = itemArray[indexPath.row]
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        
        
        //DELET ITEM FROM CORE DATA
//        context.delete(itemArray[indexPath.row]) // it does not affect the core data unless we called save item method
//        itemArray.remove(at: indexPath.row)
        
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    @IBAction func addbutton(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "add new itwm", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            
          
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
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
    func saveItems(){
        do {
            try context.save()
            
        }catch{
            print ("error saving\(error)")
        }
        self.tableView.reloadData()
        
    }
    

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest() , predicate: NSPredicate? = nil){
     //   let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate, additionalPredicate])
        }else{
            request.predicate = categorypredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate, predicate])
//        request.predicate = compoundPredicate
        do{
        itemArray = try context.fetch(request)
        }catch{
            print ("error in reading \(error)")
        }
        tableView.reloadData()
    }
    
   
    

}
//MARK: - search bar methods
extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
    
         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        // alternative of below do catch
        loadItems(with: request , predicate: predicate)
        
//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print ("error in reading \(error)")
//        }
        
     
        
       // print (searchBar.text!)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

