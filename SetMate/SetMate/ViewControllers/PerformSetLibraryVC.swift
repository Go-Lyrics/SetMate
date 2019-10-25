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
	private var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		return formatter
	}
	
	private lazy var fetchResultsController: NSFetchedResultsController<Set> = {
		let fetchRequest: NSFetchRequest<Set> = Set.fetchRequest()
		
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastModified", ascending: false)]
		
		let fetchControl = NSFetchedResultsController(fetchRequest: fetchRequest,
													  managedObjectContext: CoreDataStack.shared.mainContext,
													  sectionNameKeyPath: nil,
													  cacheName: nil)
		
		fetchControl.delegate = self
		
		do {
			try fetchControl.performFetch()
		} catch {
			fatalError("Error performing fetch for fetchControl: \(error)")
		}
		
		return fetchControl
	}()
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		prepareDelegate()
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let performSetListVC = segue.destination as? PerformSetListVC, let indexPath = tableView.indexPathForSelectedRow {
			performSetListVC.set = fetchResultsController.object(at: indexPath)
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
		return fetchResultsController.sections?[section].numberOfObjects ?? 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath)
		let set = fetchResultsController.object(at: indexPath)
		
		cell.textLabel?.text = set.name ?? "Untitled"
		cell.detailTextLabel?.text = "\(set.songs?.count ?? 0) songs"
		
		return cell
	}
}

// MARK: - NSFetched Results Delegate

extension PerformSetLibraryVC: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		if isViewLoaded {
			switch type {
			case .insert:
				guard let newIndexPath = newIndexPath else { return }
				tableView.insertRows(at: [newIndexPath], with: .automatic)
			case .delete:
				guard let indexPath = indexPath else { return }
				tableView.deleteRows(at: [indexPath], with: .automatic)
			case .move:
				guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
				tableView.deleteRows(at: [oldIndexPath], with: .automatic)
				tableView.insertRows(at: [newIndexPath], with: .automatic)
				selectRow(at: newIndexPath)
			case .update:
				guard let indexPath = indexPath else { return }
				tableView.reloadRows(at: [indexPath], with: .automatic)
				selectRow(at: indexPath)
			@unknown default:
				fatalError()
			}
		}
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		let sectionIndexSet = IndexSet(integer: sectionIndex)
		switch type {
		case .insert:
			tableView.insertSections(sectionIndexSet, with: .automatic)
		case .delete:
			tableView.deleteSections(sectionIndexSet, with: .automatic)
		default:
			break
		}
	}
}

