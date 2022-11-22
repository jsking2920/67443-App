//
//  User.swift
//  Songbird
//
//  Created by Scott King on 10/16/22.
//
// Every Songbird user is tied directly to a spotify account and stores records for daily songs
// See: https://developer.spotify.com/documentation/web-api/#spotify-uris-and-ids
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Comparable, Codable {
		
	// MARK: Fields
	@DocumentID var id: String? = nil // id == spotify_id == spotify username (cloud3141 for example)
	                                  // uri for getting this looks like spotify:user:cloud3141
	// TODO: consider caching email, display name, profile pic, user app preferences, etc.
	var daily_songs: Dictionary<String, DailySong> = Dictionary<String, DailySong>() // keys are dates in mm-dd-yyyy format
	
	// MARK: Codable
	enum CodingKeys: String, CodingKey {
		case id
		case daily_songs
	}
	
	// MARK: Comparable
	static func ==(lhs: User, rhs: User) -> Bool {
		return lhs.id == rhs.id
	}
	
	static func <(lhs: User, rhs: User) -> Bool {
		return lhs.id! < rhs.id!
	}
}

struct DailySong: Codable, Comparable {
	
	// MARK: Fields
	var spotify_id: String // id of song, in url of song link after track/ and before the ?
	                       // uri will look like spotify:track:#####################
	// cached for convenience, consider doing same with album art
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
