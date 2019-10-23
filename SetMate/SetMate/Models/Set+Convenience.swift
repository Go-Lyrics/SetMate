//
//  Set+Convenience.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/21/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

extension Set {
	@discardableResult convenience init(name: String, performDate: Date? = nil, id: UUID = UUID(), songs: [Song]? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		self.name = name
		self.performDate = performDate
		self.id = id
		if let songs = songs {
			self.songs = NSSet(array: songs)
		}
		self.lastModified = Date()
	}
}
