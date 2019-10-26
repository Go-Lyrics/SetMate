//
//  PerformDetailsVC.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/25/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import PDFKit

class PerformDetailsVC: UIViewController {

	// MARK: - IBOutlets
	
	@IBOutlet weak var filesCollectionView: UICollectionView!
	@IBOutlet weak var pdfContainerView: PDFView!
	
	// MARK: - Properties
	
	private let fileController = FileController()
	var filePaths: [URL]? {
		didSet {
			displayPDF(from: self.filePaths?.first)
		}
	}
	private var song: Song? {
		didSet {
			updateViews()
			
			guard let song = self.song else { return }
			filePaths = fileController.filePaths(for: song)
		}
	}
	private var songFiles = [SongFile]()
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		filesCollectionView.dataSource = self
		filesCollectionView.delegate = self
		
		navigationController?.hidesBarsOnTap = true
		tabBarController?.hidesBottomBarWhenPushed = true
		
		updateViews()
	}
	
	// MARK: - IBActions
	
	
	// MARK: - Helpers
	

	private func updateViews() {
		pdfContainerView.backgroundColor = .systemBackground
		pdfContainerView.displayMode = .singlePageContinuous
		
		title = song?.songTitle
		filesCollectionView.reloadData()
	}

	private func displayPDF(from url: URL?) {
		if let filePath = url, let document = PDFDocument(url: filePath) {
			pdfContainerView.document = document
		}
	}
}

// MARK: - Song Selection Delegate

extension PerformDetailsVC: SongSelectionDelegate {
	func songSelected(_ selection: Song) {
		song = selection
	}
}

// MARK: - CollectionView DataSource & Delegate

extension PerformDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		songFiles.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCell", for: indexPath) as? SongFileCollectionViewCell else { return UICollectionViewCell() }

		cell.songFile = songFiles[indexPath.item]
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		displayPDF(from: filePaths?[indexPath.item])
	}
}
