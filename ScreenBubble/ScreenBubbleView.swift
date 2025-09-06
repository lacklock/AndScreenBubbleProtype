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

enum BubblePostion {
    case fixed
    case floating
}

class BubbleStateManager: ObservableObject {
    @Published var state: BubbleState = .normal
    @Published var position: BubblePostion = .floating
    private var gestureEvent: BubbleGestureEvent? = nil
    
    // 是否开启自动折叠状态
    var isAutoFold: Bool = false
    // 添加定时器引用
    private var inactiveTimer: DispatchWorkItem?
    private var foldTimer: DispatchWorkItem?
    
    // 添加动画控制方法
    func setState(_ newState: BubbleState, animated: Bool = true) {
        if animated {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.state = newState
            }
        } else {
            self.state = newState
        }
    }

    func updateEvent(_ event: BubbleGestureEvent) {
        gestureEvent = event
        if event == .tap {
            isAutoFold = false
            setState(.normal) // 使用新的动画方法
        }
    }
    
    func toggleMenuState() {
        if state == .menu {
            setState(.normal)
        } else {
            setState(.menu)
        }
    }

    private func stopAutoFold() {
        isAutoFold = false
        inactiveTimer?.cancel()
        foldTimer?.cancel()
        inactiveTimer = nil
        foldTimer = nil
    }

    func startAutoFold() {
        isAutoFold = true
        
        // 取消之前的定时器（如果存在）
        inactiveTimer?.cancel()
        foldTimer?.cancel()
        
        // 创建新的定时器
        inactiveTimer = DispatchWorkItem { [weak self] in
            guard let self = self, self.isAutoFold else { return }
            self.setState(.inactive) // 使用动画方法
        }
        
        foldTimer = DispatchWorkItem { [weak self] in
            guard let self = self, self.isAutoFold else { return }
            self.setState(.fold) // 使用动画方法
        }
        
        // 自动折叠：2秒后进入 inactive，再 3 秒后进入 fold
        if let inactiveTimer = inactiveTimer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: inactiveTimer)
        }
        if let foldTimer = foldTimer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: foldTimer)
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
            VStack(spacing: 16) {
                Spacer()
                ScreenBubbleView(stateManager: stateManager)
                Spacer()
                Button("菜单模式切换") {
                    withAnimation {
                        stateManager.toggleMenuState()
                    }
                }
                .buttonStyle(.bordered)
                HStack {
                    Button("开启自动折叠") {
                        stateManager.startAutoFold()
                    }
                    .buttonStyle(.bordered)
                    .padding(.trailing, 32)
           
                    Button("点击事件") {
                        stateManager.updateEvent(.tap)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(16)
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    ScreenBubblePreview()
}
