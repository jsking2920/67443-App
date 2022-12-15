// Adapted from: https://github.com/Peter-Schorn/SpotifyAPIExampleApp/blob/main/SpotifyAPIExampleApp/Model/Spotify.swift
// by Peter Schorn

import SwiftUI
import Combine
import SpotifyWebAPI

struct TrackView: View {
    
    @EnvironmentObject var spotify: Spotify

    @State private var alert: AlertItem? = nil
    
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
				.alert(item: $alert) { alert in
						Alert(title: alert.title, message: alert.message)
				}
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

