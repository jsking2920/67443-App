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
	var daily_songs: Dictionary<String, String>
	
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
