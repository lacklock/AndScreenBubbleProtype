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

enum BubbleGestureEvent {
    case tap
    case panStart
    case panEnd
}

class BubbleStateManager: ObservableObject {
    @Published var state: BubbleState = .normal
    private var gestureEvent: BubbleGestureEvent? = nil

    func updateEvent(_ event: BubbleGestureEvent) {
        gestureEvent = event
    }
    
    func toggleMenuState() {
        if state == .menu {
            self.state = .normal
        } else {
            self.state = .menu
        }
    }
}

/// 管理悬浮球交互和 UI
struct ScreenBubbleView: View {
    @ObservedObject var stateManager: BubbleStateManager

    var body: some View {
        if stateManager.state == .menu {
            BubbleMenuView()
                .transition(.blurReplace)
        } else {
            BubbleView(state: stateManager.state)
        }
    }
}

struct ScreenBubblePreview: View {
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
                ScreenBubbleView(stateManager: stateManager)
                Spacer()
                HStack {
                    Button("菜单切换") {
                        withAnimation {
                            stateManager.toggleMenuState()
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(.bottom, 16)
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    ScreenBubblePreview()
}
