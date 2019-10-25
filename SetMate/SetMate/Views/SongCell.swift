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
	
//	@IBOutlet weak private var titleLabel: UILabel!
//	@IBOutlet weak private var artistLabel: UILabel!
//	@IBOutlet weak private var filesCountLabel: UILabel!
	
	// MARK: - Properties
	
	private let titleLabel = UILabel()
	private let artistLabel = UILabel()
	private let filesCountLabel = UILabel()
	
	var song: Song? {
		didSet {
			updateViews()
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		artistLabel.textColor = .lightGray
		
		let titleArtistStack = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
		titleArtistStack.axis = .vertical
		titleArtistStack.distribution = .fillProportionally
		titleArtistStack.alignment = .fill
		
		let fullStack = UIStackView(arrangedSubviews: [titleArtistStack, filesCountLabel])
		fullStack.axis = .horizontal
		fullStack.alignment = .fill
		addSubview(fullStack)
		
		filesCountLabel.translatesAutoresizingMaskIntoConstraints = false
		fullStack.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			fullStack.topAnchor.constraint(equalTo: contentView.topAnchor),
			fullStack.leftAnchor.constraint(equalTo: contentView.leftAnchor),
			fullStack.rightAnchor.constraint(equalTo: contentView.rightAnchor),
			fullStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
		
		filesCountLabel.widthAnchor.constraint(equalTo: fullStack.widthAnchor, multiplier: 0.2).isActive = true
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
