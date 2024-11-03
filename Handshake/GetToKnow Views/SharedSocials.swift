//
//  SharedSocials.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import SwiftUI
import SpenceKit

struct SharedSocials: View {
    @ObservedObject var user: User
    @Binding var selection: Int
    
    // State variables to control alert presentation
    @State private var accountUsernameAlert = false
    @State private var showMusicAlert = false
    
    @State private var sharePhonenumber = true
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Spacer().frame(height: SpenceKit.Constants.padding16)
                
                Text("Shared Socials After a Handshake.")
                    .font(.SpenceKit.SerifXLargeTitleFont)
                
                HStack {
                    Text("Share your phone number with others?")
                        .font(.SpenceKit.SansBodyFont)
                    
                    Spacer()
                    
                    Toggle($sharePhonenumber)
                }
                
                Spacer().frame(height: 40)
                
                InlineTextField("Your Instagram Username...", $user.instagram, title: "Instagram", description: "Optional") {
                    HelperButtons.Info {
                        accountUsernameAlert = true // Trigger alert
                    }
                }
                
                Spacer().frame(height: 40)
                
                InlineTextField("Your Snapchat Username...", $user.snapchat, title: "Snapchat", description: "Optional") {
                    HelperButtons.Info {
                        accountUsernameAlert = true // Trigger alert
                    }
                }
                
                Spacer().frame(height: 40)
                
                MultilineTextField("Your other social media handles.", $user.other, title: "Other Platforms", description: "", maxCharacters: 250) {
                    HelperButtons.Info {
                        accountUsernameAlert = true // Trigger alert
                    }
                }
            }.padding(.horizontal, SpenceKit.Constants.padding16)
                .padding(.bottom, 140)
        }
        .ignoresSafeArea()
        .safeAreaInset(edge: .bottom) {
            VStack {
                ExpandingButton(.CTA) {
                    selection += 1
                } label: {
                    Text("Continue")
                        .font(.SpenceKit.SansHeadlineFont)
                }
                .padding([.horizontal], SpenceKit.Constants.padding16)
                
                ExpandingButton(.lowest) {
                    selection -= 1
                } label: {
                    Text("Back")
                        .font(.SpenceKit.SansSubheadlineFont)
                }
                .padding(.vertical, -SpenceKit.Constants.padding12)
                .padding(.horizontal, SpenceKit.Constants.padding16)
            }
        }.alert(isPresented: $accountUsernameAlert) {
            Alert(
                title: Text("Social Media Username"),
                message: Text("Enter your username for the given social media platform. This field is not required."),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}
