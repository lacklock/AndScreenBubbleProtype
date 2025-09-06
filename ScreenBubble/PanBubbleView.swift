//
//  PanBubbleView.swift
//  ScreenBubble
//
//  Created by 卓同学 on 2025/9/6.
//

import SwiftUI

struct PanBubbleView: View {
    @StateObject private var stateManager = BubbleStateManager()

    var body: some View {
        ZStack {
            Color.clear.background {
                Image(.bgPhone)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            VStack {
                Spacer()
                HStack {
                    Text("位置:")
                    Picker("", selection: $stateManager.position) {
                        Text("固定").tag(BubblePostion.fixed)
                        Text("自动悬浮").tag(BubblePostion.floating)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 240)
                }
            }
            .foregroundStyle(.white)
            .padding()
            ScreenBubbleView(stateManager: stateManager)
        }
    }
}

#Preview {
    PanBubbleView()
}
