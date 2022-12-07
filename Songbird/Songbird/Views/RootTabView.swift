// Based on: https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Model/Spotify.swift
// by Peter Schorn

import SwiftUI

struct RootTabView: View {
//	backgroundColor
	@EnvironmentObject var appState: AppState

	var body: some View {
        if #available(iOS 16.0, *) {
            TabView(selection: $appState.selectedTab) {
                HomeView().tabItem {
                    Label("Home", systemImage: "house")
                    Text("Home")
                }.environmentObject(appState).tag(0)
                CalendarView().tabItem {
                    Label("History", systemImage: "calendar")
                    Text("History")
                }.environmentObject(appState).tag(1)
                PlaylistView().tabItem{
                    Label("Playlists", systemImage: "music.note.list")
                    Text("Playlists")
                }.environmentObject(appState).tag(2)
                OptionsView().tabItem {
                    Label("Profile", systemImage: "person.circle")
                    Text("Profile")
                }.environmentObject(appState).tag(3)
            }
            .tabViewStyle(DefaultTabViewStyle())// PageTabViewStyle(indexDisplayMode: .always)  could be cool
            .tint(Color(red: 0x1D/256, green: 0xB9/256, blue: 0x54/256))
            .toolbar(.visible, for: .tabBar)
            .toolbarBackground(
                // 1
                Color.black,
                // 2
                for: .tabBar)
        } else {
            // Fallback on earlier versions
        }
	}
}
