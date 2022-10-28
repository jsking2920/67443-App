//
//  DailySongs.swift
//  Songbird
//
//  Created by Scott King on 10/27/22.
//

import Foundation
import FirebaseFirestoreSwift

struct DailySong: Identifiable, Comparable, Codable {
		
	// MARK: Fields
	@DocumentID var id: String?
	var spotify_id: String
	var title: String
	var artist: String
	
	// MARK: Codable
	enum CodingKeys: String, CodingKey {
		case id
		case spotify_id
		case title
		case artist
	}
	
	// MARK: Comparable
	static func ==(lhs: DailySong, rhs: DailySong) -> Bool {
		return lhs.spotify_id == rhs.spotify_id
	}
	
	static func <(lhs: DailySong, rhs: DailySong) -> Bool {
		return lhs.artist < rhs.artist
	}
}
