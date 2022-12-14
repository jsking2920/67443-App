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
	
	// @EnvironmentObject var appState: AppState
	var songs : Dictionary<String, DailySong>

	@ObservedObject var calendarManager =
		ElegantCalendarManager(
			configuration: CalendarConfiguration(
				startDate: Date(year: 2021, month: 1, day: 1, hour: 0, minute: 0),
				endDate: Date() // Today
			),
			initialMonth: Date() // this month
		)
	
	// Not the cleanest way to go about this but it works every time unlike appState
	init(songDict: Dictionary<String, DailySong>) {
		songs = songDict
		calendarManager.datasource = self
	}
	
	var body: some View {
        ZStack{
            ElegantCalendarView(calendarManager: calendarManager)
                .theme(CalendarTheme(primary: Color(red: 0x1D/256, green: 0xB9/256, blue: 0x54/256), textColor: .white, todayTextColor: .white, todayBackgroundColor: .blue))
                .onAppear(perform: {calendarManager.datasource = self})
        }
        .padding([.top], 100)
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
		//let song: DailySong? = appState.currentUser?.user.daily_songs["\(date.month)-\(date.day)-\(date.year)"]
		let song: DailySong? = songs["\(date.month)-\(date.day)-\(date.year)"]
		
		if (song == nil) {
			return 0.4
		}
		else{
			return 1.0
		}
	}
	
	func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
		//let song: DailySong? = appState.currentUser?.user.daily_songs["\(date.month)-\(date.day)-\(date.year)"]
		let song: DailySong? = songs["\(date.month)-\(date.day)-\(date.year)"]
		
		if (song == nil) {
			if (date.isToday) { return CalendarBlankDayView(s: "You haven't picked a song yet!", b: true).erased }
			return CalendarBlankDayView(b: false).erased
		}
		return CalendarSongView(song: song!).erased
	}
}
