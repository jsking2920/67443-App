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
    
    
    func sorterForDates(this:String, that:String) -> Bool {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-DD-YYYY"
        var d1 = dateFormatter.date(from: this)
        var d2 = dateFormatter.date(from: that)
        return d1! > d2!
    }
    // solution we figured out : on button press iterate over daily songs and add each to array to display + send off to playlist!!!@!
    

    var body: some View {
        VStack{
                DatePicker("Start Date", selection: $startDate,
                           displayedComponents: [.date])
                DatePicker("End Date",
                           selection: $endDate,
                           displayedComponents: [.date])
                }
            Button(action: playlistCreator, label: {
                Text("Create Playlist")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color(red: 0.392, green: 0.720, blue: 0.197))
                    .cornerRadius(10)
                    .shadow(radius: 3)
            })
    }
    func playlistCreator() {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-DD-YYYY"
        var daily_songs = userCollection.users.first?.daily_songs
        var songs: [SpotifyURIConvertible] = []
        daily_songs?.forEach{ date, song in
            let d = dateFormatter.date(from: date)
            if (startDate ... endDate).contains(d!) {
                songs.append("spotify:track:\(song.spotify_id)")
            }
        }
        var newPlaylist = spotify.api.createPlaylist(for: (spotify.currentUser?.uri)!, PlaylistDetails(name:"New Playlist from SongBird", description: "Generated on \(Date.now) via the SongBird App! Contains songs picked from \(startDate) to \(endDate)"))
        var result = spotify.api.addToPlaylist(newPlaylist.description.uri, uris: songs)
        var url = "www.spotify.com/playlist/\(result.description.uri.components(separatedBy: ":")[2])"
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}
 
