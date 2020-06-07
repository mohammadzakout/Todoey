//
//  CategoryViewController.swift
//  Todoey
//
//  Created by hamada on 6/7/20.
//  Copyright © 2020 hamada. All rights reserved.
//

import UIKit

import CoreData

class CategoryViewController: UITableViewController {
    
    
    var categories : [Category] = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       loadCategories()
    }

    // MARK: - Table view data source

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         categories.count
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
         let  item = categories[indexPath.row]
         cell.textLabel?.text = item.name
         
     
         
         
         return cell
     }
   
    //MARK: - Add Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
      
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       let destintionVC = segue.destination as! TodoeyVirewController
        
        if  let indexPath = tableView.indexPathForSelectedRow {
            destintionVC.category = categories[indexPath.row]
                 
                  
              }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
 //MARK: - Add New Data
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
       
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                
                if (textField.text! != ""){
                   
                    let category = Category(context: self.context)
                    category.name = textField.text!
                    self.categories.append(category)
                    self.saveCategory()
                    
                    
                }
                
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create New Item "
                
                textField = alertTextField
                
            }
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
            }
            

    
    
    
    //MARK: -Data Manipulation Methods

    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){

        
        
        do {
            categories = try context.fetch(request)
        } catch  {
            
        }

   

    }
    
    
    
    
    func saveCategory() {
        
        do {
            try context.save()
            
        }catch{
            
        }
        
        tableView.reloadData()
        
    }
    
    
    

}
