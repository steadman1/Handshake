//
//  File.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import SwiftUI
import SpenceKit

struct WhoAreYou: View {
    @ObservedObject var user: User
    @Binding var selection: Int
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Spacer().frame(height: SpenceKit.Constants.padding16)
                
                Text("Let's Get to Know You.")
                    .font(.SpenceKit.SerifXLargeTitleFont)
                
                Spacer().frame(height: 40)
                
                InlineTextField("What's should we call you?", $user.name, title: "Name", description: "")
                
                Spacer().frame(height: 40)
                
                MultilineTextField("Tell us about yourself.", $user.bio, title: "Short Bio", description: "", maxCharacters: 250)
                
            }.padding(.horizontal, SpenceKit.Constants.padding16)
                .padding(.bottom, 140)
        }.ignoresSafeArea()
            .safeAreaInset(edge: .bottom) {
                VStack {
                    ExpandingButton(.CTA) {
                        selection += 1
                    } label: {
                        Text("Continue")
                            .font(.SpenceKit.SansHeadlineFont)
                    }.padding([.horizontal], SpenceKit.Constants.padding16)
                }
            }
            
    }
}

