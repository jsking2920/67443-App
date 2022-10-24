//
//  SongbirdApp.swift
//  Songbird
//
//  Created by Scott King on 10/15/22.
//

import SwiftUI
import FirebaseCore
import Combine
import SpotifyWebAPI

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication,
									 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()

		return true
	}
}

@main
struct YourApp: App {
	// register app delegate for Firebase setup
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	// Set up helper class for spotify authorization
	@StateObject var spotify = Spotify()
	
	init() {
		SpotifyAPILogHandler.bootstrap()
	}

	var body: some Scene {
		WindowGroup {
			RootView().environmentObject(spotify)
		}
	}
}
