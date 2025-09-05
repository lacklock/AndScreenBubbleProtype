//
//  ScreenBubbleView.swift
//  ScreenBubble
//
//  Created by 卓同学 on 2025/9/5.
//

import SwiftUI

enum BubbleState {
    case normal
    case inactive
    case scan
    case fold
    case menu
}

/// 管理悬浮球交互和 UI
struct ScreenBubbleView: View {
    @State private var selectedState: BubbleState = .normal

    var body: some View {
        BubbleView(state: selectedState)
    }
}

struct ScreenBubblePreview: View {
    
    var body: some View {
        ZStack {
            Image(.bgPhone)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                ScreenBubbleView()
            }
        }
    }
}

#Preview {
    ScreenBubblePreview()
}
