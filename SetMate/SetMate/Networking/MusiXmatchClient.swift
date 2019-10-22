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

typealias resultHandler = (Result<Bool, NetworkError>) -> Void

class MusiXmatchClient {
	
	let baseURL = URL(string: "https://api.musixmatch.com/ws/1.1")!
	private(set) var results = [Track]()
	
	func fetchSongsFromTopChart(completion: @escaping resultHandler) {
		let chartUrl = baseURL.appendingPathComponent("chart.tracks.get")
		var urlComponents = URLComponents(url: chartUrl, resolvingAgainstBaseURL: true)
		
//		urlComponents?.path += "/chart.tracks.get"
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
				
				let chart = try decoder.decode(Chart.self, from: data)
				self.results = chart.trackList
				
				completion(.success(true))
			} catch {
				completion(.failure(.notDecoding))
			}
		}.resume()
	}
}
