//
//  FileController.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

protocol FileControllerDelegate: AnyObject {
	func importedSongFile(_ fileController: FileController, filePath: URL, on song: Song)
}

class FileController {

	let fm = FileManager.default
	weak var delegate: FileControllerDelegate?


	func filePaths(for song: Song) -> [URL] {
		guard let songFiles = song.songFiles?.array as? [SongFile],
			let songDirectory = directoryFor(song: song) else { return [] }
		let fileNames = songFiles.compactMap { $0.fileName }

		return fileNames.map { songDirectory.appendingPathComponent($0) }
	}

	func directoryFor(song: Song) -> URL? {
		let documentsDir = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
		guard let id = song.songID?.uuidString,
			let title = song.songTitle else { return nil }
		let songDirectory = documentsDir.appendingPathComponent(id).appendingPathComponent(title)
		return songDirectory
	}
	
	func saveFilesWith(song: Song, url: URL) {
		guard let songDirectory = directoryFor(song: song) else { return }
		let fileName = url.lastPathComponent
		let destinationFilePath = songDirectory.appendingPathComponent(fileName)

		do {
			try fm.createDirectory(at: songDirectory, withIntermediateDirectories: true, attributes: nil)
			try fm.copyItem(at: url, to: destinationFilePath)
		} catch {
			NSLog("Error saving file to disk: \(error)")
		}
		print("File Path: \(destinationFilePath)")
		print("File Directory: \(songDirectory)")
		delegate?.importedSongFile(self, filePath: destinationFilePath, on: song)
	}


	func deleteFiles(with song: Song) {
		guard let fileDirectory = directoryFor(song: song) else { return }

		do {
			try fm.removeItem(at: fileDirectory)
		} catch {
			NSLog("Error deleting file")
		}
	}
}
