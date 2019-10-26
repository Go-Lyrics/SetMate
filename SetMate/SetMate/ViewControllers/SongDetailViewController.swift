//
//  SongDetailViewController.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import MobileCoreServices
import PDFKit

protocol SongDetailViewControllerDelegate {

	func selectedSongFiles(_ viewController: SongDetailViewController, didSelect songFiles: [SongFile])
	func newSongCreated(_ viewController: SongDetailViewController, song: Song)

}

class SongDetailViewController: CollapsableVC {

	@IBOutlet weak var filesCollectionView: UICollectionView!
	@IBOutlet weak var pdfContainerView: PDFView!

	let fileController = FileController()
	var songController: SongController?

	var delegate: SongDetailViewControllerDelegate?
	let pdfView = PDFView()
	var filePaths: [URL]? {
		didSet {
			displayPDF(from: self.filePaths?.first)
		}
	}

	var song: Song? {
		didSet {
			updateViews()
			
			guard let song = self.song else { return }
			filePaths = fileController.filePaths(for: song)
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		
		filesCollectionView.dataSource = self
		filesCollectionView.delegate = self
		fileController.delegate = self
		
    }

	private func updateViews() {
		loadViewIfNeeded()
		pdfView.backgroundColor = .systemBackground
		pdfView.displayMode = .singlePageContinuous
		
		title = song?.songTitle
		filesCollectionView.reloadData()
	}

	@IBAction func fileButtonPresentDocumentPicker(_ sender: UIBarButtonItem) {
		let pdfType = kUTTypePDF as String
		let jpegType = kUTTypeJPEG as String
		let pngType = kUTTypePNG as String
		let documentPicker = UIDocumentPickerViewController(documentTypes: [pdfType, jpegType, pngType], in: .import)
		documentPicker.delegate = self
		documentPicker.allowsMultipleSelection = true
		documentPicker.view.tintColor = .systemPink
		present(documentPicker, animated: true)
	}

	private func displayPDF(from url: URL?) {
		if let filePath = url, let document = PDFDocument(url: filePath) {
			pdfContainerView.document = document
		}
	}
}


extension SongDetailViewController: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		guard let song = song else { return }
		for url in urls {
			self.fileController.saveFilesWith(song: song, url: url)
		}
	}
}

extension SongDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		filePaths?.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCell", for: indexPath) as? SongFileCollectionViewCell else { return UICollectionViewCell() }

		cell.songFile = song?.songFiles?.object(at: indexPath.item) as? SongFile
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		displayPDF(from: filePaths?[indexPath.item])
	}
}

extension SongDetailViewController: SongSelectionDelegate {
    func songSelected(_ selection: Song) {
		song = selection
    }
}

extension SongDetailViewController: FileControllerDelegate {
	func importedSongFile(_ fileController: FileController, filePath: URL, on song: Song) {
		songController?.addSongFilesTo(song: song, with: filePath.lastPathComponent)
		self.filesCollectionView.reloadData()
	}
}
