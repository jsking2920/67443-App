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
import SwiftDate

struct CalendarView: View {
	
	@EnvironmentObject var spotify: Spotify
	@EnvironmentObject var userCollection: UserCollection

	@ObservedObject var calendarManager =
		ElegantCalendarManager(
			configuration: CalendarConfiguration(
				startDate: Date(year: 2021, month: 1, day: 1, hour: 0, minute: 0),
				endDate: Date() // Today
			),
			initialMonth: Date() // this month
		)

	var body: some View {
		ElegantCalendarView(calendarManager: calendarManager)
			.theme(CalendarTheme(primary: Color(red: 0.392, green: 0.720, blue: 0.197), textColor: .white, todayTextColor: .white, todayBackgroundColor: .blue))
			.onAppear(perform: {calendarManager.datasource = self})
		// Doing all the operations to determine which days should be clickable, etc. on appear here
		// makes this view very slow to load. Could set the datasource in init, but then the userCollection
		// has to be passed in since environmentObjects aren't initialized until the body, which also means
		// the calendar won't update since the userCollection is
	}
}
	
extension CalendarView: ElegantCalendarDataSource {
	func calendar(canSelectDate date: Date) -> Bool {
		//let song: DailySong? = userCollection.users.first?.daily_songs["\(date.month)-\(date.day)-\(date.year)"]
		
		/*
		if (song == nil) {
			return false
		}
		else{
			return true
		}
		 */
		return true;
	}
	
	func calendar(backgroundColorOpacityForDate date: Date) -> Double {
		let song: DailySong? = userCollection.users.first?.daily_songs["\(date.month)-\(date.day)-\(date.year)"]
		
		if (song == nil) {
			return 0.4
		}
		else{
			return 1.0
		}
	}
	
	func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
		let song: DailySong? = userCollection.users.first?.daily_songs["\(date.month)-\(date.day)-\(date.year)"]
		
		if (song == nil) {
			if (date.isToday) { return CalendarBlankDayView(s: "You haven't picked a song yet!").erased }
			return CalendarBlankDayView().erased
		}
		return CalendarSongView(song: song!).erased
	}
}
