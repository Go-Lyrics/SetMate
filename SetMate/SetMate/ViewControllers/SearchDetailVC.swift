//
//  SearchDetailVC.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/21/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class SearchDetailVC: UIViewController {

	// MARK: - IBOutlets
	
	@IBOutlet weak var lyricsTextView: UITextView!
	
	// MARK: - Properties
	
//	private var lyrics: SongLyrics?
//	var song: Track? {
//		didSet {
//			getLyrics()
//		}
//	}
	
	
	// MARK: - Life Cycle
	
	
	// MARK: - IBActions
	
	
	// MARK: - Helpers
	
	private func getLyrics() {
//		guard let song = song else { return }
	}
	
	private func updateViews() {
		loadViewIfNeeded()
//		lyricsTextView.text = lyrics?.body
	}
}

extension SearchDetailVC: SearchMasterVCDelegate {
	func songSelected() {
//		song = newSong
	}
}
