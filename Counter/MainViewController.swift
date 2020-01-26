//
//  MainViewController.swift
//  Counter
//
//  Created by Артем  Емельянов  on 04/11/2019.
//  Copyright © 2019 Artem Emelianov. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var counterStorages: [CounterStorage]! {
           return Array(realm.objects(CounterStorage.self))
       }
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func plusButtonTouched(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Add New List", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter List Name"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let text = firstTextField.text, !text.isEmpty else { return }
            self.addList(name: text)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: {
            (action : UIAlertAction!) -> Void in })

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        

        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counterStorages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomListTableViewCell
        
        cell.listLabel.text = String(counterStorages[indexPath.row].name)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let list = counterStorages[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            StorageManager.deleteObject(list)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           guard segue.identifier == "showCounter" else { return }
           guard let svc = segue.destination as? CounterViewController else { return }
           guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        svc.countersStorage = counterStorages[indexPath.row]
           }
    
    func addList(name: String) {
           let newList = CounterStorage(name: name)
           StorageManager.saveObject(newList)
       }

    
}



