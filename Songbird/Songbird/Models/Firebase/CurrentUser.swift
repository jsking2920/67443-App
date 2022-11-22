//
//  CurrentUser.swift
//  Songbird
//
//  Created by Scott King on 10/16/22.
//
// Manages user currently logged in
// User account is tied to a spotify account, logging into spotify is required to use app
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class CurrentUser: ObservableObject {

	private let path: String = "users" // path to collection in firestore database
	private let store = Firestore.firestore()

	@Published var user: User = User() // should always be a real user while in use, since user can only
	                                   // interact with app while logged into spotify

	private var cancellables: Set<AnyCancellable> = []
	
	init(spotify_id: String) {
		get(spotify_id: spotify_id, completion: { (user) in
			if (user != nil) {
				self.user = user!
			}
			else {
				self.createCurrentUser(spotify_id: spotify_id) // create user in firebase for this spotify account if one doesn't already exist
			}
		})
	}
	
	// Get a user from firebase with given spotify id
	func get(spotify_id: String, completion: @escaping (User?) -> Void) {

		let docRef = store.collection(path).document(spotify_id)
		
		docRef.getDocument(as: User.self) { result in
			switch result {
				case .success(let user):
					completion(user)
				case .failure(let error):
					print("Error getting current user: \(error.localizedDescription)")
					completion(nil)
			}
		}
	}

	// MARK: CRUD methods
	func createCurrentUser(spotify_id: String) {
		do {
			let newUser = User(id: spotify_id, daily_songs: Dictionary<String, DailySong>())
			self.user = newUser
			_ = try store.collection(path).addDocument(from: newUser)
		} catch {
			self.user = User()
			print("Unable to add user: \(error.localizedDescription).")
		}
	}

	// Call after updating user directly to push updates to db
	func updateCurrentUserInFirestore() {
		guard let userId = self.user.id else { return }
		
		do {
			try store.collection(path).document(userId).setData(from: user)
		} catch {
			fatalError("Unable to update current user: \(error.localizedDescription).")
		}
	}
	
	func removeCurrentUser() {
		guard let userId = self.user.id else { return }
		
		store.collection(path).document(userId).delete { error in
			if let error = error {
				print("Unable to remove user: \(error.localizedDescription)")
			}
			else {
				self.user = User()
			}
		}
	}
}
