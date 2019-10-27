//
//  SetListMasterVC.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreData

protocol SetSelectionDelegate: class {
	func setSelected(_ selection: Set)
}

class SetListMasterVC: UITableViewController {

	// MARK: - IBOutlets
	
	
	// MARK: - Properties
	
	private weak var delegate: SetSelectionDelegate?
	private var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	}
	private lazy var fetchedResultsController: FetchedResultsController = {
		let fetchController = FetchedResultsController(tableView: self.tableView)
		return fetchController
	}()
	private var fetchedSetResults: NSFetchedResultsController<Set>?
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		fetchedSetResults = fetchedResultsController.fetchSetResults()
		prepareDelegate()
	}
	
	// MARK: - IBActions
	
	@IBAction func newSetButtonTapped(_ sender: Any) {
		let alert = UIAlertController(title: "New Set", message: nil, preferredStyle: .alert)
		alert.addTextField { (textField) in
			textField.autocapitalizationType = .words
			textField.placeholder = "Set Title:"
		}
		let okAction = UIAlertAction(title: "Save", style: .default) { (_) in
			if let setTitle = alert.textFields?.first?.text, !setTitle.isEmpty {
				SetController.shared.createSet(name: setTitle)
			}
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		[okAction, cancelAction].forEach({alert.addAction($0)})
		present(alert, animated: true, completion: nil)
	}
	
	// MARK: - Helpers
	
	private func prepareDelegate() {
		let splitViewController = self.splitViewController
		let detailsVC = (splitViewController?.viewControllers.last as? UINavigationController)?.topViewController as? SetListDetailsVC
		delegate = detailsVC
	}
	
	private func selectRow(at indexPath: IndexPath) {
		tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
		tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchedSetResults?.sections?[section].numberOfObjects ?? 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath)
		let set = fetchedSetResults?.object(at: indexPath)
		
		cell.textLabel?.text = set?.name ?? "Untitled"
		cell.detailTextLabel?.text = "\(set?.songs?.count ?? 0) songs"
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let set = fetchedSetResults?.object(at: indexPath) else { return }
		delegate?.setSelected(set)
		
		if let detailsVC = delegate as? SetListDetailsVC,
		  let detailsNavController = detailsVC.navigationController {
			splitViewController?.showDetailViewController(detailsNavController, sender: nil)
		}
	}
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
			guard let set = self.fetchedSetResults?.object(at: indexPath) else { return }
			SetController.shared.deleteSet(set: set)
			handler(true)
		}
		
		return UISwipeActionsConfiguration(actions: [delete])
	}
}
