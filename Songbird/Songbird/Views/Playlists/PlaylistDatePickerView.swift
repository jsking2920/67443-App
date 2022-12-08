//
//  PlaylistDatePickerView.swift
//  Songbird
//

import SwiftUI
import Combine

import SpotifyWebAPI

struct PlaylistDatePickerView: View {

	@EnvironmentObject var appState: AppState
	
	@State var startDate = Date()
	@State var endDate = Date()
	
	@State var playlist: Playlist<PlaylistItems>? = nil
	
	func sorterForDates(this:String, that:String) -> Bool {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MM-DD-YYYY"
			let d1 = dateFormatter.date(from: this)
			let d2 = dateFormatter.date(from: that)
			return d1! > d2!
	}
	// solution we figured out : on button press iterate over daily songs and add each to array to display + send off to playlist!!!!
	
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    Spacer()
                    DatePicker("Start Date", selection: $startDate,
                               displayedComponents: [.date])
                    DatePicker("End Date",
                               selection: $endDate,
                               displayedComponents: [.date])
                    Spacer()
                    Button(action: {
                        Task {
                            await createPlaylist()
                            print("ok tAsk")
                        }
                    }, label: {
                        Text("Create Playlist")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(red: 0x1D/256, green: 0xB9/256, blue: 0x54/256))
                            .cornerRadius(10)
                            .shadow(radius: 3)
                    })
                    .padding()
                }
            }
            .padding()
        }
        .navigationViewStyle(.stack)
    }

	func createPlaylist()  async {

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "M-d-yyyy"

		let daily_songs = appState.userCollection.users.first?.daily_songs
		var songs: [SpotifyURIConvertible] = []

        
        for (date, song) in daily_songs! {
            let d = dateFormatter.date(from: date)
            print("spotify:track:\(song.spotify_id)")
            if (startDate ... endDate).contains(d!) {
                print(d!)
                songs.append("spotify:track:\(song.spotify_id)")
            }
        }
        
		print("Songs to Add: \n")
        print(daily_songs!)
        print(songs)
        
		let user = appState.spotify.currentUser
		
		if (user != nil){
			let playlistInfo = PlaylistDetails(name:"New Playlist from SongBird")
//                                               ,
//                                               description: "Generated on \(Date.now.formatted(date: .abbreviated, time: .omitted)) via the SongBird App! Contains songs picked from \(startDate.formatted(date: .abbreviated, time: .omitted)) to \(endDate.formatted(date: .abbreviated, time: .omitted))")
            
            appState.spotify.api.createPlaylist(for: user!.uri, playlistInfo)
                .sink(receiveCompletion: { _ in
                }, receiveValue: {playlist in
                    self.playlist = playlist
                    appState.spotify.api.addToPlaylist(playlist.uri, uris: songs)
                    let url = "www.open.spotify.com/playlist/\(playlist.uri)"
                    print(playlist.uri)
                    if let url = URL(string: url) {
                        UIApplication.shared.open(url)
                    }
                    print("ok FN")
                    
                })
			
			if (playlist != nil) {
				// Note: can only add 100 at a time so check for that
			}
            print("Done")
		}
	}
}
 
