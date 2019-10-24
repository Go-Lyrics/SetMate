//
//  FileController.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

protocol FileControllerDelegate: AnyObject {
	func createdURLLocation(_ fileController: FileController, filePath: URL)
}

class FileController {

	let fm = FileManager.default
	weak var delegate: FileControllerDelegate?

	
	func saveFilesWith(song: Song, url: URL) {
		let pathAndDirectoryInfo = createDestinationFilePath(with: song, sourceURL: url)
		guard let destinationDirectory = pathAndDirectoryInfo.directory,
			let destinationFilePath = pathAndDirectoryInfo.filePath else { return }
		do {
			try fm.createDirectory(at: destinationDirectory, withIntermediateDirectories: true, attributes: nil)
			try fm.copyItem(at: url, to: destinationFilePath)
		} catch {
			NSLog("Error saving file to disk: \(error)")
		}

		delegate?.createdURLLocation(self, filePath: destinationFilePath)
	}


	func deletFiles(with song: Song) {
		guard let fileDirectory = createDestinationFilePath(with: song, sourceURL: nil).directory else { return }

		do {
			try fm.removeItem(at: fileDirectory)
		} catch {
			NSLog("Error deleting file")
		}
	}


	private func createDestinationFilePath(with song: Song, sourceURL: URL?) -> (filePath: URL?, directory: URL?) {
		let documentsDir = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
		guard let title = song.songTitle,
		let id = song.songID else { return (nil, nil) }
		let destinationDirectory = documentsDir
		.appendingPathComponent(id.uuidString)
		.appendingPathComponent(title)

		if let sourceURL = sourceURL {
			let fileName = sourceURL.lastPathComponent
			let destinationFilePath = destinationDirectory.appendingPathComponent(fileName)
			return (destinationFilePath, destinationDirectory)
		}
		return (nil, destinationDirectory)
	}
}
