//
//  PerformDetailsVC.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/25/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import PDFKit

class PerformDetailsVC: CollapsableVC {

	// MARK: - IBOutlets
	
	@IBOutlet weak var filesCollectionView: UICollectionView!
	@IBOutlet weak var pdfContainerView: PDFView!
	
	// MARK: - Properties
	
	private let fileController = FileController()
	private var song: Song? {
		didSet {
			title = song?.songTitle
			
			guard let songFiles = song?.songFiles?.array as? [SongFile] else { return }
			self.songFiles = songFiles
			displayFirstPDF()
			filesCollectionView.reloadData()
		}
	}
	private var songFiles = [SongFile]()
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		filesCollectionView.dataSource = self
		
		updateViews()
	}
	
	// MARK: - IBActions
	
	
	// MARK: - Helpers
	

	private func updateViews() {
		pdfContainerView.backgroundColor = .systemBackground
		pdfContainerView.displayMode = .singlePageContinuous
	}

	private func displayFirstPDF() {
		guard let song = song,
			let filePath = fileController.filePaths(for: song).first else { return }
		if let document = PDFDocument(url: filePath) {
			pdfContainerView.document = document
		}
	}
}

extension PerformDetailsVC: SongSelectionDelegate {
	func songSelected(_ selection: Song) {
		song = selection
	}
}

// MARK: - CollectionView DataSource

extension PerformDetailsVC: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		songFiles.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCell", for: indexPath) as? SongFileCollectionViewCell else { return UICollectionViewCell() }

		cell.songFile = songFiles[indexPath.item]
		
		return cell
	}
}
