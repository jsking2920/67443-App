// based on: https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/
// by Peter Schorn

import SwiftUI
import Combine
import SpotifyWebAPI
import SpotifyExampleContent

struct GetRecommendationsView: View {
		
		@EnvironmentObject var spotify: Spotify

		@State private var tracks: [Track]

		@State private var alert: AlertItem? = nil

		@State private var isLoadingRecs = false
		@State private var didRequestRecs = false
		
		@State private var loadTopTracksCancellable: AnyCancellable? = nil

		init() {
				self._tracks = State(initialValue: [])
		}
		
		fileprivate init(tracks: [Track]) {
				self._tracks = State(initialValue: tracks)
		}

		var body: some View {
				Group {
						if tracks.isEmpty {
								if isLoadingRecs {
										HStack {
												ProgressView()
														.padding()
												Text("Loading Tracks")
														.font(.title)
														.foregroundColor(.secondary)
										}
								}
								else {
										Text("No Recommended Tracks")
												.font(.title)
												.foregroundColor(.secondary)
								}
						}
						else {
								List {
										ForEach(
												Array(tracks.enumerated()),
												id: \.offset
										) { item in

												TrackView(track: item.element)
										}
								}
						}
				}
				.navigationTitle("Top Picks")
				.navigationBarItems(trailing: refreshButton)
				.onAppear {
						// don't try to load any tracks if we're previewing because sample
						// tracks have already been provided
						if ProcessInfo.processInfo.isPreviewing {
								return
						}

						print("onAppear")
						// the `onAppear` can be called multiple times, but we only want to
						// load the first page once
						if !self.didRequestRecs {
								self.didRequestRecs = true
								self.loadRecommendations()
						}
				}
				.alert(item: $alert) { alert in
						Alert(title: alert.title, message: alert.message)
				}
		}
		
		var refreshButton: some View {
				Button(action: self.loadRecommendations) {
						Image(systemName: "arrow.clockwise")
								.font(.title)
								.scaleEffect(0.8)
				}
				.disabled(isLoadingRecs)
		}
}

extension GetRecommendationsView {
		
		// Normally, you would extract these methods into a separate model class.

		/// Loads the first page. Called when this view appears.
		func loadRecommendations() {
			
			// TODO: implement this (currently doesn't work because there's no seeded tracks/artists/genres)
			// ideas
			// 		Grab songs from past days to seed recommendations
			//		Have a category for popular genres
			//    Have a category for popular tracks
			//		Have a underground category with low popularity
			//		Allow user to mess with some sliders to set these
			let recSeed = TrackAttributes.init(seedArtists: nil,
																				 seedTracks: nil,
																				 seedGenres: nil,
																				 acousticness: AttributeRange(min: 0.8, max: 1.0), // scale from 0.0 to 1.0
																				 danceability: nil,
																				 durationMS: nil,
																				 energy: nil,
																				 instrumentalness: nil,
																				 key: nil,
																				 liveness: nil,
																				 loudness: AttributeRange(min: 0.8, max: 1.0),
																				 mode: nil,
																				 popularity: AttributeRange(min: 95, max: 100), // scale from 0 to 100
																				 speechiness: nil,
																				 tempo: nil,
																				 timeSignature: nil,
																				 valence: nil)
				
				self.isLoadingRecs = true
				self.tracks = []
				
				self.loadTopTracksCancellable = self.spotify.api
						.recommendations(recSeed, limit: 5)
						.receive(on: RunLoop.main)
						.sink(
								receiveCompletion: self.receiveTracksCompletion(_:),
								receiveValue: { results in
										self.tracks = results.tracks
								}
						)
		}
		
		func receiveTracksCompletion(
				_ completion: Subscribers.Completion<Error>
		) {
				if case .failure(let error) = completion {
						let title = "Couldn't retrieve user's recommended tracks"
						print("\(title): \(error)")
						self.alert = AlertItem(
								title: title,
								message: error.localizedDescription
						)
				}
				self.isLoadingRecs = false
		}

}
