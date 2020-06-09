//
//  CategoryViewController.swift
//  Todoey
//
//  Created by hamada on 6/7/20.
//  Copyright © 2020 hamada. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework
class CategoryViewController: SwipeTableViewController {
    
    let realm =  try! Realm()
    var categories : Results<Category>?

    
    override func viewDidLoad() {
        super.viewDidLoad()

      loadCategories()
        tableView.separatorStyle = .none
    }
    
    
   override func viewWillAppear(_ animated: Bool) {
       
     
            
     guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
            
        let navBarColor = UIColor(hexString: "1D9BF6")
    navBar.backgroundColor = navBarColor
         

       tableView.backgroundColor = navBarColor
    navBar.backgroundColor = navBarColor
 
    navBar.tintColor = UIColor.white
        //   navBar.standardAppearance.configureWithOpaqueBackground()
          navBar.standardAppearance.backgroundColor = navBarColor
    navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white ]
          
          
    
    
    
    
    
    
        
    }
    
    
    
    
    
    
    
    
    
    

    // MARK: - Table view data source

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         categories?.count ?? 1
     }
     
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView ,cellForRowAt: indexPath)
            
        if let catagory = categories?[indexPath.row]{
         cell.textLabel?.text = catagory.name
    cell.backgroundColor = UIColor(hexString: catagory.cellCollor )
        
            if let color = UIColor(hexString: catagory.cellCollor ){
                        
                          cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                          
                      }
            
            
            
        
        }
         return cell
     }
   
    
    

    
    
    //MARK: - Add Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

       let destintionVC = segue.destination as! TodoeyVirewController

        if  let indexPath = tableView.indexPathForSelectedRow {
            destintionVC.selectedCategory = categories?[indexPath.row]


              }



    }
    
    

    
 //MARK: - Add New Data
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
       
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                
                if (textField.text! != ""){
                   
                    let newCategory = Category()
                    newCategory.name = textField.text!
                    newCategory.cellCollor = (UIColor.randomFlat()).hexValue()
print(newCategory.cellCollor)
                    self.save(category : newCategory)
                    
                    
                }
                
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create New Item "
                
                textField = alertTextField
                
            }
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
            }
            

    
    
    
    //MARK: - Data Manipulation Methods

    func loadCategories(){

   categories = realm.objects(Category.self)
      


    }
    
    
    
    
    func save(category : Category) {
        
        do {
            try realm.write{
                realm.add(category)
                
                
            }
            
        }catch{
            
        }
        
        tableView.reloadData()
        
    }
    




override func updateModel(at indexPath : IndexPath){
    
     
             if let categoryForDeletion = categories?[indexPath.row] {
              
                 do {
                     try realm.write{
                    realm.delete(categoryForDeletion)
                                   
                                   
                               }
                               
                           }catch{
                               
                           }
    
     
                 
             }
    
    
}


}

