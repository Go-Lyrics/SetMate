//
//  SongFileCollectionViewCell.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class SongFileCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var fileNameLabel: UILabel!


	var songFile: SongFile? {
		didSet {
			updateViews()
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		containerView.layer.cornerRadius = 10
		containerView.layer.cornerCurve = .continuous
		containerView.layer.borderWidth = 1.5
		containerView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
	}




	private func updateViews() {
		guard let file = songFile else { return }
		fileNameLabel.text = file.filePath?.lastPathComponent
	}

}
