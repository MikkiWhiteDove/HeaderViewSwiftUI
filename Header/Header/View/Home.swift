//
//  Home.swift
//  Header
//
//  Created by Mishana on 02.12.2022.
//

import SwiftUI

struct Home: View {
    
    @State var offsetY: CGFloat = 0
    @State var showSearchBar: Bool = false
    
    var body: some View {
        GeometryReader{ proxy in
            let safeAreaTop = proxy.safeAreaInsets.top
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    HeaderView(safeAreaTop)
                        .offset(y: -offsetY)
                        .zIndex(1)
                    
                    VStack{
                        ForEach(1...10, id: \.self){_ in
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.blue.gradient)
                                .frame(height: 200)
                        }
                    }
                    .padding(15)
                    .zIndex(0)
                }
                .offset(coordinateSpace: .named("SCROLL")) { offset in
                    offsetY = offset
                    showSearchBar = (-offset > 80) && showSearchBar
                }
            }
            .coordinateSpace(name: "SCROLL")
            .edgesIgnoringSafeArea(.top)
        }
    }
    
    @ViewBuilder
    func HeaderView(_ safeAreaTop: CGFloat)->some View {
        let progress = -(offsetY/80)>1 ? -1 : (offsetY>0 ? 0 : (offsetY/80))
        VStack(spacing:15){
            HStack(spacing: 15){
                HStack(spacing: 8){
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                    TextField("Seatch", text: .constant(""))
                        .tint(.white)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.black)
                        .opacity(0.15)
                }
                ///
                .opacity(showSearchBar ? 1 : 1 + progress)
                
                Button{
                    
                } label: {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .background{
                            Circle()
                                .fill(.white)
                                .padding(-2)
                        }
                }
                .opacity(showSearchBar ? 0 : 1)
                .overlay {
                    if showSearchBar {
                        Button{
                            showSearchBar = false
                        }label: {
                            Image(systemName: "xmark")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            
            HStack(spacing:0){
                CustomButton("rectangle.portrait.and.arrow.forward", "Deposit"){
                    
                }
                CustomButton("dollarsign", "Withdraw"){
                    
                }
                CustomButton("qrcode", "QR Code"){
                    
                }
                CustomButton("qrcode.viewfinder", "Scanning"){
                    
                }
            }
            .padding(.top,10)
            //
            .padding(.horizontal, -progress * 50)
            .offset(y: progress * 65)
            ///
            .opacity(showSearchBar ? 0 : 1)
        }
        //
        .overlay(alignment: .topLeading, content: {
            Button{
                ///
                showSearchBar = true
            }label: {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            //
            .offset(x: 13, y: 10)
            ///
            .opacity(showSearchBar ? 0 : -progress)
        })
        ///
        .animation(.easeInOut(duration: 0.2), value: showSearchBar)
        //
        .environment(\.colorScheme, .dark)
        .padding([.horizontal, .bottom], 15)
        .padding(.top, safeAreaTop + 10)
        .background{
            Rectangle()
                .fill(.red.gradient)
                .padding(.bottom, -progress * 85)
        }
        
    }
    
    @ViewBuilder
    func CustomButton(_ simbolImage: String,_ title: String, onClick: @escaping()->())->some View{
        let progress = -(offsetY/40)>1 ? -1 : (offsetY>0 ? 0 : (offsetY/40))
        Button{
            
        }label: {
            VStack(spacing: 8){
                Image(systemName: simbolImage)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
                    .frame(width: 35, height: 35)
                    .background{
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(.white)
                    }
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            //
            .opacity(1+progress)
            .overlay{
                Image(systemName: simbolImage)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(-progress)
                    .offset(y: -10)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct OffsetKey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View{
    @ViewBuilder
    func offset(coordinateSpace: CoordinateSpace, completion: @escaping (CGFloat)->())->some View{
        self
            .overlay{
                GeometryReader{ proxy in
                    let minY = proxy.frame(in: coordinateSpace).minY
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self){value in
                            completion(value)
                        }
                }
            }
    }
}
