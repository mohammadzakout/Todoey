//
//  ViewController.swift
//  Todoey
//
//  Created by hamada on 5/1/20.
//  Copyright © 2020 hamada. All rights reserved.
//

import UIKit
import CoreData
class TodoeyVirewController: UITableViewController  {
    
    var category : Category? {
        
        didSet{
            
          loadData()
            
        }
        
        
    }
    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   
    
    
    
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        //          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
         
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let  item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType =  item.done  ? .checkmark : .none
        
        
        
        
        
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //            context.delete(itemArray[indexPath.row])
        //            itemArray.remove(at: indexPath.row)
        print(itemArray[indexPath.row].title!)
        
        saveItems()
        
        
        
        
    }
    
    
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil ){

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)

        if let additionalPredicate = predicate {
   request.predicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate ,additionalPredicate])

            
        }else {
            
            request.predicate = categoryPredicate
            
        }
        
        
        
        do{
            
            itemArray = try context.fetch(request)
            
        }catch {}
        
        tableView.reloadData()
        
    }
    
    
    
    
    
    func saveItems() {
   
        do {
            try context.save()
            
        }catch{
            
        }

        tableView.reloadData()
        
    }
    
    
    
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item ", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if (textField.text! != ""){
                
                
                
                if let text1 = (textField.text){
                    let newItem = Item(context: self.context)
                    newItem.title = text1
                    newItem.done = false
                    newItem.parentCategory = self.category!
                    self.itemArray.append(newItem)
                    self.saveItems()
                    
                }
                
            }
            
          
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item "
            
            textField = alertTextField
            
            
            
        }
        
        
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    

    
    
   
}




//MARK: - Search Bar Methods


extension TodoeyVirewController : UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
       let  predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
     
        
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData( with: request , predicate : predicate)
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadData()
            DispatchQueue.main.async {
                
              searchBar.resignFirstResponder()
            }
            
            
        }else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
                  
                  let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
               
                  
                  request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
                  
            loadData(with: request , predicate : predicate)
            
            
            
        }
    }
    
}





