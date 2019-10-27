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
	
	private var draftSongs: [Song]? {
		didSet {
			if isViewLoaded {
				self.fetchedSongResults = fetchedResultsController.fetchSongResults(sortedBy: nil, excluding: self.draftSongs)
				draftTableView.reloadData()
				libraryTableView.reloadData()
			}
		}
	}
	private lazy var fetchedResultsController: FetchedResultsController = {
		let fetchController = FetchedResultsController(tableView: self.libraryTableView)
		return fetchController
	}()
	private var fetchedSongResults: NSFetchedResultsController<Song>?
	
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

		fetchedSongResults = fetchedResultsController.fetchSongResults(sortedBy: nil, excluding: self.draftSongs)
		draftTableView.reloadData()
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
	
	func numberOfSections(in tableView: UITableView) -> Int {
		if tableView == libraryTableView {
			return fetchedSongResults?.sections?.count ?? 0
		}
		return 1
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if tableView == libraryTableView {
			return fetchedSongResults?.sections?[section].name
		}
		return nil
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == libraryTableView {
			return fetchedSongResults?.sections?[section].numberOfObjects ?? 0
		} else if tableView == draftTableView {
			return draftSongs?.count ?? 0
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
		var song: Song? = nil
		
		if tableView == libraryTableView {
			song = fetchedSongResults?.object(at: indexPath)
		} else if tableView == draftTableView {
			song = draftSongs?[indexPath.row]
		}
		
		cell.textLabel?.text = song?.songTitle
		cell.detailTextLabel?.text = song?.artist
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView == libraryTableView {
			guard let transferSong = fetchedSongResults?.object(at: indexPath) else { return }
			
			draftSongs?.append(transferSong)
		}
		if tableView == draftTableView {
			draftSongs?.remove(at: indexPath.row)
		}
	}
}
