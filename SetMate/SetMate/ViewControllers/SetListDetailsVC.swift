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
	
	// MARK: - Properties
	
	private var set: Set? {
		didSet {
			
		}
	}
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	// MARK: - IBActions
	
	@IBAction func addSongButtonTapped(_ sender: Any) {
		
	}
	
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
		guard let song = set?.songs?.value(forKey: "") as? Song else { return cell}
		
		cell.textLabel?.text = song.songTitle
		cell.detailTextLabel?.text = song.artist
		
		return cell
	}
	
	
}
