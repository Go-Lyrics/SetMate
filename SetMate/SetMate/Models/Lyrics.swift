//
//  Lyrics.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/21/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation

struct Lyrics: Decodable {
	/*
	"lyrics_body": "Now and then I think of when we were together\r\n...",
	"lyrics_language": "en",
	"script_tracking_url": "http:\/\/tracking.musixmatch.com\/t1.0\/m42By\/J7rv9z",
	"pixel_tracking_url": "http:\/\/tracking.musixmatch.com\/t1.0\/m42By\/J7rv9z6q9he7AA",
	"lyrics_copyright": "Lyrics powered by www.musiXmatch.com",
	*/
	let body: String
	let language: String
	let copyright: String
}
