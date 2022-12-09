//
//  OptionsView.swift
//  Songbird
//
//  Created by Scott King on 11/7/22.
//
 
import SwiftUI
import Combine
import SpotifyWebAPI

struct OptionsView: View {
	
	@EnvironmentObject var appState: AppState
	
	/// User's profile image
	@State private var image = Image(systemName: "person.circle")
	@State private var didRequestImage = false
	
	@State private var alert: AlertItem? = nil
	
	// MARK: Cancellables
	@State private var loadImageCancellable: AnyCancellable? = nil
	
	var body: some View {
		
		NavigationView {
			
			VStack {
	
				image
					.frame(width: 150, height: 150)
					.padding()
					.clipShape(Circle())
					.shadow(radius: 10)
					.overlay(Circle().stroke(Color(red: 0x1D/256, green: 0xB9/256, blue: 0x54/256), lineWidth: 3))

				Text(appState.spotify.currentUser?.displayName ?? "user")
					.font(.subheadline)
					.padding()

				/// Removes the authorization information for the user.
				/// Calling `spotify.api.authorizationManager.deauthorize` will cause
				/// `SpotifyAPI.authorizationManagerDidDeauthorize` to emit a signal,
				/// which will cause `Spotify.authorizationManagerDidDeauthorize()` to be
				/// called.
				Button(action: appState.spotify.api.authorizationManager.deauthorize, label: {
					Text("Logout")
						.foregroundColor(.white)
						.padding(10)
						.background(
                            Color(red: 0x1D/256, green: 0xB9/256, blue: 0x54/256)
						)
						.cornerRadius(10)
						.shadow(radius: 3)
				})
			}
			.alert(item: $alert) { alert in
					Alert(title: alert.title, message: alert.message)
			}
			.onAppear(perform: loadImage)
			.navigationBarTitle("Profile")
		}
	}
	
	/// Loads the image for the user
	func loadImage() {
			
			// Return early if the image has already been requested. We can't just
			// check if `self.image == nil` because the image might have already
			// been requested, but not loaded yet.
			if self.didRequestImage {
					// print("already requested image")
					return
			}
			self.didRequestImage = true
			
		guard let spotifyImage = appState.spotify.currentUser!.images?.largest else {
					// print("no image found")
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
									// print("received image")
									self.image = image
							}
					)
	}
}
