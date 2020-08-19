//
//RemindMe : CategoryVC.swift By: Tymon Golęba Frygies on 19:56. 
// Copyright (c) 2020, Tymon Golęba Frygies. All rights reserved.


import UIKit
import CoreData


class CategoryVC: UITableViewController {

    var categoryArray = [Category]()
    let categoryContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()


        loadCategory()
        tableView.reloadData()

    }

    //MARK: - TebleView Datasource Methods
    // methods allowing display categories

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let brick = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        brick.textLabel?.text = categoryArray[indexPath.row].name
        return brick
    }

    //MARK: - Add New Categories

    @IBAction func addCategory(_ sender: UIBarButtonItem) {

        var textContent = UITextField()

        let alert = UIAlertController(title: "Add", message: "Add new category", preferredStyle: .alert)

        let add = UIAlertAction(title: "Add", style: .default) { (addCategory) in
            let newCategory = Category(context: self.categoryContext)
            newCategory.name = textContent.text
            self.categoryArray.append(newCategory)
            self.saveCategory()

        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addTextField { (inputText) in
            inputText.placeholder = "Add new category"
            inputText.textAlignment = .center
            textContent = inputText
        }
        alert.addAction(cancel)
        alert.addAction(add)

        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods

    func saveCategory () {

        do {
            try categoryContext.save()
        } catch {
            print("Error while saving context: \(error), \(error.localizedDescription)")
        }

        tableView.reloadData()
    }

    func loadCategory () {
        let request : NSFetchRequest<Category> = Category.fetchRequest()

        do {
            categoryArray = try categoryContext.fetch(request)
        } catch {
            print("Error while loading category context: \(error)")
        }

    }

    //MARK: - TableView Delegate Methods



    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        performSegue(withIdentifier: "goToItems", sender: self)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! RemindMeVC

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

}
