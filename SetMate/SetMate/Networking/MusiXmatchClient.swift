//
//  MusiXmatchClient.swift
//  SetMate
//
//  Created by Jeffrey Santana on 10/21/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation

enum NetworkError: Error {
	case badURL
	case noToken
	case noData
	case notDecoding
	case notEncoding
	case other(Error)
}

class MusiXmatchClient {
	
	let baseURL = URL(string: "https://api.musixmatch.com/ws/1.1")!
	
	func fetchSongsFromTopChart(completion: @escaping (Result<[Track]?, NetworkError>) -> Void) {
		let chartUrl = baseURL.appendingPathComponent("chart.tracks.get")
		var urlComponents = URLComponents(url: chartUrl, resolvingAgainstBaseURL: true)
		
		urlComponents?.queryItems = [
			URLQueryItem(name: "apikey", value: MusiXmatchApiKey.key),
			URLQueryItem(name: "chart_name", value: "top"),
			URLQueryItem(name: "country", value: "us"),
			URLQueryItem(name: "f_has_lyrics", value: "1"),
			URLQueryItem(name: "page_size", value: "100"),
			URLQueryItem(name: "page", value: "1")
			]
		
		guard let url = urlComponents?.url else { return }
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let error = error {
				if let response = response as? HTTPURLResponse, response.statusCode != 200 {
					NSLog("Error: status code is \(response.statusCode) instead of 200.")
				}
				NSLog("Error creating user: \(error)")
				completion(.failure(.other(error)))
				return
			}
			
			guard let data = data else {
				NSLog("No data was returned")
				completion(.failure(.noData))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				
				let results = try decoder.decode(ResultsNest.self, from: data)
				if let trackList = results.trackList {
					completion(.success(trackList))
				}
				
			} catch {
				completion(.failure(.notDecoding))
			}
		}.resume()
	}
	
	func fetchLyrics(for trackId: Int, completion: @escaping (Result<SongLyrics?, NetworkError>) -> Void) {
		let lyricUrl = baseURL.appendingPathComponent("track.lyrics.get")
		var urlComponents = URLComponents(url: lyricUrl, resolvingAgainstBaseURL: true)
		
		urlComponents?.queryItems = [
			URLQueryItem(name: "apikey", value: MusiXmatchApiKey.key),
			URLQueryItem(name: "track_id", value: "\(trackId)")
			]
		
		guard let url = urlComponents?.url else { return }
		
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let error = error {
				if let response = response as? HTTPURLResponse, response.statusCode != 200 {
					NSLog("Error: status code is \(response.statusCode) instead of 200.")
				}
				NSLog("Error creating user: \(error)")
				completion(.failure(.other(error)))
				return
			}
			
			guard let data = data else {
				NSLog("No data was returned")
				completion(.failure(.noData))
				return
			}
			
			do {
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				
				let results = try decoder.decode(ResultsNest.self, from: data)
				if let lyrics = results.lyrics {
					completion(.success(lyrics))
				}
				
			} catch {
				completion(.failure(.notDecoding))
			}
		}.resume()
	}
}
