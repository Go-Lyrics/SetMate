//
//  SongController.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

class SongController {

	let fileConroller = FileController()

	// MARK: - CRUD Functions

	@discardableResult func createSong(songTitle: String, artist: String, notes: String?, songID: UUID = UUID(), markPlayed: Bool = false, fileUrls: [URL]?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Song {
		let song = Song(songTitle: songTitle, artist: artist, notes: notes, markPlayed: markPlayed, songID: songID, context: context)
		guard let fileUrls = fileUrls else { return song }
		var array: [SongFile] = []
		for url in fileUrls {
			let songFile = SongFile(song: song, filePath: url)
			array.append(songFile)
		}
		song.songFiles = NSOrderedSet(array: array)

		saveToPersistentStore()
		return song
	}

	func updateSong(song: Song, songTitle: String, artist: String, notes: String, markPlayed: Bool, files: [SongFile]?) {
		song.songTitle = songTitle
		song.artist = artist
		song.notes = notes
		song.markPlayed = markPlayed
		if let files = files {
			song.songFiles = NSOrderedSet(array: files)
		}
		saveToPersistentStore()
	}

	func addSongFilesTo(song: Song, with filePath: URL) {
		SongFile(song: song, filePath: filePath)
		saveToPersistentStore()
	}

	func deleteSong(song: Song) {
		let moc = CoreDataStack.shared.mainContext
		fileConroller.deletFiles(with: song)
		moc.delete(song)
		saveToPersistentStore()
	}


	// MARK: - Persistent Store

	private func loadFromPersistentStore() -> [Song] {
		let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
		let moc = CoreDataStack.shared.mainContext

		do {
			let songs = try moc.fetch(fetchRequest)
			return songs
		} catch {
			NSLog("Error fetching sets: \(error)")
			return []
		}
	}

	private func saveToPersistentStore() {
		let moc = CoreDataStack.shared.mainContext

		do {
			try moc.save()
		} catch {
			NSLog("Error saving moc: \(error)")
			moc.reset()
		}
	}

}
