//
//  Song+Convenience.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/21/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData


extension Song {
	@discardableResult convenience init(songTitle: String,
										artist: String,
										songID: UUID = UUID(),
										markPlayed: Bool,
										lyrics: Lyrics?,
										files: [SongFile]?,
										context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		self.songTitle = songTitle
		self.songID = songID
		self.markPlayed = markPlayed
		self.lyrics = lyrics
		if let files = files {
			self.songFiles = NSSet(array: files)
		}
	}
}
