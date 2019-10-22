//
//  SongLyrics.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/21/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation

struct SongLyrics: Decodable {
	let id: Int
	let body: String
	let copyright: String
	
	enum CodingKeys: String, CodingKey {
		case id = "lyricsId"
		case body = "lyricsBody"
		case copyright = "lyricsCopyright"
	}
}
