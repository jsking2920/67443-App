// Based on: https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Model/Spotify.swift
// by Peter Schorn

import SwiftUI

// Users will only see this view, and the rest of the app, after going through authorization with Spotify
struct RootTabView: View {
	
	// Initialized with setCurrentUser in RootView after authorization
	@EnvironmentObject var appState: AppState

	var body: some View {

		if #available(iOS 16.0, *) {
			TabView(selection: $appState.selectedTab) {
				
				HomeView().tabItem {
					Label("Home", systemImage: "house")
					Text("Home")
				}.tag(0)
				CalendarView().tabItem {
					Label("History", systemImage: "calendar")
					Text("History")
				}.tag(1)
				PlaylistView().tabItem{
					Label("Playlists", systemImage: "music.note.list")
					Text("Playlists")
				}.tag(2)
				OptionsView().tabItem {
					Label("Profile", systemImage: "person.circle")
					Text("Profile")
				}.tag(3)
			}
			.tabViewStyle(DefaultTabViewStyle())// PageTabViewStyle(indexDisplayMode: .always)  could be cool
			.tint(Color(red: 0x1D/256, green: 0xB9/256, blue: 0x54/256))
			.toolbar(.visible, for: .tabBar)
			.toolbarBackground(Color.black, for: .tabBar)
		}
		else {
			
		}
	}
}
