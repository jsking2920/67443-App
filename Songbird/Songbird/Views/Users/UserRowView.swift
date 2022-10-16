//
//  UserRowView.swift
//  Songbird
//
//  Created by Scott King on 10/16/22.
//

import SwiftUI

struct UserRowView: View {

	var user: User
		
	var body: some View {
		NavigationLink(destination: UserDetailsView(user: user),
			label: {
				Text(user.username)
					.fontWeight(.bold)
					.font(.body)
		})
	}
}
