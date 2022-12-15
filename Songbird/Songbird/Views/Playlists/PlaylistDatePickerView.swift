//
//  PlaylistDatePickerView.swift
//  Songbird
//

import SwiftUI
import Combine

import SpotifyWebAPI
import SwiftDate

struct PlaylistDatePickerView: View {

	@EnvironmentObject var appState: AppState
	
	@State var startDate = Date() - 1.days
	@State var endDate = Date()
	
	@State var playlist: Playlist<PlaylistItems>? = nil
	@State var snapshot_id: String = ""
	
	// MARK: Cancellables
	@State private var playlistCancellable: AnyCancellable? = nil
	@State private var playlistCancellable2: AnyCancellable? = nil
	
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    Spacer()
                    DatePicker("Start Date",
															 selection: $startDate,
															 in: PartialRangeThrough(endDate - 1.days),
                               displayedComponents: [.date])
                    DatePicker("End Date",
                               selection: $endDate,
															 in: PartialRangeThrough(Date()),
															 displayedComponents: [.date])
                    Spacer()
										Button(action: createPlaylist,
													 label: {
														 Text("Create Playlist")
																.foregroundColor(.white)
																.padding(10)
																.background(Color(red: 0x1D/256, green: 0xB9/256, blue: 0x54/256))
																.cornerRadius(10)
																.shadow(radius: 3)
														}).padding()
                }
            }
            .padding()
        }
        .navigationViewStyle(.stack)
    }

	func createPlaylist() {

		let user = appState.currentUser?.user
		
		if (user != nil) {
			appState.selectedTab = 2 // force view refresh

			let daily_songs = user!.daily_songs
			var songs: [SpotifyURIConvertible] = []
			
			// Grab all songs in provided range
			for (date, song) in daily_songs {
					
					// TODO: convert this to use Swift Date instead of this garbage
					let s = date.split(separator: "-")
					if (s.count != 3) {
						print("Found malformed date while creating playlist")
						return
					}
					let d = Date(year: Int(s[2]) ?? 0, month: Int(s[0]) ?? 0, day: Int(s[1]) ?? 0, hour: 0, minute: 0, second: 0)
					
					if (startDate ... endDate).contains(d) {
							songs.append("spotify:track:\(song.spotify_id)")
					}
			}
			
			// Specify playlist meta-data
			let playlistInfo = PlaylistDetails(name:"Songbird \(startDate.formatted(date: .abbreviated, time: .omitted)) to \(endDate.formatted(date: .abbreviated, time: .omitted))",
																				 isPublic: true,
																				 description: "Generated on \(Date.now.formatted(date: .abbreviated, time: .omitted)) via the SongBird App! Contains songs picked from \(startDate.formatted(date: .abbreviated, time: .omitted)) to \(endDate.formatted(date: .abbreviated, time: .omitted))")
	
			self.playlistCancellable =
				appState.spotify.api.createPlaylist(for: appState.spotify.currentUser!.uri, playlistInfo)
					.receive(on: RunLoop.main)
					.sink(
						receiveCompletion: { _ in },
					  receiveValue: { playlist in
							self.playlist = playlist

							self.playlistCancellable2 =
								appState.spotify.api.addToPlaylist(playlist.uri, uris: songs)
									.receive(on: RunLoop.main)
									.sink(
										receiveCompletion: { _ in },
										receiveValue: {playlist in
											self.snapshot_id = playlist
											
											// Open spotify playlist
											/*
											let url = "www.open.spotify.com/playlist/\(playlist.uri)"
											if let url = URL(string: url) {
													UIApplication.shared.open(url)
											}
											*/
										}
									)
					})
		}
	}
}
