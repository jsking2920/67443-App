//
//  HomeView.swift
//  Songbird
//
//  Created by Scott King on 11/7/22.
//

import SwiftUI
import Combine

struct HomeView: View {
	
	@EnvironmentObject var appState: AppState
	
	var body: some View {
		
		let todaysSong: DailySong? = appState.currentUser?.user.daily_songs["\(Date().month)-\(Date().day)-\(Date().year)"]
		
		// User has not chosen a song for today
		if (todaysSong == nil){
			SongSearchView()
		}
		else{
			DailySongView(song: todaysSong!)
		}
	}
}
