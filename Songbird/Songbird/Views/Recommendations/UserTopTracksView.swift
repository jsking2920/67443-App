// based on: https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/
// by Peter Schorn

import SwiftUI
import Combine
import SpotifyWebAPI
import SpotifyExampleContent

struct UserTopTracksView: View {
		
		var timeRange: TimeRange = TimeRange.longTerm
		
		@EnvironmentObject var spotify: Spotify

		@State private var topTracks: [Track]

		@State private var alert: AlertItem? = nil

		@State private var nextPageHref: URL? = nil
		@State private var isLoadingPage = false
		@State private var didRequestFirstPage = false
		
		@State private var loadTopTracksCancellable: AnyCancellable? = nil

		init(_ range: TimeRange) {
				self._topTracks = State(initialValue: [])
				self.timeRange = range
		}
		
		fileprivate init(topTracks: [Track]) {
				self._topTracks = State(initialValue: topTracks)
		}

		var body: some View {
				Group {
						if topTracks.isEmpty {
								if isLoadingPage {
										HStack {
												ProgressView()
														.padding()
												Text("Loading Tracks")
														.font(.title)
														.foregroundColor(.secondary)
										}
								}
								else {
										Text("No Top Tracks")
												.font(.title)
												.foregroundColor(.secondary)
								}
						}
						else {
								List {
										ForEach(
												Array(topTracks.enumerated()),
												id: \.offset
										) { item in

												TrackView(track: item.element)
														// Each track in the list will be loaded lazily. We
														// take advantage of this feature in order to detect
														// when the user has scrolled to *near* the bottom
														// of the list based on the offset of this item.
														.onAppear {
																self.loadNextPageIfNeeded(offset: item.offset)
														}

										}
								}
						}
				}
				.navigationTitle(timeRange == TimeRange.shortTerm ? "Recent Favorites" : "All-time Favorites" )
				.onAppear {
						// don't try to load any tracks if we're previewing because sample
						// tracks have already been provided
						if ProcessInfo.processInfo.isPreviewing {
								return
						}

						print("onAppear")
						// the `onAppear` can be called multiple times, but we only want to
						// load the first page once
						if !self.didRequestFirstPage {
								self.didRequestFirstPage = true
								self.loadTopTracks()
						}
				}
				.alert(item: $alert) { alert in
						Alert(title: alert.title, message: alert.message)
				}
		}
}

extension UserTopTracksView {
		
		// Normally, you would extract these methods into a separate model class.
		
		/// Determines whether or not to load the next page based on the offset of
		/// the just-loaded item in the list.
		func loadNextPageIfNeeded(offset: Int) {
				
				let threshold = self.topTracks.count - 5
				
				print(
						"""
						loadNextPageIfNeeded threshold: \(threshold); offset: \(offset); \
						total: \(self.topTracks.count)
						"""
				)
				
				// load the next page if this track is the fifth from the bottom of the
				// list
				guard offset == threshold else {
						return
				}
				
				guard let nextPageHref = self.nextPageHref else {
						print("no more paged to load: nextPageHref was nil")
						return
				}
				
				guard !self.isLoadingPage else {
						return
				}

				self.loadNextPage(href: nextPageHref)
		}
		
		/// Loads the next page of results from the provided URL.
		func loadNextPage(href: URL) {
		
				print("loading next page")
				self.isLoadingPage = true
				
				self.loadTopTracksCancellable = self.spotify.api
						.getFromHref(
								href,
								responseType: PagingObject<Track>.self
						)
						.receive(on: RunLoop.main)
						.sink(
								receiveCompletion: self.receiveTopTracksCompletion(_:),
								receiveValue: { results in
										let tracks = results.items
										print(
												"received next page with \(tracks.count) items"
										)
										self.nextPageHref = results.next
										self.topTracks += tracks
								}
						)

		}

		/// Loads the first page. Called when this view appears.
		func loadTopTracks() {
				
				print("loading first page")
				self.isLoadingPage = true
				self.topTracks = []
				
				self.loadTopTracksCancellable = self.spotify.api
						.currentUserTopTracks(timeRange)
						.receive(on: RunLoop.main)
						.sink(
								receiveCompletion: self.receiveTopTracksCompletion(_:),
								receiveValue: { results in
										let tracks = results.items
										print(
												"received first page with \(tracks.count) items"
										)
										self.nextPageHref = results.next
										self.topTracks = tracks
								}
						)

		}
		
		func receiveTopTracksCompletion(
				_ completion: Subscribers.Completion<Error>
		) {
				if case .failure(let error) = completion {
						let title = "Couldn't retrieve user's top tracks"
						print("\(title): \(error)")
						self.alert = AlertItem(
								title: title,
								message: error.localizedDescription
						)
				}
				self.isLoadingPage = false
		}

}
