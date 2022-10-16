//
//  UserDetailView.swift
//  Songbird
//
//  Created by Scott King on 10/16/22.
//

import SwiftUI

struct UserDetailsView: View {

	var user: User
		
	var body: some View {
		VStack {
			Text(user.username)
				.font(.title)
				.fontWeight(.black)
				.padding([.top], 40)
			Text("Password:  \(user.password)")
				.font(.title3)
				.fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
				.padding(5)
		}.navigationBarTitle(Text("User Details"), displayMode: .inline)
		
		Spacer()  // To force the content to the top
	}
}
