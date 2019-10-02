//
//  ContentView.swift
//  CardMaker
//
//  Created by Zach Eriksen on 7/25/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import SwiftUI

enum CardPartType {
    case back
    case background
    case frame
    case pointBadge
}

enum CardStyle: String, CaseIterable {
    case grey_wood
    case ice
    case lava
    case sci_fi = "sci-fi"
    case sci_fi_02 = "sci-fi_02"
    case wood
    
    func image(forType partType: CardPartType) -> Image {
        switch partType {
        case .back:
            return Image("back_\(self.rawValue)")
        case .background:
            return Image("bg_\(self.rawValue)")
        case .frame:
            return Image("frame_\(self.rawValue)")
        case .pointBadge:
            return Image("slot_grey_wood")
        }
    }
}

struct CardImageView: View {
    @Binding var styleIndex: Int
    @State var rotationAngle: Double = 0#imageLiteral(resourceName: "0.png")
    
    var text: String = "I AM CARD"
    
    private var style: CardStyle {
        CardStyle.allCases[styleIndex]
    }
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    if self.rotationAngle > 90 && self.rotationAngle < 270 {
                        // Back
                        self.style.image(forType: .back)
                            .resizable()
                    } else {
                        // Front
                        self.style.image(forType: .background)
                            .resizable()
                        
                        self.style.image(forType: .frame)
                            .resizable()
                        // Place on the bottom right
                        self.style.image(forType: .pointBadge)
                            .scaleEffect(CGSize(width: 0.1, height: 0.1))
                            .position(x: geo.size.width - 60, y: geo.size.height - 60)
                            .padding(32)
                        
                        Text(self.text)
                        .position(x: geo.size.width - 60, y: geo.size.height - 60)
                    }
                }
                .rotation3DEffect(Angle(degrees: self.rotationAngle),
                                  axis: (x: 0, y: 1, z: 0))
            }
            Slider(value: $rotationAngle, from: 0, through: 360, by: 1)
        }
    }
}

struct ContentView: View {
    @State private var selectedStyleIndex: Int = 0
    
    var body: some View {
        VStack {
            Text("Card Maker")
            Picker(selection: $selectedStyleIndex, label: Text("Card Style")) {
                ForEach(0 ..< CardStyle.allCases.count) { (style) in
                    Text("\(CardStyle.allCases[style].rawValue)").tag(style)
                }
            }
            CardImageView(styleIndex: $selectedStyleIndex)
                .padding()
            
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
