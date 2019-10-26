//
//  SongMasterTableViewController.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreData

protocol SongSelectionDelegate: class {
	func songSelected(_ selection: Song?)
}

class SongMasterTableViewController: UITableViewController {


	@IBOutlet weak var sortButton: UIBarButtonItem!


	
	// MARK: - IBOutlets
	
	@IBOutlet weak var searchBar: UISearchBar!

	// MARK: - Properties
	
	let songController = SongController()
	private weak var delegate: SongSelectionDelegate?

	fileprivate var collapseDetailViewController = true

	lazy var fetchResultsController: NSFetchedResultsController<Song> = {
		let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
		
		fetchRequest.sortDescriptors = [
			NSSortDescriptor(key: "artist", ascending: true),
			NSSortDescriptor(key: "songTitle", ascending: true)
		]
		let moc = CoreDataStack.shared.mainContext
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "artist", cacheName: nil)
		
		frc.delegate = self
		do {
			try frc.performFetch()
		} catch {
			fatalError("Error performing fetch for frc: \(error)")
		}
		return frc
	}()
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchBar.delegate = self
		searchBar.enablesReturnKeyAutomatically = true
		
		tableView.tableFooterView = UIView()
		prepareSongDelegate()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

	// MARK: - Navigation

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "NewSongSegue" {
			guard let newSongVC = segue.destination as? NewSongViewController else { return }
			newSongVC.songController = songController
		}

		guard let detailVC = segue.destination as? SongDetailViewController else { return }
		guard let indexPath = tableView.indexPathForSelectedRow else { return }
		let song = fetchResultsController.object(at: indexPath)
		detailVC.song = song
	}
	
	// MARK: - IBActions
	
	
	// MARK: - Helpers
	
	private func prepareSongDelegate() {
		let splitViewController = self.splitViewController
		let detailsVC = (splitViewController?.viewControllers.last as? UINavigationController)?.topViewController as? SongDetailViewController
		detailsVC?.songController = songController
		delegate = detailsVC
	}
	
	@IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
		let alertControllerMessage = "Sort By:"
		let sortActionController = UIAlertController(title: alertControllerMessage, message: nil, preferredStyle: .actionSheet)
		sortActionController.popoverPresentationController?.barButtonItem = sender
		sortActionController.popoverPresentationController?.sourceRect = CGRect(x: -5, y: -5, width: sender.width, height: 0)
		let sortByArtistAction = UIAlertAction(title: "By artist", style: .default) { (_) in
			// Sort descriptor method here
		}

		let sortBySongTitleAction = UIAlertAction(title: "By song title", style: .default) { (_) in
			// Sort descriptor method here
		}

		[sortByArtistAction, sortBySongTitleAction].forEach { sortActionController.addAction($0) }
		present(sortActionController, animated: true, completion: nil)

	}

	func searchFetchedResults(for searchText: String?) {
		if let searchText = searchText {
			let predicate = NSPredicate(format: "(songTitle contains[cd] %@) || (artist contains[cd] %@)", searchText, searchText)
			fetchResultsController.fetchRequest.predicate = predicate

		} else {
			fetchResultsController.fetchRequest.predicate = nil
		}

		do {
			try fetchResultsController.performFetch()
			tableView.reloadData()
		} catch let err {
			print(err)
		}
	}


	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return fetchResultsController.sections?.count ?? 1
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		fetchResultsController.sections?[section].name
	}

	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		fetchResultsController.sectionIndexTitles
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fetchResultsController.sections?[section].numberOfObjects ?? 0
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
		let song = fetchResultsController.object(at: indexPath)

		cell.textLabel?.text = song.songTitle
		cell.detailTextLabel?.text = song.artist

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let song = fetchResultsController.object(at: indexPath)
		delegate?.songSelected(song)

		if let detailsVC = delegate as? SongDetailViewController,
			let detailsNavController = detailsVC.navigationController {
			splitViewController?.showDetailViewController(detailsNavController, sender: nil)
		}
	}

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let song = fetchResultsController.object(at: indexPath)
			delegate?.songSelected(nil)
			songController.deleteSong(song: song)
		}
	}
}

// MARK: - Fetched Results Controller Dalegate

extension SongMasterTableViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
		let sectionIndexSet = IndexSet(integer: sectionIndex)

		switch type {
		case .insert:
			tableView.insertSections(sectionIndexSet, with: .fade)
		case .delete:
			tableView.deleteSections(sectionIndexSet, with: .fade)
		default:
			break
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		switch type {
		case .delete:
			guard let indexPath = indexPath else { return }
			tableView.deleteRows(at: [indexPath], with: .fade)
		case .insert:
			guard let newIndexPath = newIndexPath else { return }
			tableView.insertRows(at: [newIndexPath], with: .fade)
		case .move:
			guard let indexPath = indexPath,
				let newIndexPath = newIndexPath else { return }
			tableView.moveRow(at: indexPath, to: newIndexPath)
		case .update:
			guard let indexPath = indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .fade)
		default:
			fatalError()
		}
	}
}

// MARK: - SearchBar Delegate

extension SongMasterTableViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchFetchedResults(for: searchBar.text?.optionalText)
	}
}
