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
	var counterTitle = ""
	private var counters: [Counter] {
		return Array(countersStorage.counters)
	}
	
	@IBOutlet var tableView: UITableView!
	@IBOutlet var clearButton: UIBarButtonItem!
	
	@IBAction func plusButtonTouched(_ sender: Any) {
		self.addCounter()
		self.checkEnableClearAllButton()
		self.tableView.reloadData()
	}
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
		tableView.tableFooterView = UIView(frame: CGRect(x: 0,
														 y: 0,
														 width: tableView.frame.size.width,
														 height: 1))
		self.title = counterTitle
		
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		self.checkEnableClearAllButton()
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
			self.updateCounterValue(indexPath: indexPath, state: .increase(value: 1))
		}
		cell.minusButtonToched = {
			self.updateCounterValue(indexPath: indexPath, state: .decrease(value: 1))
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
		self.showChangeCounterValueAlert(indexPath: indexPath)
	}
	
	private func addCounter() {
		try? realm.write {
			self.countersStorage.counters.append(Counter(value: 0))
		}
	}
	
	private func deleteAllCounters() {
		counters.forEach({ counter in
			StorageManager.deleteObject(counter)
		})
	}
	
	private func checkEnableClearAllButton() {
		if counters.isEmpty == false {
			clearButton.isEnabled = true
		} else {
			clearButton.isEnabled = false
		}
	}
	
	private func showChangeCounterValueAlert(indexPath: IndexPath) {
		let alertController = UIAlertController(title: "Enter number", message: "", preferredStyle: UIAlertController.Style.alert)
		alertController.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		alertController.addTextField { (textField : UITextField!) -> Void in
			textField.textAlignment = .center
			textField.placeholder = "Enter number"
			textField.keyboardType = .numberPad
		}
		
		var numberFromTextFiled: Int {
			guard let textField  = alertController.textFields?.first else { return 0 }
			guard let text = textField.text, !text.isEmpty else { return 0 }
			return Int(text) ?? 0
		}
		
		let plusAction = UIAlertAction(title: "+", style: UIAlertAction.Style.default, handler: { alert -> Void in
			self.updateCounterValue(indexPath: indexPath, state: .increase(value: numberFromTextFiled))
		})
		let minusAction = UIAlertAction(title: "-", style: UIAlertAction.Style.default, handler: { alert -> Void in
			self.updateCounterValue(indexPath: indexPath, state: .decrease(value: numberFromTextFiled))
		})
		
		let cancel = UIAlertAction(title: "Cancel", style: .destructive)
		
		alertController.addAction(plusAction)
		alertController.addAction(minusAction)
		alertController.addAction(cancel)
		
		self.present(alertController, animated: true, completion: nil)
	}
	
	private func updateCounterValue(indexPath: IndexPath, state: CounterState) {
		try? realm.write {
			switch state {
				case .increase(let value):
					self.counters[indexPath.row].value += value
				case .decrease(let value):
					self.counters[indexPath.row].value -= value
			}
		}
		tableView.reloadData()
	}
}



