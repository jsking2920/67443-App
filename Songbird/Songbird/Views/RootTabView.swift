// Based on: https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Model/Spotify.swift
// by Peter Schorn

import SwiftUI

struct RootTabView: View {
	
	@EnvironmentObject var appState: AppState

	var body: some View {

		TabView(selection: $appState.selectedTab) {
			HomeView().tabItem {
				Label("Home", systemImage: "house")
				Text("Home")
			}.environmentObject(appState).tag(0)
			CalendarView().tabItem {
				Label("History", systemImage: "calendar")
				Text("History")
			}.environmentObject(appState).tag(1)
			OptionsView().tabItem {
				Label("Options", systemImage: "ellipsis")
				Text("Options")
			}.environmentObject(appState).tag(2)
		}
		.tabViewStyle(DefaultTabViewStyle())// PageTabViewStyle(indexDisplayMode: .always)  could be cool
		.tint(.green) // todo: standardize this to spotify colors
	}
}
