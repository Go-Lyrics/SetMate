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

	func saveFilesWith(url: URL, songTitle: String, songID: UUID) {
		let documentsDir = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
		let fileName = url.lastPathComponent
		let destinationFilePath = documentsDir
			.appendingPathComponent(songID.uuidString)
			.appendingPathComponent(songTitle)
			.appendingPathComponent(fileName)

		let destinationDirectory = destinationFilePath.deletingLastPathComponent()


//		let lastPath = url.lastPathComponent.replacingOccurrences(of: " ", with: "")
//
//		let filePath = songID.uuidString + songTitle.replacingOccurrences(of: " ", with: "") + "/" + lastPath
//
//		let fileLocation = documentsDir.appendingPathComponent(filePath)
//
//		let pathSongTitle = songTitle.replacingOccurrences(of: " ", with: "")
//
//		let directoryURL = documentsDir
//			.appendingPathComponent(songID.uuidString)
//			.appendingPathComponent(pathSongTitle)
//			.appendingPathComponent(lastPath)


		do {
			try fm.createDirectory(at: destinationDirectory, withIntermediateDirectories: true, attributes: nil)
			try fm.copyItem(at: url, to: destinationFilePath)
		} catch {
			NSLog("Error saving file to disk: \(error)")
		}

		delegate?.createdURLLocation(self, filePath: destinationFilePath)

		print(destinationDirectory)
	}
}
