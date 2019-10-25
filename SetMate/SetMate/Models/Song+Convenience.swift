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
										notes: String?,
										markPlayed: Bool,
										songID: UUID = UUID(),
										context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		self.artist = artist
		self.notes = notes
		self.songTitle = songTitle
		self.songID = songID
		self.markPlayed = markPlayed
	}
}
