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
	
	// MARK: - Create

	func createSet(name: String) {
		Set(name: name)
		saveToPersistentStore()
	}
	
	// MARK: - Update

	func updateSet(set: Set, name: String, songs: [Song]?) {
		set.name = name
		set.lastModified = Date()
		if let songs = songs {
			set.songs = NSSet(array: songs)
		}
		saveToPersistentStore()
	}
	
	// MARK: - Delete

	func deleteSet(set: Set) {
		let moc = CoreDataStack.shared.mainContext
		moc.delete(set)
		saveToPersistentStore()
	}
	
	// MARK: - Helpers

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
