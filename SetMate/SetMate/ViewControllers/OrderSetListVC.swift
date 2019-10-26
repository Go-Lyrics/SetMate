//
//  OrderSetListVC.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class OrderSetListVC: UIViewController {

	// MARK: - IBOutlets
	
	@IBOutlet weak var draftTableView: UITableView!
	@IBOutlet weak var orderedTableView: UITableView!
	@IBOutlet weak var transferSongsButton: UIButton!
	
	// MARK: - Properties
	
	private enum transfer: String {
		case copy = "Copy"
		case removeAll = "Remove All"
	}
	
	private var orderedSongs: [Song]? {
		didSet {
			orderedTableView.reloadData()
		}
	}
	var set: Set?
	var draftSongs: [Song]? {
		didSet {
			if isViewLoaded {
				draftTableView.reloadData()
			}
		}
	}
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		orderedSongs = [Song]()
		
		setupTableViews()
		updateTransferButtonTitle()
	}
	
	// MARK: - IBActions
	
	@IBAction func transferSongsButtonTapped(_ sender: UIButton) {
		guard let title = sender.currentTitle else { return }

		switch transfer(rawValue: title) {
		case .copy:
			guard let songs = draftSongs else { return }
			orderedSongs?.append(contentsOf: songs)
			draftSongs?.removeAll()
			transferSongsButton.setTitle(transfer.removeAll.rawValue, for: .normal)
		case .removeAll:
			guard let songs = orderedSongs else { return }
			draftSongs?.append(contentsOf: songs)
			orderedSongs?.removeAll()
			transferSongsButton.setTitle(transfer.copy.rawValue, for: .normal)
		case .none:
			return
		}
	}
	
	@IBAction func saveButtonTapped(_ sender: Any) {
		guard let set = set else { return }
		dismiss(animated: true) {
			SetController.shared.updateSet(set: set, name: nil, songs: self.orderedSongs)
		}
	}
	
	// MARK: - Helpers
	
	private func setupTableViews() {
		draftTableView.dataSource = self
		draftTableView.delegate = self
		orderedTableView.dataSource = self
		orderedTableView.delegate = self
	}
	
	private func updateTransferButtonTitle() {
		guard let draftSongs = draftSongs else { return }
		let title = draftSongs.isEmpty ? transfer.removeAll.rawValue : transfer.copy.rawValue
		
		transferSongsButton.setTitle( title, for: .normal)
	}
}

// MARK: - TableView DataSource & Delegate

extension OrderSetListVC: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == orderedTableView {
			return orderedSongs?.count ?? 0
		} else if tableView == draftTableView {
			return draftSongs?.count ?? 0
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
		var song: Song? = nil
		
		if tableView == orderedTableView {
			song = orderedSongs?[indexPath.row]
		} else if tableView == draftTableView {
			song = draftSongs?[indexPath.row]
		}
		
		cell.textLabel?.text = song?.songTitle
		cell.detailTextLabel?.text = song?.artist
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if tableView == orderedTableView {
			guard let transferSong = orderedSongs?[indexPath.row] else { return }
			
			orderedSongs?.remove(at: indexPath.row)
			draftSongs?.append(transferSong)
		} else if tableView == draftTableView {
			guard let transferSong = draftSongs?[indexPath.row] else { return }
			
			draftSongs?.remove(at: indexPath.row)
			orderedSongs?.append(transferSong)
		}
		updateTransferButtonTitle()
	}
}
