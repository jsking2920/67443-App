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
	var username: String
	var password: String
	
	// MARK: Codable
	enum CodingKeys: String, CodingKey {
		case id
		case username
		case password
	}
	
	// MARK: Comparable
	static func ==(lhs: User, rhs: User) -> Bool {
		return lhs.username == rhs.username
	}
	
	static func <(lhs: User, rhs: User) -> Bool {
		return lhs.username < rhs.username
	}
}
