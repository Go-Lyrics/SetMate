//
//  CoreDataStack.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/21/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

	private init() {}
	static let shared = CoreDataStack()

	lazy var container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "SetMate")
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error {
				fatalError("Failed to load persistent store(s): \(error)")
			}
			container.viewContext.automaticallyMergesChangesFromParent = true
		})
		return container
	}()

	var mainContext: NSManagedObjectContext {
		return container.viewContext
	}

	func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
		var saveError: Error?
		context.performAndWait {
			do {
				try context.save()
			} catch {
				saveError = error
				NSLog("Error when saving: \(error)")
			}
		}
		if let saveError = saveError {
			throw saveError
		}
	}
}
