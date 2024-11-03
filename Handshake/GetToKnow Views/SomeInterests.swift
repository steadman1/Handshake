//
//  SomeInterests.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import SwiftUI
import SpenceKit

struct SomeInterests: View {
    @ObservedObject var user: User
    @Binding var selection: Int
    
    // State variables to hold text input
    @State private var interestsInput: String = ""
    @State private var songsInput: String = ""
    
    // State variables to control alert presentation
    @State private var showInterestsAlert = false
    @State private var showMusicAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Spacer().frame(height: SpenceKit.Constants.padding16)
                
                Text("Some of Your Interests.")
                    .font(.SpenceKit.SerifXLargeTitleFont)
                
                Spacer().frame(height: 40)
                
                // Interests Multiline TextField
                MultilineTextField("Enter a few interests—separated by commas.", $interestsInput, title: "Interests, Hobbies, and Activities", description: "", maxCharacters: 250) {
                    HelperButtons.Info {
                        showInterestsAlert = true // Trigger alert
                    }
                }
                .alert(isPresented: $showInterestsAlert) {
                    Alert(
                        title: Text("Interests Formatting"),
                        message: Text("Please enter a list of your interests, hobbies, and activities, separated by commas. For example: 'Reading, Hiking, Cooking, Traveling'."),
                        dismissButton: .default(Text("Got it!"))
                    )
                }
                
                Spacer().frame(height: 40)
                
                // Music Multiline TextField
                MultilineTextField("Enter a few of your favorite songs—separated by commas.", $songsInput, title: "Music", description: "", maxCharacters: 250) {
                    HelperButtons.Info {
                        showMusicAlert = true // Trigger alert
                    }
                }
                .alert(isPresented: $showMusicAlert) {
                    Alert(
                        title: Text("Music Formatting"),
                        message: Text("Please enter a list of your favorite songs, separated by commas. For example: 'Bohemian Rhapsody, Imagine, Stairway to Heaven'."),
                        dismissButton: .default(Text("Got it!"))
                    )
                }
                
            }
            .padding(.horizontal, SpenceKit.Constants.padding16)
            .padding(.bottom, 140)
        }
        .ignoresSafeArea()
        .onAppear {
            // Load initial values into the text fields
            interestsInput = user.interests.joined(separator: ", ")
            songsInput = user.songs.joined(separator: ", ")
        }
        .onDisappear {
            // Update user's interests and songs based on the inputs
            user.interests = interestsInput.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            
            user.songs = songsInput.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
        }
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
        }
    }
}
