//
//  SetListDetailsVC.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class SetListDetailsVC: CollapsableVC {
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var manageSetListButton: UIBarButtonItem!
	
	// MARK: - Properties
	
	private var set: Set? {
		didSet {
			if isViewLoaded {
				title = set?.name
				manageSetListButton.isEnabled = true
				tableView.reloadData()
			}
		}
	}
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		manageSetListButton.isEnabled = false
		tableView.dataSource = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		tableView.reloadData()
	}
	
	// MARK: - Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let navController = segue.destination as? UINavigationController, let manageSetListVC = navController.topViewController as? ManageSetListVC {
			manageSetListVC.set = set
		}
	}
	
	// MARK: - IBActions
	
	
	// MARK: - Helpers
	
	
}

extension SetListDetailsVC: SetSelectionDelegate {
	func setSelected(_ selection: Set) {
		set = selection
	}
}

extension SetListDetailsVC: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		set?.songs?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        guard let song = set?.songs?[indexPath.row] as? Song else { return cell}

        cell.textLabel?.text = song.songTitle
        cell.detailTextLabel?.text = song.artist
		
		return cell
	}
	
	
}
