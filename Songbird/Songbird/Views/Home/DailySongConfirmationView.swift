//
//  DailySongConfirmationView.swift
//  Songbird
//
//  Created by Scott King on 11/8/22.
//

import SwiftUI
import Combine
import SwiftDate
import SpotifyWebAPI

struct DailySongConfirmationView: View {
	
	@EnvironmentObject var appState: AppState
	var track: Track
	
	/// song's album art
	@State private var image = Image(systemName: "doc")
	@State private var didRequestImage = false
	
	@State private var alert: AlertItem? = nil
	
	// MARK: Cancellables
	@State private var loadImageCancellable: AnyCancellable? = nil
	
	var body: some View {
		VStack{
			Text("Is this today's vibe?").font(.headline).fontWeight(.heavy).padding()
			image
				.resizable()
				.scaledToFit()
				.frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.width * 0.75)
				.padding()
			Text(track.name).font(.headline)
			Text(track.artists?.first?.name ?? "").font(.body)
			
			NavigationLink(destination: DailySongView(song: getDailySong()).environmentObject(appState)) {
				Button(action: confirmDailySong, label: {
					Text("Confirm")
										 .foregroundColor(.white)
										 .padding(10)
										 .background(Color(red: 0.392, green: 0.720, blue: 0.197))
										 .cornerRadius(10)
										 .shadow(radius: 3)
				})
			}
		}
		.onAppear(perform: loadImage)
		.alert(item: $alert) { alert in
				Alert(title: alert.title, message: alert.message)
		}
	}
	
	/// Loads the image for the song
	func loadImage() {
		// Return early if the image has already been requested. We can't just
		// check if `self.image == nil` because the image might have already
		// been requested, but not loaded yet.
		if self.didRequestImage {
			//print("already requested image")
			return
		}
		self.didRequestImage = true
		
		guard let spotifyImage = track.album?.images?.largest else {
			//print("no image found for track")
			return
		}

		// print("loading image")
		
		// Note that a `Set<AnyCancellable>` is NOT being used so that each time
		// a request to load the image is made, the previous cancellable
		// assigned to `loadImageCancellable` is deallocated, which cancels the
		// publisher.
		self.loadImageCancellable = spotifyImage.load()
			.receive(on: RunLoop.main)
			.sink(
				receiveCompletion: { _ in },
				receiveValue: { image in
					//print("received image")
					self.image = image
				}
			)
	}
	
	func confirmDailySong() {
		let song = getDailySong()
		appState.currentUser?.user.daily_songs["\(Date().month)-\(Date().day)-\(Date().year)"] = song
		appState.currentUser?.updateCurrentUserInFirestore()
		appState.selectedTab = 0 // force refresh of view
	}
	
	func getDailySong() -> DailySong {
		return DailySong(spotify_id: track.id!, artist: track.artists?.first?.name ?? "N/A", title: track.name)
	}
}
