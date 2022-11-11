//
//  PlaylistDatePickerView.swift
//  Songbird
//
//  Created by Jo Jo on 11/10/22.
//

import SwiftUI
import Combine

import SpotifyWebAPI

struct PlaylistDatePickerView: View {

    @EnvironmentObject var spotify: Spotify
    @EnvironmentObject var userCollection: UserCollection
    
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
    // solution we figured out : on button press iterate over daily songs and add each to array to display + send off to playlist!!!@!
    

    var body: some View {
        VStack{
            Spacer()
            DatePicker("Start Date", selection: $startDate,
                       displayedComponents: [.date])
            DatePicker("End Date",
                       selection: $endDate,
                       displayedComponents: [.date])
            Spacer()
            Button(action: playlistCreator, label: {
                Text("Create Playlist")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color(red: 0.392, green: 0.720, blue: 0.197))
                    .cornerRadius(10)
                    .shadow(radius: 3)
            })
            .padding()
        }
    }
    func playlistCreator() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-DD-YYYY"
        let daily_songs = userCollection.users.first?.daily_songs
        var songs: [SpotifyURIConvertible] = []
        daily_songs?.forEach{ date, song in
            let d = dateFormatter.date(from: date)
            if (startDate ... endDate).contains(d!) {
                songs.append("spotify:track:\(song.spotify_id)")
            }
        }
        var getPlaylist = spotify.api.createPlaylist(for: (spotify.currentUser?.uri)!, PlaylistDetails(name:"New Playlist from SongBird", description: "Generated on \(Date.now) via the SongBird App! Contains songs picked from \(startDate) to \(endDate)")).sink(receiveCompletion: {_ in}, receiveValue: {playlist in self.playlist = playlist})
        while (playlist)
        var result = spotify.api.addToPlaylist(playlist!.uri, uris: songs)
        print("Done!")
        let url = "www.open.spotify.com/playlist/\(playlist!.uri)"
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
 
