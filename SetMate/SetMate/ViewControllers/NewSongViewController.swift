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

	var savedFilePaths: [String] = []

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
		songController.createSong(songTitle: title, artist: artist, notes: notes, songID: songID, files: nil)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewSongViewController: UIDocumentPickerDelegate {

	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
		self.fileURLs = urls
		guard let title = self.songTitleTextField.text else { return }
		for url in urls {
			fileController.saveFilesWith(url: url, songTitle: title, songID: self.songID)
		}
	}
}

extension NewSongViewController: FileControllerDelegate {
	func createdURLLocation(_ fileController: FileController, filePath: String) {
		self.savedFilePaths.append(filePath)
	}
}
