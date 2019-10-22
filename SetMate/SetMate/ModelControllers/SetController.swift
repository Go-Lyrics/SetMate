//
//  SetController.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

class SetController {

	func createSet(name: String, performDate: Date? = Date(), id: UUID = UUID(), songs: [Song]?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		Set(name: name, performDate: performDate, id: id, songs: songs, context: context)
		saveToPersistentStore()
	}

	func updateSet(set: Set, name: String, songs: [Song]?, performDate: Date? = Date()) {
		set.name = name
		set.performDate = performDate
		if let songs = songs {
			set.songs = NSSet(array: songs)
		}
		saveToPersistentStore()
	}

	func deleteSet(set: Set) {
		let moc = CoreDataStack.shared.mainContext
		moc.delete(set)
		saveToPersistentStore()
	}


	private func loadFromPersistentStore() -> [Set] {
		let fetchRequest: NSFetchRequest<Set> = Set.fetchRequest()
		let moc = CoreDataStack.shared.mainContext

		do {
			let sets = try moc.fetch(fetchRequest)
			return sets
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
