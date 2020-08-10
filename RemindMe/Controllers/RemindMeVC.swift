//
//RemindMe : ViewController.swift By: Tymon Golęba Frygies on 17:41. 
// Copyright (c) 2020, Tymon Golęba Frygies. All rights reserved.


import UIKit

class RemindMeVC: UITableViewController {

    var itemsList = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        print(dataFilePath!)
        
        loadItems()
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

        itemsList[indexPath.row].done = !itemsList[indexPath.row].done

        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)

    }

    @IBAction func addButtonPressed(_ sender: Any) {
        var inputText = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            //what will happen once user clicks add action
            let newItem = Item()
            newItem.title = inputText.text!
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

    //encoding and saving data
    func saveItems () {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemsList)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array \(error)")
        }
        self.tableView.reloadData()
    }

    func loadItems () {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemsList = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error while decoding data: \(error)")
            }

        }
        tableView.reloadData()
    }

}

