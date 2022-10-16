//
//  SpotifyParser.swift
//  Songbird
//
//  Created by Scott King on 10/16/22.
//

import Foundation
import Alamofire

class SpotifyParser {

	let urlString = "https://api.spotify.com/v1/tracks/6u819n2Bmz2fx4XPXh5aLJ?"

	func fetchSong(completionHandler: @escaping (Song) -> Void) {
		AF.request(self.urlString).responseDecodable(of: Song.self) { (response) in
			guard let song: Song = response.value else { return }
			completionHandler(song)
		}
	}

}
