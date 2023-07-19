//
//  RangeSliderView.swift
//  SwiftUI_Double_Slider
//
//  Created by MladenMikic on 19.07.2023..
//

import SwiftUI



public struct RangedSliderView: View {

    let currentValue: Binding<ClosedRange<Float>>
    let sliderBounds: ClosedRange<Int>

    let viewConfig: Self.ViewConfig

    public init(value: Binding<ClosedRange<Float>>, bounds: ClosedRange<Int>, viewConfig: RangedSliderView.ViewConfig) {
        self.currentValue = value
        self.sliderBounds = bounds
        self.viewConfig = viewConfig
    }

    public var body: some View {
        GeometryReader { geomentry in
            sliderView(sliderSize: geomentry.size)
        }
    }

    @ViewBuilder private func sliderView(sliderSize: CGSize) -> some View {

        let sliderViewYCenter = sliderSize.height / 2

        ZStack {

            RoundedRectangle(cornerRadius: viewConfig.sliderHeight)
                .fill(viewConfig.sliderBackgroundColor)
                .frame(height: viewConfig.sliderHeight)

            ZStack {

                let sliderBoundDifference = sliderBounds.count
                let stepWidthInPixel = CGFloat(sliderSize.width) / CGFloat(sliderBoundDifference)

                // Calculate Left Thumb initial position
                let leftThumbLocation: CGFloat = currentValue.wrappedValue.lowerBound == Float(sliderBounds.lowerBound)
                    ? 0
                    : CGFloat(currentValue.wrappedValue.lowerBound - Float(sliderBounds.lowerBound)) * stepWidthInPixel

                // Calculate right thumb initial position
                let rightThumbLocation = CGFloat(currentValue.wrappedValue.upperBound) * stepWidthInPixel

                // Path between both handles
                lineBetweenThumbs(from: .init(x: leftThumbLocation, y: sliderViewYCenter), to: .init(x: rightThumbLocation, y: sliderViewYCenter))

                // Left Thumb Handle
                let leftThumbPoint = CGPoint(x: leftThumbLocation, y: sliderViewYCenter)
                thumbView(position: leftThumbPoint, value: Float(currentValue.wrappedValue.lowerBound))
                    .highPriorityGesture(DragGesture().onChanged { dragValue in

                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(0, dragLocation.x), sliderSize.width)

                        let newValue = Float(sliderBounds.lowerBound) + Float(xThumbOffset / stepWidthInPixel)

                        // Stop the range thumbs from colliding each other
                        if newValue < currentValue.wrappedValue.upperBound {
                            currentValue.wrappedValue = newValue...currentValue.wrappedValue.upperBound
                        }
                    })

                // Right Thumb Handle
                thumbView(position: CGPoint(x: rightThumbLocation, y: sliderViewYCenter), value: currentValue.wrappedValue.upperBound)
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(CGFloat(leftThumbLocation), dragLocation.x), sliderSize.width)

                        var newValue = Float(xThumbOffset / stepWidthInPixel) // convert back the value bound
                        newValue = min(newValue, Float(sliderBounds.upperBound))

                        // Stop the range thumbs from colliding each other
                        if newValue > currentValue.wrappedValue.lowerBound {
                            currentValue.wrappedValue = currentValue.wrappedValue.lowerBound...newValue
                        }
                    })

            }
        }
    }

    @ViewBuilder func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }.stroke(viewConfig.sliderColor, lineWidth: viewConfig.sliderHeight)
    }

    @ViewBuilder func thumbView(position: CGPoint, value: Float) -> some View {
        ZStack {
            Circle()
                .frame(width: viewConfig.sliderThumbSize.width, height: viewConfig.sliderThumbSize.height)
                .foregroundColor(.blue)
                .contentShape(Rectangle())
                .cornerRadius(2)
                .padding(2)
                .background(viewConfig.sliderDotBackgroundColor)
                .cornerRadius(viewConfig.sliderThumbSize.width)
        }
        .position(x: position.x, y: position.y)
    }
}
