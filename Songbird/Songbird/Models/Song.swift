//
//  Song.swift
//  Songbird
//
//  Created by Scott King on 10/16/22.
//

import Foundation

struct Song : Identifiable, Codable, Comparable {
	let id: String
	let name: String
	let popularity: Int
	let uri: String
	
	enum CodingKeys : String, CodingKey {
			case id
			case name
			case popularity
			case uri
	}
	
	static func < (lhs: Song, rhs: Song) -> Bool {
		return lhs.name < rhs.name
	}
}
