//
//  PerformSetListVC.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/25/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class PerformSetListVC: UITableViewController {

	// MARK: - IBOutlets
	
	
	// MARK: - Properties
	
	private weak var delegate: SongSelectionDelegate?
	var set: Set?
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		prepareDelegate()
		
		title = set?.name
		tableView.reloadData()
	}
	
	// MARK: - IBActions
	
	
	// MARK: - Helpers
	
	private func prepareDelegate() {
		let splitViewController = self.splitViewController
		let detailsVC = (splitViewController?.viewControllers.last as? UINavigationController)?.topViewController as? PerformDetailsVC
		delegate = detailsVC
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		set?.songs?.count ?? 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as? SongCell else { return UITableViewCell() }
		let song = set?.songs?[indexPath.row] as? Song
		
		cell.song = song
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let song = set?.songs?[indexPath.row] as? Song else { return }
		delegate?.songSelected(song)
		
		if let detailsVC = delegate as? PerformDetailsVC,
		  let detailsNavController = detailsVC.navigationController {
			splitViewController?.showDetailViewController(detailsNavController, sender: nil)
		}
	}
}
