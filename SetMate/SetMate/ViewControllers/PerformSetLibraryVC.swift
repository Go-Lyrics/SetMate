//
//  PerformSetLibraryVC.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/25/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreData

class PerformSetLibraryVC: UITableViewController {

	// MARK: - IBOutlets
	
	
	// MARK: - Properties
	
	private weak var delegate: SetSelectionDelegate?
	private lazy var fetchedResultsController: FetchedResultsController = {
		let fetchController = FetchedResultsController(tableView: self.tableView)
		return fetchController
	}()
	private var fetchedSetResults: NSFetchedResultsController<Set>?
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		fetchedResultsController.fetchSetResults { (sets) in
			self.fetchedSetResults = sets
		}
		prepareDelegate()
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let performSetListVC = segue.destination as? PerformSetListVC, let indexPath = tableView.indexPathForSelectedRow {
			performSetListVC.set = fetchedSetResults?.object(at: indexPath)
		}
	}
	
	// MARK: - IBActions
	
	
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
}
