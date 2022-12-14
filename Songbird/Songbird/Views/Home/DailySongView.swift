//
//  DailySongView.swift
//  Songbird
//
//  Created by Scott King on 11/7/22.
//

import SwiftUI
import Combine
import SpotifyWebAPI

struct DailySongView: View {
	
	@EnvironmentObject var appState: AppState
	var song: DailySong
	
	/// song's album art and Track object
	@State private var track = Track.faces // gven example track used as a placeholder
	@State private var image = Image(systemName: "doc")
	@State private var didRequestImage = false
	
	@State private var alert: AlertItem? = nil
	
	// MARK: Cancellables
	@State private var getTrackCancellable: AnyCancellable? = nil
	@State private var loadImageCancellable: AnyCancellable? = nil
	
	var body: some View {
		VStack{
			Text("Today's Pick").font(.headline).fontWeight(.heavy).padding()
			image
				.resizable()
				.scaledToFit()
				.frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.width * 0.75)
				.padding()
			Text(song.title).font(.headline)
			Text(song.artist).font(.body)
			
			NavigationLink( destination: SongSearchView().environmentObject(appState),
											label: {
												Text("Choose Different Song")
													.foregroundColor(.white)
													.padding(10)
													.background(.red)
													.cornerRadius(10)
													.shadow(radius: 3)
			})
			.simultaneousGesture(TapGesture().onEnded{
					deleteDailySong()
			})
		}
		.onAppear(perform: loadTrack)
		.alert(item: $alert) { alert in
				Alert(title: alert.title, message: alert.message)
		}
	}
	
	func loadTrack() {
		
		self.getTrackCancellable = appState.spotify.api.track("spotify:track:\(song.spotify_id)").sink(
			receiveCompletion: { _ in},
			receiveValue: { track in
				// print("received track")
				self.track = track
				loadImage()
			}
		)
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

		if (track.id != song.spotify_id) {
			//print("track not loaded")
			return
		}
		
		guard let spotifyImage: SpotifyImage = track.album?.images?.largest else {
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
	
	func deleteDailySong() {
		appState.currentUser?.user.daily_songs.removeValue(forKey: "\(Date().month)-\(Date().day)-\(Date().year)")
		appState.currentUser?.updateCurrentUserInFirestore()
		appState.selectedTab = 0 // forces view to refresh
	}
}
