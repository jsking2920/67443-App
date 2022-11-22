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
	@Published var currentUser: CurrentUser? = nil
	@Published var selectedTab: Int = 0
	
	// Must be called after user has authorized with spotify, currentUser is set asynchronously so make sure to handle optional properly
	func setCurrentUser() {
	
		if (!self.spotify.isAuthorized) {
			print("User not authorized, refusing to retrieve current user")
			return
		}
		if (self.currentUser != nil) {
			print("User already retrieved, should you being trying to set it again?")
		}

		// Make sure current user has been set
		self.spotify.retrieveCurrentUserID() { (id) in
			if (id == nil) {
				print("Couldn't retrive current user from spotify")
			}
			else {
				self.currentUser = CurrentUser(spotify_id: id!) // will create a user in firebase if this is a new spotify account
			}
		}
	}
}
