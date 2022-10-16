//
//  UsersView.swift
//  Songbird
//
//  Created by Scott King on 10/16/22.
//

import SwiftUI

struct UsersView: View {
	
	@ObservedObject var userCollection = UserCollection()
		
	var body: some View {
		NavigationView {
			List{
				ForEach(userCollection.users) { user in
					UserRowView(user: user)
				}
			}.navigationBarTitle("Users")
		}
	}
}
