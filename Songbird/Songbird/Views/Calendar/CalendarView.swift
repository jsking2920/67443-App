//
//  CalendarView.swift
//  Songbird
//
//  Created by Scott King on 11/7/22.
//

import SwiftUI
import Combine
import SpotifyWebAPI

struct CalendarView: View {
	
	@EnvironmentObject var spotify: Spotify
	
	@State private var selected_date = Date()
	
	var body: some View {
		/*
		DatePicker(
			"????",
			selection: $selected_date,
			displayedComponents: [.date]
		)
		.datePickerStyle(.graphical)
		 */
		Text("placeholder")
	}
}
