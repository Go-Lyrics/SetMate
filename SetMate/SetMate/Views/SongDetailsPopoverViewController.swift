//
//  SongDetailsPopoverViewController.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/25/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class SongDetailsPopoverViewController: UIViewController {

	var song: Song? {
		didSet {
			updateViews()
		}
	}

	@IBOutlet weak var artistLabel: UILabel!
	@IBOutlet weak var songTitleLabel: UILabel!
	@IBOutlet weak var notesTextView: UITextView!
	@IBOutlet weak var filesCountLabel: UILabel!


	override func viewDidLoad() {
        super.viewDidLoad()
		updateViews()
    }
    
	private func updateViews() {
		loadViewIfNeeded()
		guard let song = song else { return }
		artistLabel.text = song.artist
		songTitleLabel.text = song.songTitle
		if let notes = song.notes {
			notesTextView.text = notes
		}
		filesCountLabel.text = "\(song.songFiles?.count ?? 0)"
	}
}
