//
//  SearchMasterVC.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/21/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

protocol SearchMasterVCDelegate: class {
	func songSelected(_ newSong: Track)
}

class SearchMasterVC: UITableViewController {

	// MARK: - IBOutlets
	
	
	// MARK: - Properties
	
	private let searchClient = MusiXmatchClient()
	private var songs: [Track]? {
		didSet {
			tableView.reloadData()
		}
	}
	weak var delegate: SearchMasterVCDelegate?
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		prepareDelegate()
		getSongs()
	}
	
	// MARK: - IBActions
	
	
	// MARK: - Helpers
	
	private func prepareDelegate() {
		let splitViewController = self.splitViewController
		let detailsVC = (splitViewController?.viewControllers.last as? UINavigationController)?.topViewController as? SearchDetailVC
		delegate = detailsVC
	}
	
	private func getSongs() {
		searchClient.fetchSongsFromTopChart { (result) in
			DispatchQueue.main.async {
				switch result {
				case .success(let songs):
					self.songs = songs
				case .failure(let error):
					print("Error: \(error)")
				}
			}
		}
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		songs?.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)
		let track = songs?[indexPath.row]
		
		cell.textLabel?.text = track?.name
		cell.detailTextLabel?.text = track?.artistName
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let songs = songs else { return }
		delegate?.songSelected(songs[indexPath.row])
		
		if let detailVC = delegate as? SearchDetailVC,
			let detailNavController = detailVC.navigationController {	splitViewController?.showDetailViewController(detailNavController, sender: nil)
		}
	}
}
