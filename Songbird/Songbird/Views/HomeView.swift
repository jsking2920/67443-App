//
//  HomeView.swift
//  Songbird
//
//  Created by Scott King on 10/15/22.
//

import SwiftUI

struct HomeView: View {
	var body: some View {
		TabView {
			UsersView()
			.tabItem {
				Image(systemName: "books.vertical")
				Text("Users")
			}
			SongView()
			.tabItem {
				Image(systemName: "rectangle.stack.badge.plus")
				Text("Song")
			}
		}
	}
}
