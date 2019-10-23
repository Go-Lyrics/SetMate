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
	
	private var orderedSongs: [Song]?
	var set: Set?
	var draftSongs: [Song]? {
		didSet {
			if isViewLoaded {
				draftTableView.reloadData()
			}
		}
	}
	
	// MARK: - Life Cycle
	
	
	// MARK: - IBActions
	
	@IBAction func transferSongsButtonTapped(_ sender: UIButton) {
		guard let title = sender.currentTitle else { return }
		
		switch transfer(rawValue: title) {
		case .copy:
			orderedSongs = draftSongs
			transferSongsButton.setTitle(transfer.removeAll.rawValue, for: .normal)
		case .removeAll:
			orderedSongs = nil
			transferSongsButton.setTitle(transfer.copy.rawValue, for: .normal)
		case .none:
			return
		}
		
		orderedTableView.reloadData()
	}
	
	@IBAction func saveButtonTapped(_ sender: Any) {
		guard let set = set else { return }
		SetController.shared.updateSet(set: set, name: nil, songs: orderedSongs)
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Helpers
	
	
}
