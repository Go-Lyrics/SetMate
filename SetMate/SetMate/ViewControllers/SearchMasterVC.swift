//
//  SearchMasterVC.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/21/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class SearchMasterVC: UITableViewController {

	// MARK: - IBOutlets
	
	
	// MARK: - Properties
	
	let searchClient = MusiXmatchClient()
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchClient.fetchSongsFromTopChart { (result) in
			DispatchQueue.main.async {
				switch result {
				case .success(true):
					self.tableView.reloadData()
					break
				case .success(false):
					break
				case .failure(let error):
					print("Error: \(error)")
				}
			}
		}
	}
	
	// MARK: - IBActions
	
	
	// MARK: - Helpers
	
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		searchClient.results.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath)
		let track = searchClient.results[indexPath.row]
		
		cell.textLabel?.text = track.name
		cell.detailTextLabel?.text = track.artistName
		
		return cell
	}
}
