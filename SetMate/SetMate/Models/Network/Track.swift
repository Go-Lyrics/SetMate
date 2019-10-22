//
//  Track.swift
//  Go-Lyrics
//
//  Created by Jeffrey Santana on 10/21/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

struct Track: Decodable {
	let id: Int
	let name: String
	let isExplicit: Bool
	let favoritedCount: Int
	let artistName: String
	let lyrics: SongLyrics?
	
	enum CodingKeys: String, CodingKey {
		case id = "trackId"
		case name = "trackName"
		case isExplicit = "explicit"
		case favoritedCount = "numFavourite"
		case artistName, lyrics
		
		case track
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let trackContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .track)
		let isExplicitValue = try trackContainer.decode(Int.self, forKey: .isExplicit)
		
		id = try trackContainer.decode(Int.self, forKey: .id)
		name = try trackContainer.decode(String.self, forKey: .name)
		isExplicit = Bool(truncating: isExplicitValue as NSNumber)
		favoritedCount = try trackContainer.decode(Int.self, forKey: .favoritedCount)
		artistName = try trackContainer.decode(String.self, forKey: .artistName)
		lyrics = nil
	}
}
