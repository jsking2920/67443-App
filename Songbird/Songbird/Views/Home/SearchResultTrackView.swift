//
//  SearchResultTrackView.swift
//  Songbird
//
//  Created by Scott King on 11/8/22.
//

import SwiftUI
import Combine
import SpotifyWebAPI

struct SearchResultTrackView: View {
		
	@EnvironmentObject var appState: AppState
		let track: Track
		
		var body: some View {
			NavigationLink(destination: DailySongConfirmationView(track: track)) {
				HStack {
						Text(trackDisplayName())
						Spacer()
				}
				// Ensure the hit box extends across the entire width of the frame.
				// See https://bit.ly/2HqNk4S
				.contentShape(Rectangle())
			}
			.buttonStyle(PlainButtonStyle())
		}
		
		/// The display name for the track. E.g., "Eclipse - Pink Floyd".
		func trackDisplayName() -> String {
				var displayName = track.name
				if let artistName = track.artists?.first?.name {
						displayName += " - \(artistName)"
				}
				return displayName
		}
}
