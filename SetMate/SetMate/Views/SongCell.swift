//
//  SongCell.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/24/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class SongCell: UITableViewCell {

	// MARK: - IBOutlets
	
	@IBOutlet weak private var titleLabel: UILabel!
	@IBOutlet weak private var artistLabel: UILabel!
	@IBOutlet weak private var filesCountLabel: UILabel!
	
	// MARK: - Properties

	var song: Song? {
		didSet {
			updateViews()
		}
	}

	
	// MARK: - IBActions
	
	
	// MARK: - Helpers
	
	private func updateViews() {
		guard let song = song else { return }
		
		titleLabel.text = song.songTitle
		artistLabel.text = song.artist
		filesCountLabel.text = "\(song.songFiles?.count ?? 0) Files"
	}
}
