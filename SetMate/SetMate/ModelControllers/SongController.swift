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

	// MARK: - CRUD Functions

	func createSong(songTitle: String, artist: String, notes: String?, songID: UUID = UUID(), markPlayed: Bool = false, files: [SongFile]?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		Song(songTitle: songTitle, artist: artist, notes: notes, markPlayed: markPlayed, files: files, songID: songID, context: context)

		saveToPersistentStore()
	}

	func updateSong(song: Song, songTitle: String, artist: String, notes: String, markPlayed: Bool, files: [SongFile]?) {
		song.songTitle = songTitle
		song.artist = artist
		song.notes = notes
		song.markPlayed = markPlayed
		if let files = files {
			song.songFiles = NSSet(array: files)
		}

		saveToPersistentStore()
	}

	func addSongFilesTo(song: Song, with filePath: String) {
		SongFile(song: song, filePath: filePath)
		saveToPersistentStore()
	}

	func deleteSong(song: Song) {
		let moc = CoreDataStack.shared.mainContext
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
