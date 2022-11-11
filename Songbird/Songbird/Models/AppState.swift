//
//  AppState.swift
//  Songbird
//
//  Created by Scott King on 11/11/22.
//

import Foundation
import SpotifyWebAPI

class AppState: ObservableObject {
	
	@Published var spotify: Spotify = Spotify()
	@Published var userCollection: UserCollection = UserCollection()
	@Published var selectedTab: Int = 0
}
