//
//  FetchedResultsController.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/26/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreData

enum SongSortingType: String {
	case artist
	case song = "songTitle"
}

class FetchedResultsController: NSObject {
	
	private var tableView: UITableView
	
	init(tableView: UITableView) {
		self.tableView = tableView
	}
	
	func fetchSetResults() -> NSFetchedResultsController<Set> {
		let fetchRequest: NSFetchRequest<Set> = Set.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastModified", ascending: false)]
		
		let moc = CoreDataStack.shared.mainContext
		#warning("Section frc by date, format date in objc")
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
		frc.delegate = self
		
		do {
			try frc.performFetch()
		} catch {
			fatalError("Error performing fetch for frc: \(error)")
		}
		
		return frc
	}
	
	func fetchSongResults(sortedBy sortingType: SongSortingType?, excluding songs: [Song]?) -> NSFetchedResultsController<Song> {
		let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
		var sectionName = ""
		let sortByArtist = NSSortDescriptor(key: SongSortingType.artist.rawValue, ascending: true)
		let sortBySong = NSSortDescriptor(key: SongSortingType.song.rawValue, ascending: true)
		
		switch sortingType {
		case .song:
			sectionName = "\(SongSortingType.song.rawValue).firstChar"
			fetchRequest.sortDescriptors = [sortBySong, sortByArtist]
		default:	//artist
			sectionName = SongSortingType.artist.rawValue
			fetchRequest.sortDescriptors = [sortByArtist, sortBySong]
		}
		
		if let songsIDs = songs?.compactMap({$0.songID?.uuidString}), !songsIDs.isEmpty {
			fetchRequest.predicate = NSPredicate(format: "NOT(songID IN %@)", songsIDs)
		}
		
		let moc = CoreDataStack.shared.mainContext
		let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: sectionName, cacheName: nil)
		frc.delegate = self
		
		do {
			try frc.performFetch()
		} catch {
			fatalError("Error performing fetch for frc: \(error)")
		}
		
		return frc
	}
}

// MARK: - NSFetch Results Controller Delegate

extension FetchedResultsController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
		case .update:
			guard let indexPath = indexPath else { return }
			tableView.reloadRows(at: [indexPath], with: .automatic)
		@unknown default:
			fatalError()
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
