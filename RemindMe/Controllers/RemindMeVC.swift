//
//RemindMe : ViewController.swift By: Tymon Golęba Frygies on 17:41. 
// Copyright (c) 2020, Tymon Golęba Frygies. All rights reserved.


import UIKit
import CoreData

class RemindMeVC: UITableViewController {
    
    var itemsList = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    let dataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        let item = itemsList[indexPath.row]
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        //value = condition ? value if true : value if false
        // check if the accesoryType is true; if so set checkmark, otherwise set none.
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // itemsList[indexPath.row].done = !itemsList[indexPath.row].done
        
        dataContext.delete(itemsList[indexPath.row]) // record removes item from the context
        itemsList.remove(at: indexPath.row) // record removes item from the itemList
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var inputText = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once user clicks add action
            
            let newItem = Item(context: self.dataContext)
            newItem.title = inputText.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemsList.append(newItem)
            self.saveItems()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Add new item."
            textField.textAlignment = .center
            inputText = textField
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems () {
        
        do {
            try dataContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
    
    //function takes parameter or specified (as an array of Items of NSFetchRequest types OR default value: Item.fetchRequest() 
    func loadItems (with request: NSFetchRequest <Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        //to check if predicate (as function parameter is passed in) is not nil
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemsList = try dataContext.fetch(request)
        } catch {
            print("Error while fetching data from context: \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - SearchBar methods
extension RemindMeVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let requestData: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        requestData.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: requestData, predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }

    }
    
}

