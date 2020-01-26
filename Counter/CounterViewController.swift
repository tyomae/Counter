//
//  ViewController.swift
//  Counter
//
//  Created by Артем  Емельянов  on 02/11/2019.
//  Copyright © 2019 Artem Emelianov. All rights reserved.
//

import UIKit
import RealmSwift

class CounterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var countersStorage: CounterStorage!
    private var counters: [Counter] {
        return Array(countersStorage.counters)
    }
    
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var clearButton: UIBarButtonItem!
    
    
    @IBAction func plusButtonTouched(_ sender: Any) {
        addCounter()
        checkEnableClearAllButton()
        tableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        tableView.delegate = self
        tableView.dataSource = self
        checkEnableClearAllButton()
    }
    
    @IBAction func clearAllButton(_ sender: Any) {
        
       let actionSheet = UIAlertController(title: nil,
              message: nil,
              preferredStyle: .actionSheet)
              
              let deleteAll = UIAlertAction(title: "Clear All", style: .destructive) { _ in
                self.deleteAllCounters()
                self.checkEnableClearAllButton()
                self.tableView.reloadData()
              }
        
              let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(deleteAll)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCounterTableViewCell
        
        cell.countLabel.text = String(counters[indexPath.row].value)
        cell.plusButtonToched = {
            try? realm.write {
                self.counters[indexPath.row].value += 1
            }
            tableView.reloadData()
        }
        cell.minusButtonToched = {
            try? realm.write {
                self.counters[indexPath.row].value -= 1
            }
            tableView.reloadData()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
           
           let counter = counters[indexPath.row]
           let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
               StorageManager.deleteObject(counter)
               tableView.deleteRows(at: [indexPath], with: .automatic)
            self.checkEnableClearAllButton()
           }
           
           return [deleteAction]
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Enter number", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.textAlignment = .center
            textField.placeholder = "Enter number"
            textField.keyboardType = .numberPad
        }
        let plusAction = UIAlertAction(title: "+", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let text = firstTextField.text, !text.isEmpty else { return }
             try? realm.write {
            self.counters[indexPath.row].value += Int(text)!
            }
            self.tableView.reloadData()
        })
        let minusAction = UIAlertAction(title: "-", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let text = firstTextField.text, !text.isEmpty else { return }
             try? realm.write {
            self.counters[indexPath.row].value -= Int(text)!
            }
            self.tableView.reloadData()
        })
        
       let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(plusAction)
        alertController.addAction(minusAction)
        alertController.addAction(cancel)

        self.present(alertController, animated: true, completion: nil)
    }
    
    func addCounter() {
        try? realm.write {
            self.countersStorage.counters.append(Counter(value: 0))
        }

    }
    
    func deleteAllCounters() {
        counters.forEach({ counter in
            StorageManager.deleteObject(counter)
        })
    }
    
    func checkEnableClearAllButton() {
        if counters.isEmpty == false {
            clearButton.isEnabled = true
        } else {
            clearButton.isEnabled = false
        }
    }

}



