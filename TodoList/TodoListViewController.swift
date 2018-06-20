//
//  ViewController.swift
//  TodoList
//
//  Created by Gouthami Reddy on 6/15/18.
//  Copyright © 2018 Gouthami Reddy. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    var selectCategory: Category? {
        didSet {
            loadItems()
        }
    }
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
      let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
         saveItems()
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Toso item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add item", style: .default) { (action) in
        
        let newItem = Item(context: self.context)
        newItem.title = textField.text!
        newItem.done = false
        newItem.parentCategory = self.selectCategory
        self.itemArray.append(newItem)
        self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
        textField = alertTextField
            }
 alert.addAction(action)
        present(alert, animated: true, completion: nil)
            
        }
    func saveItems() {
        
        
        do{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
           try context.save()
        }catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
        }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory MATCHES %@", selectCategory!.name!)
       
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request :NSFetchRequest<Item> = Item.fetchRequest()
         request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
     request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
        loadItems(with : request)
       
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text? .count == 0 {
            loadItems()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
}


