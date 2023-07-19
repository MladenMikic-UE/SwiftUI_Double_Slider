//
//  RangedSliderView+ViewConfig.swift
//  SwiftUI_Double_Slider
//
//  Created by MladenMikic on 19.07.2023.
//

import Foundation
import SwiftUI

public extension RangedSliderView {
    struct ViewConfig {
        let sliderHeight: CGFloat
        /// The color of the slider range part.
        let sliderColor: Color
        /// The color of the background of the slider which shows the inactive part.
        let sliderBackgroundColor: Color
        /// The color of the ring around the slider dot. Clear means none.
        let sliderDotBackgroundColor: Color
        let sliderThumbSize: CGSize
    }
}
