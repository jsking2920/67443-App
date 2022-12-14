//
//  CalenderBlankDayView.swift
//  Songbird
//
//  Created by Scott King on 11/8/22.
//

import SwiftUI

struct CalendarBlankDayView: View {
	
	@EnvironmentObject var appState: AppState
	var message: String
	var showButton: Bool
	
	init(s: String = "You didn't pick song on this day!", b: Bool){
		message = s
		showButton = b
	}
	
	var body: some View {
		VStack {
			Text(message).padding()
			if (showButton) {
				Button(action: { appState.selectedTab = 0 }, label: {
					Text("Choose Today's Song")
						.foregroundColor(.white)
						.padding(10)
						.background(Color(red: 0.392, green: 0.720, blue: 0.197))
						.cornerRadius(10)
						.shadow(radius: 3)
				})
			}
			Spacer()
		}
	}
}
