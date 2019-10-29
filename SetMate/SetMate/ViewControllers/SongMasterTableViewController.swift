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

	// MARK: - IBOutlets
	
	@IBOutlet weak var sortButton: UIBarButtonItem!
	@IBOutlet weak var searchBar: UISearchBar!
	
	// MARK: - Properties
	
	let songController = SongController()
	private weak var delegate: SongSelectionDelegate?
	private lazy var fetchedResultsController: FetchedResultsController = {
		let fetchController = FetchedResultsController(tableView: self.tableView)
		return fetchController
	}()
	private var fetchedSongResults: NSFetchedResultsController<Song>?
	private var sortingType: SongSortingType? {
		didSet {
			fetchedSongResults = fetchedResultsController.fetchSongResults(sortedBy: self.sortingType, excluding: nil)
			tableView.reloadData()
		}
	}
	
	// MARK: - Life Cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		searchBar.delegate = self
		searchBar.enablesReturnKeyAutomatically = true
		fetchedSongResults = fetchedResultsController.fetchSongResults(sortedBy: nil, excluding: nil)
		
		tableView.tableFooterView = UIView()
		prepareSongDelegate()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.tableView.selectRow(at: tableView.indexPathForSelectedRow)
	}

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "NewSongSegue" {
			guard let newSongVC = segue.destination as? NewSongViewController else { return }
			newSongVC.songController = songController
		}

		guard let detailVC = segue.destination as? SongDetailViewController else { return }
		guard let indexPath = tableView.indexPathForSelectedRow else { return }
		let song = fetchedSongResults?.object(at: indexPath)
		detailVC.song = song
    }
	
	// MARK: - IBActions
	
	@IBAction func sortButtonTapped(_ sender: UIBarButtonItem) {
		let alertControllerMessage = "Sort By:"
		let sortActionController = UIAlertController(title: alertControllerMessage, message: nil, preferredStyle: .actionSheet)
		sortActionController.popoverPresentationController?.barButtonItem = sender
		sortActionController.popoverPresentationController?.sourceRect = CGRect(x: -5, y: -5, width: sender.width, height: 0)
		let sortByArtistAction = UIAlertAction(title: "By artist", style: .default) { (_) in
			self.sortingType = .artist
		}
		
		let sortBySongTitleAction = UIAlertAction(title: "By song title", style: .default) { (_) in
			self.sortingType = .song
		}
		
		[sortByArtistAction, sortBySongTitleAction].forEach { sortActionController.addAction($0) }
		present(sortActionController, animated: true, completion: nil)
	}
	
	// MARK: - Helpers
	
	private func prepareSongDelegate() {
        let splitViewController = self.splitViewController
        let detailsVC = (splitViewController?.viewControllers.last as? UINavigationController)?.topViewController as? SongDetailViewController
		detailsVC?.songController = songController
        delegate = detailsVC
    }
	
	func searchFetchedResults(for searchText: String?) {
		if let searchText = searchText {
			let predicate = NSPredicate(format: "(songTitle contains[cd] %@) || (artist contains[cd] %@)", searchText, searchText)
			fetchedSongResults?.fetchRequest.predicate = predicate
			
		} else {
			fetchedSongResults?.fetchRequest.predicate = nil
		}
		
		do {
			try fetchedSongResults?.performFetch()
			tableView.reloadData()
		} catch let err {
			print(err)
		}
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedSongResults?.sections?.count ?? 1
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		fetchedSongResults?.sections?[section].name
	}
	
	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		fetchedSongResults?.sectionIndexTitles
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedSongResults?.sections?[section].numberOfObjects ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
		let song = fetchedSongResults?.object(at: indexPath)
		
		cell.textLabel?.text = song?.songTitle
		cell.detailTextLabel?.text = song?.artist

        return cell
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let song = fetchedSongResults?.object(at: indexPath) else { return }
        delegate?.songSelected(song)

        if let detailsVC = delegate as? SongDetailViewController,
          let detailsNavController = detailsVC.navigationController {
            splitViewController?.showDetailViewController(detailsNavController, sender: nil)
        }
	}

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			guard let song = fetchedSongResults?.object(at: indexPath) else { return }
			songController.deleteSong(song: song)
        }
    }
}

// MARK: - SearchBar Delegate

extension SongMasterTableViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchFetchedResults(for: searchBar.text?.optionalText)
	}
}
