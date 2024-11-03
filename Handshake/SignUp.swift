//
//  SignUp.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

//
//  SignUp.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/2/24.
//

import SwiftUI
import SpenceKit

struct SignUp: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var phone_number = ""
    @State private var verification_code = ""
    @State private var showPhoneAlert = false
    @State private var presentVerificationCode = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("Handshake")
                .font(.SpenceKit.SerifXLargeTitleFont)
            Text("Find people near you.")
                .font(.SpenceKit.SansBodyFont)
            
            Spacer()
            
            ZStack {
                InlineTextField(
                    "______",
                    $verification_code,
                    title: "Verification Code",
                    description: "Enter the code sent to your phone."
                ).opacity(presentVerificationCode ? 1 : 0)
                    .offset(y: presentVerificationCode ? 0 : -200)
                
                InlineTextField(
                    "(___) ___-____",
                    $phone_number,
                    title: "Phone Number",
                    description: "Enter your phone number to continue."
                ) {
                    Text("+1")
                        .font(.SpenceKit.SansBodyFont)
                        .foregroundStyle(Color.SpenceKit.PrimaryText)
                } helperButton: {
                    HelperButtons.Info {
                        showPhoneAlert = true
                    }
                }.opacity(presentVerificationCode ? 0 : 1)
                    .offset(y: presentVerificationCode ? 200 : 0)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, SpenceKit.Constants.padding16)
        .alert(isPresented: $showPhoneAlert) {
            Alert(
                title: Text("Phone Number Input"),
                message: Text("Please enter a valid phone number in the format (123) 456-7890."),
                dismissButton: .default(Text("Got it!"))
            )
        }
        .alert(isPresented: .constant(authViewModel.authError != nil)) {
            Alert(
                title: Text("Authentication Error"),
                message: Text(authViewModel.authError ?? ""),
                dismissButton: .default(Text("OK")) {
                    authViewModel.authError = nil // Clear error after dismissing
                }
            )
        }
        .onChange(of: authViewModel.isVerificationSent) { newValue in
            withAnimation {
                presentVerificationCode = true
            }
        }
        .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                print("User authenticated successfully")
                // Navigate to the next screen or show a success message
            }
        }.safeAreaInset(edge: .bottom) {
            ZStack {
                if authViewModel.isAuthenticated {
                    ExpandingButton(.CTA) {
                        
                    } label: {
                        Text("Continue")
                            .font(.SpenceKit.SansHeadlineFont)
                    }
                } else {
                    if !authViewModel.isVerificationSent {
                        ExpandingButton(.CTA) {
                            authViewModel.sendVerificationCode(phoneNumber: "+1\(phone_number)")
                        } label: {
                            Text("Get Verification Code")
                                .font(.SpenceKit.SansHeadlineFont)
                        }
                    } else {
                        ExpandingButton(.CTA) {
                            authViewModel.verifyCode(verificationCode: verification_code)
                        } label: {
                            Text("Verify Code")
                                .font(.SpenceKit.SansHeadlineFont)
                        }
                    }
                }
            }.padding([.horizontal, .bottom], SpenceKit.Constants.padding16)
                .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    SignUp(authViewModel: AuthViewModel())
}
