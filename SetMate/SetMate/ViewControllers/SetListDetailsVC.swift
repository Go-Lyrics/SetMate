//
//  SetListDetailsVC.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class SetListDetailsVC: UIViewController {
	
	// MARK: - IBOutlets
	
	
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
