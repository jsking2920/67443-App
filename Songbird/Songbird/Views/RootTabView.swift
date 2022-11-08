// Based on: https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Model/Spotify.swift
// by Peter Schorn

import SwiftUI

struct RootTabView: View {
	
		@EnvironmentObject var spotify: Spotify
		@EnvironmentObject var userCollection: UserCollection
    
    var body: some View {
			// This is the location where you can add views to the application.
			// Each view receives an instance of `Spotify` from the environment.
			TabView {
				HomeView().tabItem {
					Label("Home", systemImage: "house")
					Text("Home")
				}.environmentObject(spotify).environmentObject(userCollection)
				CalendarView(userCollection: userCollection).tabItem {
					Label("History", systemImage: "calendar")
					Text("History")
				}.environmentObject(spotify)
				OptionsView().tabItem {
					Label("Options", systemImage: "ellipsis")
					Text("Options")
				}.environmentObject(spotify).environmentObject(userCollection)
				
				/* Views from example app */
				// PlaylistsListView().tabItem {Image(systemName: "house")}
				// SavedAlbumsGridView().tabItem {Image(systemName: "house")}
				// SearchForTracksView().tabItem {Image(systemName: "house")}
				// RecentlyPlayedView().tabItem {Image(systemName: "house")}
				// DebugMenuView().tabItem {Image(systemName: "house")}
        }
			.tabViewStyle(DefaultTabViewStyle())// PageTabViewStyle(indexDisplayMode: .always)  could be cool
			.tint(.green) // todo: standardize this to spotify colors
    }
}

struct ExamplesListView_Previews: PreviewProvider {
    
    static let spotify: Spotify = {
        let spotify = Spotify()
        spotify.isAuthorized = true
        return spotify
    }()
    
    static var previews: some View {
        NavigationView {
            RootTabView()
                .environmentObject(spotify)
        }
    }
}
