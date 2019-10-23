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
										files: [SongFile]?,
										context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		self.songTitle = songTitle
		self.artist = artist
		self.songID = songID
		self.markPlayed = markPlayed
		if let files = files {
			self.songFiles = NSSet(array: files)
		}
	}
}
