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
	var songFiles: [SongFile]? {
		didSet {

		}
	}

	var song: Song? {
		didSet {
			updateViews()
			filesCollectionView.reloadData()
			displayFirstPDF()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		filesCollectionView.delegate = self
		filesCollectionView.dataSource = self
		fileController.delegate = self
		print("Fartsie")

    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	private func updateViews() {
		loadViewIfNeeded()
		pdfView.backgroundColor = .systemBackground
		pdfView.displayMode = .singlePageContinuous
		guard let song = song else { return }
		if let songTitle = song.songTitle {
			title = songTitle
		}
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

	private func displayFirstPDF() {
		guard let song = song else { return }
		guard let filePath = fileController.filePaths(for: song).first else { return }
		if let document = PDFDocument(url: filePath) {
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
		guard let song = self.song else { return 0 }
		if let files = song.songFiles {
			return files.count
		}
		return 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCell", for: indexPath) as? SongFileCollectionViewCell else { return UICollectionViewCell() }

		DispatchQueue.main.async {
			if let songFiles = self.song?.songFiles {
				cell.songFile = songFiles.object(at: indexPath.item) as? SongFile
			}
		}
		
		return cell
	}
}

extension SongDetailViewController: SongSelectionDelegate {
    func setSelected(_ selection: Song) {
		song = selection
    }
}

extension SongDetailViewController: FileControllerDelegate {
	func importedSongFile(_ fileController: FileController, filePath: URL, on song: Song) {
		songController?.addSongFilesTo(song: song, with: filePath.lastPathComponent)
		self.filesCollectionView.reloadData()
	}
}
