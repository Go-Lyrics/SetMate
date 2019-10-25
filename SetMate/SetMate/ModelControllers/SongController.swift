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

	@discardableResult func createSong(songTitle: String, artist: String, notes: String?, songID: UUID = UUID(), markPlayed: Bool = false, fileNames: [String] = [], context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Song {
		let song = Song(songTitle: songTitle, artist: artist, notes: notes, markPlayed: markPlayed, songID: songID, context: context)
		var array: [SongFile] = []
		for name in fileNames {
			let songFile = SongFile(song: song, fileName: name)
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

	func addSongFilesTo(song: Song, with fileName: String) {
		SongFile(song: song, fileName: fileName)
		saveToPersistentStore()
	}

	func deleteSong(song: Song) {
		let moc = CoreDataStack.shared.mainContext
		fileConroller.deleteFiles(with: song)
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
