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

class SongDetailViewController: UIViewController {

	@IBOutlet weak var filesCollectionView: UICollectionView!
	@IBOutlet weak var pdfContainerView: UIView!
	
	var delegate: SongDetailViewControllerDelegate?
	let pdfView = PDFView()
	var songFiles: [SongFile] = [] {
		didSet {

		}
	}

	var song: Song? {
		didSet {
			updateViews()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		filesCollectionView.delegate = self
		filesCollectionView.dataSource = self

    }

	private func updateViews() {
		loadViewIfNeeded()
		guard let song = song else { return }
		if let songTitle = song.songTitle {
			title = "Song Title: \(songTitle)"
		}
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


	private func loadPDFView() {
		pdfView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(pdfView)

		pdfView.leadingAnchor.constraint(equalTo: pdfContainerView.safeAreaLayoutGuide.leadingAnchor).isActive = true
		pdfView.trailingAnchor.constraint(equalTo: pdfContainerView.safeAreaLayoutGuide.trailingAnchor).isActive = true
		pdfView.topAnchor.constraint(equalTo: pdfContainerView.safeAreaLayoutGuide.topAnchor).isActive = true
		pdfView.bottomAnchor.constraint(equalTo: pdfContainerView.safeAreaLayoutGuide.bottomAnchor).isActive = true
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


extension SongDetailViewController: UIDocumentPickerDelegate {
	func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//		for url in urls {
//
//		}
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

		let songFile = songFiles[indexPath.row]
		cell.songFile = songFile

		return cell

	}
}

extension SongDetailViewController: SongSelectionDelegate {
    func setSelected(_ selection: Song) {
		song = selection
    }
}
