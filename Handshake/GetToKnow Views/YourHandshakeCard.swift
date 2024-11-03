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
    @State private var design = 0
    @State private var color: Color = Color.blue
    @State private var isColorPicker = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                Spacer().frame(height: SpenceKit.Constants.padding16)
                
                Text("Design Your Handshake Card.")
                    .font(.SpenceKit.SerifXLargeTitleFont)
                
                Spacer().frame(height: SpenceKit.Constants.padding16)
                
                HStack(alignment: .bottom) {
                    Spacer()
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
                                
                                VStack {
                                    if !user.snapchat.isEmpty {
                                        Image("snapchat")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 24)
                                            .foregroundStyle(color)
                                    }
                                    
                                    if !user.instagram.isEmpty {
                                        Image("instagram")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 24)
                                            .foregroundStyle(color)
                                    }
                                }
                            }
                        }
                    }.frame(width: 300, height: 400)
                        .padding(SpenceKit.Constants.padding16)
                        .background(Color("Paper Beige"))
                        .clipShape(RoundedRectangle(cornerRadius: SpenceKit.Constants.cornerRadius8))
                    Spacer()
                }
            }.padding(.horizontal, SpenceKit.Constants.padding16)
                .padding(.bottom, 200)
        }
        .ignoresSafeArea()
        .safeAreaInset(edge: .bottom) {
            VStack {
                HStack {
                    ZStack {
                        ColorPicker("", selection: $color)
                            .scaleEffect(1.8)
                            .labelsHidden()
                    }.frame(width: 64, height: 64)
                        .background(Color.SpenceKit.Background)
                        .clipShape(Circle())
                    
                    HStack {
                        Spacer()
                        ForEach(0..<4, id: \.self) { index in
                            Button {
                                design = index
                            } label: {
                                if design == index {
                                    Image("\(index)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 40)
                                        .foregroundStyle(Color.SpenceKit.LayerForeground)
                                } else {
                                    Image("\(index)")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 40 - SpenceKit.Constants.borderWidth * 2)
                                        .foregroundStyle(Color.SpenceKit.Background)
                                        .stroke(color: Color.SpenceKit.Border, width: SpenceKit.Constants.borderWidth)
                                }
                            }
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .background(Color.SpenceKit.Background)
                    .clipShape(RoundedRectangle(cornerRadius: SpenceKit.Constants.cornerRadius24))
                    .stroke(color: Color.SpenceKit.Border, width: SpenceKit.Constants.borderWidth)
                    .clipShape(RoundedRectangle(cornerRadius: SpenceKit.Constants.cornerRadius24 + SpenceKit.Constants.borderWidth))
                }
                .padding(.horizontal, SpenceKit.Constants.padding16)
                
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

#Preview {
    @Previewable @State var selection = 0
    YourHandshakeCard(user: User.blank, selection: $selection)
}
