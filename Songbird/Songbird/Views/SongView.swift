//
//  SongView.swift
//  Songbird
//
//  Created by Scott King on 10/16/22.
//

import SwiftUI

struct SongView: View {
	
	var parser : SpotifyParser = SpotifyParser()
	@State var displayedSong: Song? = nil
	
	func loadData() {
		parser.fetchSong { (song) in
			self.displayedSong = song
		}
	}
	
	var body: some View {
		HStack{
			Text("Song")
			if let song = displayedSong {
				VStack {
					Text(song.name).padding()
					Text(song.id).padding()
				}
			}
		}.onAppear(perform: loadData)
	}
}
