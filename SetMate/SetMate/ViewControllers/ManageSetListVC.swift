//
//  ManageSetListVC.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import CoreData

class ManageSetListVC: UIViewController {
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var libraryTableView: UITableView!
	@IBOutlet weak var draftTableView: UITableView!

	// MARK: - Properties
	
	private var songLibrary: [Song]? {
		didSet {
			self.songLibrary?.sort(by: { (song1, song2) -> Bool in
				guard let artist1 = song1.artist, let artist2 = song2.artist else { return false }
				return artist1 < artist2
			})
			libraryTableView.reloadData()
		}
	}
	private var draftSongs: [Song]? {
		didSet {
			if isViewLoaded {
				draftTableView.reloadData()
			}
		}
	}
	private lazy var fetchResultsController: NSFetchedResultsController<Song> = {
		let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
		
		if let songsIDs = self.draftSongs?.compactMap({$0.songID?.uuidString}), !songsIDs.isEmpty {
			fetchRequest.predicate = NSPredicate(format: "NOT(songID IN %@)", songsIDs)
		}
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "songTitle", ascending: false)]
		
		let fetchControl = NSFetchedResultsController(fetchRequest: fetchRequest,
													  managedObjectContext: CoreDataStack.shared.mainContext,
													  sectionNameKeyPath: "artist",
													  cacheName: nil)
		
		do {
			try fetchControl.performFetch()
		} catch {
			fatalError("Error performing fetch for fetchControl: \(error)")
		}
		
		return fetchControl
	}()
	var set: Set? {
		didSet {
			draftSongs = set?.songs?.array as? [Song]
		}
	}
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		isModalInPresentation = true
		libraryTableView.dataSource = self
		libraryTableView.delegate = self
		draftTableView.dataSource = self
		draftTableView.delegate = self
		
		songLibrary = fetchResultsController.fetchedObjects
	}
	
	// MARK: - IBActions
	
	@IBAction func cancelButtonTapped(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let orderSetListVC = segue.destination as? OrderSetListVC {
			orderSetListVC.set = set
			orderSetListVC.draftSongs = draftSongs
		}
	}
	
	// MARK: - Helpers
	
}

// MARK: - TableView DataSource & Delegate

extension ManageSetListVC: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == libraryTableView {
			return songLibrary?.count ?? 0
		} else if tableView == draftTableView {
			return draftSongs?.count ?? 0
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
		var song: Song? = nil
		
		if tableView == libraryTableView {
			song = songLibrary?[indexPath.row]
		} else if tableView == draftTableView {
			song = draftSongs?[indexPath.row]
		}
		
		cell.textLabel?.text = song?.songTitle
		cell.detailTextLabel?.text = song?.artist
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView == libraryTableView {
			guard let transferSong = songLibrary?[indexPath.row] else { return }
			
			songLibrary?.remove(at: indexPath.row)
			draftSongs?.append(transferSong)
		} else if tableView == draftTableView {
			guard let transferSong = draftSongs?[indexPath.row] else { return }
			
			draftSongs?.remove(at: indexPath.row)
			songLibrary?.append(transferSong)
		}
	}
}
