//
//  HandshakeCard.swift
//  Handshake
//
//  Created by Spencer Steadman on 11/3/24.
//

import SwiftUI
import SpenceKit


struct HandshakeCard: View {
    @ObservedObject var user: User
    @Binding var design: Int
    @Binding var color: Color
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image("\(design)")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: .infinity)
                        .foregroundStyle(color)
                    Text("Handshake")
                        .font(.SpenceKit.SerifPrimaryTitleFont)
                        .serifBold(font: Font.SpenceKit.FontSkeleton.SerifPrimaryTitle,
                                   strokeColor: Color("Paper Beige"))
                        .foregroundStyle(Color("Paper Beige"))
                        .padding(.trailing, SpenceKit.Constants.padding4)
                        .padding(.bottom, SpenceKit.Constants.padding8)
                }
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text(user.name.isEmpty ? "" : user.name)
                            .font(.SpenceKit.SansXLargeTitleFont)
                            .fontWeight(.black)
                            .foregroundStyle(color)
                        Text("Hello, World—I'm \(user.name),\nand I'm ready to Handshake!")
                            .font(.SpenceKit.SansHeadlineFont)
                            .foregroundStyle(color)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: SpenceKit.Constants.spacing4) {
                        if !user.snapchat.isEmpty {
                            Image("snapchat")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .foregroundStyle(color)
                        }
                        
                        if !user.instagram.isEmpty {
                            Image("instagram")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .foregroundStyle(color)
                        }
                    }
                }
            }
        }.frame(width: 300, height: 400)
            .padding(SpenceKit.Constants.padding16)
            .background(Color("Paper Beige"))
            .clipShape(RoundedRectangle(cornerRadius: SpenceKit.Constants.cornerRadius8))
    }
}

struct HandshakeCardStatic: View {
    let user: User
    
    var body: some View {
        let color = Color(hex: user.handshakeCard.color)
        ZStack(alignment: .bottomLeading) {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image("\(min(user.handshakeCard.design, 3))")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: .infinity)
                        .foregroundStyle(color)
                    Text("Handshake")
                        .font(.SpenceKit.SerifPrimaryTitleFont)
                        .serifBold(font: Font.SpenceKit.FontSkeleton.SerifPrimaryTitle,
                                   strokeColor: Color("Paper Beige"))
                        .foregroundStyle(Color("Paper Beige"))
                        .padding(.trailing, SpenceKit.Constants.padding4)
                        .padding(.bottom, SpenceKit.Constants.padding8)
                }
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text(user.name.isEmpty ? "" : user.name)
                            .font(.SpenceKit.SansXLargeTitleFont)
                            .fontWeight(.black)
                            .foregroundStyle(color)
                        Text("Hello, World—I'm \(user.name),\nand I'm ready to Handshake!")
                            .font(.SpenceKit.SansHeadlineFont)
                            .foregroundStyle(color)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: SpenceKit.Constants.spacing4) {
                        if !user.snapchat.isEmpty {
                            Image("snapchat")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .foregroundStyle(color)
                        }
                        
                        if !user.instagram.isEmpty {
                            Image("instagram")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .foregroundStyle(color)
                        }
                    }
                }
            }
        }.frame(width: 300, height: 400)
            .padding(SpenceKit.Constants.padding16)
            .background(Color("Paper Beige"))
            .clipShape(RoundedRectangle(cornerRadius: SpenceKit.Constants.cornerRadius16))
    }
}

#Preview {
    HandshakeCardStatic(user: User(name: "spence", phoneNumber: "", bio: "", interests: [], songs: [], handshakeCard: .init(design: 0, color: "#FFFFFF"), instagram: " ", snapchat: " ", other: " "))
        .scaleEffect(0.3)
}
