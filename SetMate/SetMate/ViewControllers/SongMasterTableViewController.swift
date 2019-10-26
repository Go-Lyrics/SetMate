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
    func songSelected(_ selection: Song)
}

class SongMasterTableViewController: UITableViewController {


	@IBOutlet weak var sortButton: UIBarButtonItem!


	let songController = SongController()
	private weak var delegate: SongSelectionDelegate?

	fileprivate var collapseDetailViewController = true

	lazy var fetchResultsController: NSFetchedResultsController<Song> = {
		let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
		let songTitleDescriptor = NSSortDescriptor(key: "songTitle", ascending: true)
		fetchRequest.sortDescriptors = [songTitleDescriptor]
		let moc = CoreDataStack.shared.mainContext
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "songTitle", cacheName: nil)
		frc.delegate = self
		do {
			try frc.performFetch()
		} catch {
			fatalError("Error performing fetch for frc: \(error)")
		}
		return frc
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.tableFooterView = UIView()
		prepareSongDelegate()
//		prepareFileDelegate()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController.sections?.count ?? 1
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let song = fetchResultsController.object(at: indexPath)
			songController.deleteSong(song: song)
        }
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
}

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
