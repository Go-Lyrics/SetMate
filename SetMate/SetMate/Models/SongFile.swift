//
//  SongFile.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

extension SongFile {
	@discardableResult convenience init(song: Song, fileName: String, id: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		self.song = song
		self.fileName = fileName
		self.id = id
	}
}
