//
//  ContentView.swift
//  SwiftUI_Double_Slider
//
//  Created by MladenMikic on 19.07.2023..
//

import SwiftUI

struct ContentView: View {

    @State var sliderPosition: ClosedRange<Float> = 6...12

    var body: some View {
        VStack {
            RangedSliderView(value: $sliderPosition, bounds: 0...24, viewConfig: .init(sliderHeight: 6,
                                                                                       sliderColor: .blue,
                                                                                       sliderBackgroundColor: .gray,
                                                                                       sliderDotBackgroundColor: .white,
                                                                                       sliderThumbSize: .init(width: 12,
                                                                                                              height: 12)))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
