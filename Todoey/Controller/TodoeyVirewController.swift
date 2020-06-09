//
//  ViewController.swift
//  Todoey
//
//  Created by hamada on 5/1/20.
//  Copyright © 2020 hamada. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class TodoeyVirewController: SwipeTableViewController  {
    let realm = try! Realm()
      var todoItems : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? {
        
        didSet{
            
        loadData()
            
        }
        
        
    }
    
  
    
    override func viewDidLoad() {
        
 
        super.viewDidLoad()
         tableView.separatorStyle = .none
 
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
        if let colorHex = selectedCategory?.cellCollor{
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
           
            if let navBarColor = UIColor(hexString:colorHex){
                searchBar.barTintColor = UIColor(hexString: colorHex)
                searchBar.searchTextField.backgroundColor = .white
                
                
                tableView.backgroundColor = navBarColor
                navBar.backgroundColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
              //   navBar.standardAppearance.configureWithOpaqueBackground()
                navBar.standardAppearance.backgroundColor = navBarColor
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true) ]
                
                
          
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
      
        if let item = todoItems?[indexPath.row] {
            
          cell.textLabel?.text = item.title
         cell.accessoryType =  item.done  ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory!.cellCollor )?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count) ){
                
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                
            }
    
            
          
        }else {
            cell.textLabel?.text = "No Items Added Yet !!"
            
        }
        

        
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if let item = todoItems?[indexPath.row]{
            
            do{
                try realm.write{
            item.done = !item.done
                }
                
            }catch{}
            
        }
        

        tableView.reloadData()
        
    }
    
    
//MARK: - Data Manipulation Methods
    func loadData(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending : true )

        tableView.reloadData()

    }

        override func updateModel(at indexPath : IndexPath){
        
         
                 if let itemForDeletion = todoItems?[indexPath.row] {
                  
                     do {
                         try realm.write{
                                    realm.delete(itemForDeletion)
                                       
                                       
                                   }
                                   
                               }catch{
                                   
                               }
        
                     
                     
                     
                 }
        
        
    }


    
    //MARK: - Add New Data
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item ", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            if (textField.text! != ""){
                if let text1 = textField.text{
                    
                    if let currentCategory = self.selectedCategory{
                        do{
                    
                        try self.realm.write{
                        let newItem = Item()
                        newItem.title = text1
                            newItem.dateCreated = Date()
                       currentCategory.items.append(newItem)
                       
                   
                        }
                        
                        
                    }catch{}
                    
                        self.tableView.reloadData()
                }

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
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@ " , searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        
        



    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadData()
        if searchBar.text?.count == 0 {

          
            DispatchQueue.main.async {

              searchBar.resignFirstResponder()
            }


        }else {
        
              todoItems = todoItems?.filter("title CONTAINS[cd] %@ " , searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()

        }
    }
    
    
    
}





