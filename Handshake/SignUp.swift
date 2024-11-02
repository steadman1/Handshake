//
//  SignUp.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import SwiftUI
import SpenceKit

struct SignUp: View {
    
    @State private var phone_number = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Handshake")
                .font(.SpenceKit.SerifLargeTitleFont)
            Text("Find people near you.")
                .font(.SpenceKit.SansSubheadlineFont)
            
            Spacer()
            
            InlineTextField($phone_number,
                            title: "Phone Number",
                            description: "Enter your phone number to sign up.") {
                EmptyView()
            } helperButton: {
                HelperButtons.Info {
                    
                }
            }
            
            Spacer()
            Spacer()
            
            ExpandingButton(.CTA) {
                print()
            } label: {
                Text("Get Started")
                    .font(.SpenceKit.SansHeadlineFont)
            }

        }.padding(.horizontal, SpenceKit.Constants.padding16)
    }
}

#Preview {
    SignUp()
}
