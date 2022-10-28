//
//  DailySongCollection.swift
//  Songbird
//
//  Created by Scott King on 10/27/22.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class DailySongCollection: ObservableObject {
	private let path: String = "daily_songs"
	private let store = Firestore.firestore()

	@Published var daily_songs: [DailySong] = []
	private var cancellables: Set<AnyCancellable> = []

	init() {
		self.get()
	}

	func get() {
		store.collection(path).addSnapshotListener {
			querySnapshot, error in
				if let error = error {
					print("Error getting daily_songs: \(error.localizedDescription)")
					return
				}
			self.daily_songs = querySnapshot?.documents.compactMap {
				document in try? document.data(as: DailySong.self)
			} ?? []
		}
	}

	// MARK: CRUD methods
	func add(_ record: DailySong) {
		do {
			let newRecord = record
			_ = try store.collection(path).addDocument(from: newUser)
		} catch {
			fatalError("Unable to add daily song: \(error.localizedDescription).")
		}
	}

	func update(_ record: DailySong) {
		guard let recordId = record.id else { return }
		
		do {
			try store.collection(path).document(recordId).setData(from: record)
		} catch {
			fatalError("Unable to update record: \(error.localizedDescription).")
		}
	}

	func remove(_ record: DailySong) {
		guard let recordId = record.id else { return }
		
		store.collection(path).document(recordId).delete { error in
			if let error = error {
				print("Unable to remove record: \(error.localizedDescription)")
			}
		}
	}
}

