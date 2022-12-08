//
//  UserCollection.swift
//  Songbird
//
//  Created by Scott King on 10/16/22.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserCollection: ObservableObject {

	private let path: String = "users"
	private let store = Firestore.firestore()

	@Published var users: [User] = []

	private var cancellables: Set<AnyCancellable> = []

	init() {
		self.get()
	}

	func get() {
		store.collection(path).addSnapshotListener {
			querySnapshot, error in
				if let error = error {
					print("Error getting users: \(error.localizedDescription)")
					return
				}
			self.users = querySnapshot?.documents.compactMap {
				document in try? document.data(as: User.self)
			} ?? []
		}
	}

	// MARK: CRUD methods
	func add(_ user: User) async {
		 do {
			let newUser = user
			_ = try  store.collection(path).addDocument(from: newUser)
		} catch {
			fatalError("Unable to add user: \(error.localizedDescription).")
		}
	}

	func update(_ user: User) {
		guard let userId = user.id else { return }
		
		do {
			try store.collection(path).document(userId).setData(from: user)
		} catch {
			fatalError("Unable to update user: \(error.localizedDescription).")
		}
	}

	func remove(_ user: User) {
		guard let userId = user.id else { return }
		
		store.collection(path).document(userId).delete { error in
			if let error = error {
				print("Unable to remove user: \(error.localizedDescription)")
			}
		}
	}
}
