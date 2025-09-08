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
                    BubbleIconView(state: .normal)
                    BubbleIconView(state: .inactive)
                    BubbleIconView(state: .scan)
                    BubbleIconView(state: .fold)
                }
                Text("状态切换")
                BubbleIconView(state: selectedState)
                Picker("选择状态", selection: $selectedState.animation(.easeInOut(duration: 0.3))) {
                    Text("正常").tag(BubbleState.normal)
                    Text("透明").tag(BubbleState.inactive)
                    Text("扫描").tag(BubbleState.scan)
                    Text("折叠").tag(BubbleState.fold)
                    Text("菜单").tag(BubbleState.menu)
                }.pickerStyle(.segmented)
            }
            .padding(.horizontal)
        }
        .foregroundStyle(.white)
    }
}

/// 悬浮球对外公开所有状态的 UI
struct BubbleView: View {
    let state: BubbleState
    
    var body: some View {
        if state == .menu {
            BubbleMenuView()
                .transition(.blurReplace)
        } else {
            BubbleIconView(state: state)
        }
    }
}

/// 悬浮球基础球形 UI
struct BubbleIconView: View {
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
        default:
            EmptyView()
        }
    }
}

struct BubbleMenuView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(width: 100, height: 160)
            .foregroundStyle(.black.opacity(0.7))
    }
}

#Preview {
    BubbleStateUIView()
}

#Preview("Menu") {
    ZStack {
        Image(.bgPhone)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        BubbleMenuView()
    }
}
