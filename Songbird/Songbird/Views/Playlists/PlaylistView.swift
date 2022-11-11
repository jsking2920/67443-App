//
//  PlaylistView.swift
//  Songbird
//
//  Created by Shayan on 11/10/22.
//

import SwiftUI
import Combine

struct PlaylistView: View {
    
    @EnvironmentObject var spotify: Spotify
    @EnvironmentObject var userCollection: UserCollection
    
    var body: some View {
        // View is just two date pickers and the list of songs in between those dates, and an export button leading to Spotify the App.
        PlaylistDatePickerView()
    }
}
