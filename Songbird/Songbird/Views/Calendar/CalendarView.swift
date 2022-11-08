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
	var userCollection: UserCollection

	@ObservedObject var calendarManager =
		ElegantCalendarManager(
			configuration: CalendarConfiguration(
				startDate: Date(year: 2021, month: 1, day: 1, hour: 0, minute: 0),
				endDate: Date() // Today
			),
			initialMonth: Date() // this month
		)
	
	init(userCollection: UserCollection) {
		self.userCollection = userCollection
		calendarManager.datasource = self
	}
	
	var body: some View {
		ElegantCalendarView(calendarManager: calendarManager)
			.theme(CalendarTheme(primary: Color(red: 0.392, green: 0.720, blue: 0.197), textColor: .white, todayTextColor: .white, todayBackgroundColor: .blue))
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
			return CalendarBlankDayView().erased
		}
		return CalendarSongView(song: song!).erased
	}
}
