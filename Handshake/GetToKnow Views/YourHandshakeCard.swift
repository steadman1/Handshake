//
//  YourHandshakeCard.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import SwiftUI
import SpenceKit

struct YourHandshakeCard: View {
    @ObservedObject var user: User
    @Binding var selection: Int
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Spacer().frame(height: SpenceKit.Constants.padding16)
                
                Text("Design Your Handshake Card.")
                    .font(.SpenceKit.SerifXLargeTitleFont)
                
                Spacer().frame(height: 40)
                
                
            }.padding(.horizontal, SpenceKit.Constants.padding16)
                .padding(.bottom, 140)
        }.ignoresSafeArea()
            .safeAreaInset(edge: .bottom) {
                VStack {
                    ExpandingButton(.CTA) {
                        selection += 1
                    } label: {
                        Text("Finish")
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
