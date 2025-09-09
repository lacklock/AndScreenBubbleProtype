//
//  GestureView.swift
//  ScreenBubble
//
//  Created by 卓同学 on 2025/9/8.
//

import SwiftUI

struct GestureScreen: View {
    @StateObject private var stateManager = BubbleStateManager()
    @State private var msg: String = ""
    
    private let startDate = Date()
    
    var body: some View {
        ZStack {
            Color.clear.background {
                Image(.bgPhone)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            VStack(alignment: .leading) {
                Spacer()
                Text("手势识别: \(msg)")
            }
            .foregroundStyle(.white)
            .padding()
            GeometryReader { geometry in
                BubbleIconView(state: stateManager.state)
                    .position(x: geometry.size.width/2.0, y:geometry.size.height/2.0)
                    .gesture(
                        DragGesture(coordinateSpace: .local)
                            .onChanged { value in
                                print("Pan start")
                                self.msg = "Pan start \(String(format: "%.3f", Date().timeIntervalSince(startDate)))"
                            }
                            .onEnded { _ in
                                print("Pan end")
                                self.msg = "Pan end \(String(format: "%.3f", Date().timeIntervalSince(startDate)))"
                            }
                    )
                    .simultaneousGesture(
                        TapGesture()
                            .onEnded {
                                print("Tap end")
                                self.msg = "Tap \(String(format: "%.3f", Date().timeIntervalSince(startDate)))"
                            }
                    )
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .onEnded { _ in
                                print("Long press end")
                                self.msg = "Long Press \(String(format: "%.3f", Date().timeIntervalSince(startDate)))"
                                stateManager.updateEvent(.longPress)
                            }
                    )
            }
        }
    }
}

#Preview {
    GestureScreen()
}
