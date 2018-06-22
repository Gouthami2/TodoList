//
//  ViewController.swift
//  TodoList
//
//  Created by Gouthami Reddy on 6/15/18.
//  Copyright © 2018 Gouthami Reddy. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    var todoItems: Results<Item>?
    let realm =  try! Realm()
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
    return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
      let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row]{
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "no item added"
        }
        
        return cell
    }
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let item = todoItems?[indexPath.row]{
            do {
            try realm.write {
                item.done = !item.done
            }
            } catch{
                print("error saving data \(error)")
            }
        }
             tableView.reloadData()
      
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Toso item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add item", style: .default) { (action) in
        if let currentCategory = self.selectCategory {
            do {
            try self.realm.write {
                let newItem = Item()
                newItem.title = textField.text!
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
        }
            }  catch {
                    print("error saying newitems \(error)")
                }
        }
       self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
        textField = alertTextField
            }
 alert.addAction(action)
        present(alert, animated: true, completion: nil)
            
        }
    
        func loadItems() {
            
            todoItems = selectCategory?.items.sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()

        }
}
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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


