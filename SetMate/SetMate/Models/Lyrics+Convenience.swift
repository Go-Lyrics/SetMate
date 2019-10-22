//
//  Lyrics+Convenience.swift
//  SetMate
//
//  Created by Marlon Raskin on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

extension Lyrics {
	@discardableResult convenience init(lyricsBody: String, lyricsID: Int64, language: String, copyright: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		self.lyricsBody = lyricsBody
		self.lyricsID = lyricsID
		self.language = language
		self.copyright = copyright
	}
}
