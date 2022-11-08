//
//  CalenderBlankDayView.swift
//  Songbird
//
//  Created by Scott King on 11/8/22.
//

import SwiftUI

struct CalendarBlankDayView: View {
	
	var message: String
	
	init(s: String = "You didn't pick song on this day!"){
		message = s
	}
	
	var body: some View {
		Text(message)
	}
}
