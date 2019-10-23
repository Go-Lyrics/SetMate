//
//  FileController.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

protocol FileControllerDelegate: AnyObject {
	func createdURLLocation(_ fileController: FileController, filePath: String)
}

class FileController {

	let fm = FileManager.default

	weak var delegate: FileControllerDelegate?

	func saveFilesWith(url: URL, songTitle: String, songID: UUID) {
		let documentsDir = fm.urls(for: .documentDirectory, in: .userDomainMask).first!

		let filePath = songTitle + "/" + songID.uuidString + "/" + url.lastPathComponent

		let fileLocation = documentsDir.appendingPathComponent(filePath)

		do {
			let fileData = try Data(contentsOf: url)
			try fileData.write(to: fileLocation)
		} catch {
			NSLog("Error saving file to disk: \(error)")
		}

		delegate?.createdURLLocation(self, filePath: filePath)

		print(fileLocation)
	}
}
