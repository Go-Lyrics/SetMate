//
//  NewSongViewController.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/23/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit
import MobileCoreServices

class NewSongViewController: UIViewController {

	@IBOutlet weak var songTitleTextField: UITextField!
	@IBOutlet weak var artistTextField: UITextField!
	@IBOutlet weak var notesTextView: UITextView!
	@IBOutlet weak var fileCountLabel: UILabel!

	var songController: SongController?
	let fileController = FileController()
	var songID: UUID = UUID()

	var savedFilePaths: [URL] = []

	var fileURLs: [URL] = [] {
		didSet {
			fileCountLabel.text = "\(fileURLs.count)"
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		notesTextView.layer.cornerRadius = 6
		notesTextView.layer.cornerCurve = .continuous
		notesTextView.layer.borderColor = UIColor.secondaryLabel.withAlphaComponent(0.3).cgColor
		notesTextView.layer.borderWidth = 0.5
		isModalInPresentation = true
		fileController.delegate = self
    }

	@IBAction func cancelTapped(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func saveTapped(_ sender: UIButton) {
		guard let songController = songController,
			let title = songTitleTextField.text,
			!title.isEmpty,
			let artist = artistTextField.text,
			!artist.isEmpty else { return }

		let notes = notesTextView.text

		let song = songController.createSong(songTitle: title, artist: artist, notes: notes, songID: songID, fileUrls: fileURLs)
		for url in fileURLs {
			fileController.saveFilesWith(song: song, url: url)
		}
		song.songFiles = NSOrderedSet(array: savedFilePaths)
		dismiss(animated: true, completion: nil)
	}


	@IBAction func documentPickerPresenter(_ sender: UIButton) {
		if songTitleTextField.text?.isEmpty ?? true {
			return
		}
		let pdfType = kUTTypePDF as String
		let jpegType = kUTTypeJPEG as String
		let pngType = kUTTypePNG as String
		let documentPicker = UIDocumentPickerViewController(documentTypes: [pdfType, jpegType, pngType], in: .import)
		documentPicker.delegate = self
		documentPicker.allowsMultipleSelection = true
		documentPicker.view.tintColor = .systemPink
		present(documentPicker, animated: true)
	}
}

extension NewSongViewController: UIDocumentPickerDelegate {

	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		self.fileURLs = urls
	}
}

extension NewSongViewController: FileControllerDelegate {
	func createdURLLocation(_ fileController: FileController, filePath: URL) {
		self.savedFilePaths.append(filePath)
	}
}
