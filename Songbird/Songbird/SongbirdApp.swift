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
import SwiftDate

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

	@StateObject var appState: AppState = AppState()
	
	init() {
		SpotifyAPILogHandler.bootstrap()
		SwiftDate.defaultRegion = Region(calendar: Calendars.gregorian, zone: Zones.americaNewYork)
	}

	var body: some Scene {
		WindowGroup {
			RootView().environmentObject(appState)
		}
	}
}
