//
//  BubbleStateView.swift
//  ScreenBubble
//
//  Created by 卓同学 on 2025/9/4.
//

import SwiftUI

struct BubbleStateView: View {
    @State private var selectedState: BubbleState = .normal
    
    var body: some View {
        ZStack {
            Image(.bgPhone)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Text("静态 UI")
                HStack(spacing: 12) {
                    BubbleView(state: .normal)
                    BubbleView(state: .inactive)
                    BubbleView(state: .scan)
                }
                Text("状态切换")
                BubbleView(state: selectedState)
                Picker("选择状态", selection: $selectedState.animation(.easeInOut(duration: 0.3))) {
                    Text("正常").tag(BubbleState.normal)
                    Text("透明").tag(BubbleState.inactive)
                    Text("扫描").tag(BubbleState.scan)
                }.pickerStyle(.segmented)
            }
            .padding(.horizontal)
        }
        .foregroundStyle(.white)
    }
}

struct BubbleView: View {
    let state: BubbleState
    
    var body: some View {
        switch state {
        case .normal, .inactive:
            Image(.bubbleDefautl)
                .resizable()
                .frame(
                    width: state == .normal ? 56 : 44,
                    height: state == .normal ? 56 : 44
                )
                .opacity(state == .normal ? 1.0 : 0.6)
        case .scan:
            Image(.bubbleScan)
                .resizable()
                .frame(width: 44, height: 44)
        }

    }
}

enum BubbleState {
    case normal
    case inactive
    case scan
}


#Preview {
    BubbleStateView()
}
