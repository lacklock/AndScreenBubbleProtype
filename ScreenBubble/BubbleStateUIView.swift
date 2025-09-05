//
//  BubbleStateView.swift
//  ScreenBubble
//
//  Created by 卓同学 on 2025/9/4.
//

import SwiftUI

struct BubbleStateUIView: View {
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
                    BubbleView(state: .fold)
                }
                Text("状态切换")
                BubbleView(state: selectedState)
                Picker("选择状态", selection: $selectedState.animation(.easeInOut(duration: 0.3))) {
                    Text("正常").tag(BubbleState.normal)
                    Text("透明").tag(BubbleState.inactive)
                    Text("扫描").tag(BubbleState.scan)
                    Text("折叠").tag(BubbleState.fold)
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
                .transition(.blurReplace)
        case .scan:
            Image(.bubbleScan)
                .resizable()
                .frame(width: 44, height: 44)
                .transition(.blurReplace)
        case .fold:
            Circle()
                .foregroundStyle(.white)
                .opacity(0.7)
                .frame(width: 32, height: 32)
                .transition(.blurReplace)
        }
    }
}

enum BubbleState {
    case normal
    case inactive
    case scan
    case fold
}


#Preview {
    BubbleStateUIView()
}
