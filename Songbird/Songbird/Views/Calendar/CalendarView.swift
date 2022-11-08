//
//  CalendarView.swift
//  Songbird
//
//  Created by Scott King on 11/7/22.
//

import SwiftUI
import Combine
import SpotifyWebAPI
import ElegantCalendar

struct CalendarView: View {
	
	@EnvironmentObject var spotify: Spotify

	@ObservedObject var calendarManager = ElegantCalendarManager(
		configuration: CalendarConfiguration(startDate: Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * (-30 * 36))),
																				 endDate: Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * (30 * 36))))
	)
	
	var body: some View {

		ElegantCalendarView(calendarManager: calendarManager)
	}
}
