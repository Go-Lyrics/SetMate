//
//  ResultsNest.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/22/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation

struct ResultsNest: Decodable {
	let trackList: [Track]?
	let lyrics: SongLyrics?
	
	enum CodingKeys: String, CodingKey {
		case message, body
		case trackList
		case lyrics
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let messageContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .message)
		let bodyContainer = try messageContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .body)
		
		trackList = try? bodyContainer.decode([Track].self, forKey: .trackList)
		lyrics = try? bodyContainer.decode(SongLyrics.self, forKey: .lyrics)
	}
}
