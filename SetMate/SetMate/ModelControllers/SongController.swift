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

	func createSong(songTitle: String, artist: String, markPlayed: Bool = false, lyrics: Lyrics?, files: [SongFile]?, songgID: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		Song(songTitle: songTitle, artist: artist, songID: songgID, markPlayed: markPlayed, lyrics: lyrics, files: files, context: context)

		saveToPersistentStore()
	}

	func updateSong(song: Song, songTitle: String, artist: String, markPlayed: Bool, lyrics: Lyrics?, files: [SongFile]?) {
		song.songTitle = songTitle
		song.artist = artist
		song.markPlayed = markPlayed
		song.lyrics = lyrics
		if let files = files {
			song.songFiles = NSSet(array: files)
		}

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