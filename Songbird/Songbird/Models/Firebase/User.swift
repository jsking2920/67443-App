//
//  User.swift
//  Songbird
//
//  Created by Scott King on 10/16/22.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Comparable, Codable {
		
	// MARK: Fields
	@DocumentID var id: String?
	var email: String
	var daily_songs: Dictionary<String, DailySong> // keys are dates in mm-dd-yyyy format
	
	// MARK: Codable
	enum CodingKeys: String, CodingKey {
		case id
		case email
		case daily_songs
	}
	
	// MARK: Comparable
	static func ==(lhs: User, rhs: User) -> Bool {
		return lhs.email == rhs.email
	}
	
	static func <(lhs: User, rhs: User) -> Bool {
		return lhs.email < rhs.email
	}
}

struct DailySong: Codable, Comparable {
	
	// MARK: Fields
	var spotify_id: String
	var artist: String
	var title: String
	
	// MARK: Codable
	enum CodingKeys: String, CodingKey {
		case spotify_id
		case artist
		case title
	}
	
	// MARK: Comparable
	static func ==(lhs: DailySong, rhs: DailySong) -> Bool {
		return lhs.spotify_id == rhs.spotify_id
	}
	
	static func <(lhs: DailySong, rhs: DailySong) -> Bool {
		if (lhs.artist == rhs.artist) { return lhs.title < rhs.title }
		return lhs.artist < rhs.artist
	}
}
