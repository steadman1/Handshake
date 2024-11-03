//
//  GetToKnow.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import SwiftUI
import SpenceKit
import ViewExtractor
import FirebaseAuth

struct GetToKnow: View {
    @EnvironmentObject var defaults: ObservableDefaults
    
    @Binding var isUserNotCreated: Bool
    
    @StateObject private var user = User.blank
    @State private var selection: Int = 0
    
    let labels = [
        "You",
        "Interests",
        "Socials",
        "Your Card"
    ]
    
    var body: some View {
        VStack {
            ProgressSelector($selection, style: .primary, hasFinish: true, labels: labels)
                .frame(height: 48)
            
            Extract(contentView()) { views in
                VStack {
                    ForEach(Array(zip(views.indices, views)), id: \.0) { index, view in
                        if selection == index {
                            view.id(index).tag(index)
                        }
                    }
                }.animation(.bouncy, value: selection)
            }
            
            Spacer()
        }.onChange(of: selection) { _, newValue in
            if newValue == labels.count {
                print("TEST")
                isUserNotCreated = false
                user.sendToSignupEndpoint()
            }
        }
    }
    
    @ViewBuilder
    func contentView() -> some View {
        WhoAreYou(user: user, selection: $selection)
        SomeInterests(user: user, selection: $selection)
        SharedSocials(user: user, selection: $selection)
        YourHandshakeCard(user: user, selection: $selection)
    }
}

#Preview {
    GetToKnow(isUserNotCreated: .constant(false)).environmentObject(ObservableDefaults.shared)
}
