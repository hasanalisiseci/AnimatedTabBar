//
//  ContentView.swift
//  AnimatedTabBar
//
//  Created by Hasan Ali Şişeci on 18.12.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    @State var selectedTab = "home"
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    //Location For each curve
    @State var xAxis: CGFloat = 0
    
    @Namespace var animation
    
    var body: some View {
        ZStack (alignment: Alignment(horizontal: .center, vertical: .bottom)){
            TabView(selection: $selectedTab){
                Color("color1")
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("home")
                    
                Color("color2")
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("box")
                    
                Color.purple
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("bell")
                    
                Color.blue
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("message")

            }
            
            //Custom tab bar
            HStack() {
                ForEach(tabs,id: \.self) { image in
                    GeometryReader { reader in
                        Button(action: {
                            withAnimation(.spring()) {
                                selectedTab = image
                                xAxis = reader.frame(in: .global).minX
                            }
                        }, label: {
                            Image(image)
                                //boyutlandırma methodları uygulayacağımız için öncesinde resizable methodunu uyguluyoruz.
                                .resizable()
                                //Kullanacağımız resimlerin renderingMode'da template modu ile görüntünün tüm saydam olmayan kısımlarını ayarlayabileceğimiz bir renk ayarlarız. Default'u siyahtır.
                                .renderingMode(.template)
                                //sırada görünümümüzün boyutlarını belirtilen en boy oranıyla sınırlayan bir method ekliyoruz.
                                .aspectRatio(contentMode: .fit)
                                //Frame ile belirtilen boyutta görünmez bir çerçeve içine konumlandırıyoruz.
                                .frame(width: 25, height: 25)
                                //foregroundColor ile görünümde görüntülenen ön plandaki öğelerin rengini ayarlar.
                                .foregroundColor(selectedTab == image ? getColor(image: image) : Color.gray)
                                //padding, sistem tarafından hesaplanan bir dolgu miktarı ile belirtilen kenar girintilerinin içine dolduran bir görünüm.
                                .padding(selectedTab == image ? 15 : 0)
                                //arka plan rengi ile opaklığını atadık. Ardından bu arka plan renginin şeklini belirledik
                                .background(Color.white.opacity(selectedTab == image ? 1 : 0).clipShape(Circle()))
                                //matchedGeometryEffect, iki görünüm arasındaki konumu ve boyutu hesaplayabilen yeni bir SwiftUI efektidir.
                                .matchedGeometryEffect(id: image, in: animation)
                                //resmimizin konumlandırmasını koşula göre belirliyoruz.
                                .offset(x: selectedTab == image ? (reader.frame(in: .global).minX-reader.frame(in: .global).midX) : 0, y: selectedTab == image ? -50 : 0)
                            })
                        //onAppear fonksiyonu görünüm göründüğünde gerçekleştirilecek bir eylem ekler.
                        .onAppear(perform: {
                            if image == tabs.first {
                                xAxis = reader.frame(in: .global).minX
                            }
                        })
                    }
                    .frame(width: 25, height: 30)
                    if image != tabs.last{
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal,30)
            .padding(.vertical)
            .background(Color.white.clipShape(CustomShape(xAxis: xAxis)).cornerRadius(12))
            .padding(.horizontal)
            //Bottom edge
            .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        }
        //Görünümün önerilen alanını, ekranın güvenli alanlarının dışına uzanacak şekilde değiştirir.
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    //getting image colors
    func getColor(image: String) -> Color {
        switch image {
        case "home":
            return Color("color1")
        case "box":
            return Color("color2")
        case "bell":
            return Color.purple
        case "message":
            return Color.blue
        default:
            return Color.blue
            
        }
    }
}

var tabs = ["home","box","bell","message"]

struct CustomShape : Shape {
    
    var xAxis : CGFloat
    
    //Animating path
    
    var animatableData: CGFloat {
        get{ return xAxis }
        set{ xAxis = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path {path in
            path.move(to: CGPoint(x:0,y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))

            let center = xAxis
            path.move(to: CGPoint(x: center-50, y: 0))
            
            
            let to1 = CGPoint(x: center, y: 35)
            let control1 = CGPoint(x: center-25, y: 0)
            let control2 = CGPoint(x: center-25, y: 35)
            
            let to2 = CGPoint(x: center + 50, y: 0)
            let control3 = CGPoint(x: center+25, y: 35)
            let control4 = CGPoint(x: center+25, y: 0)
            
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}
