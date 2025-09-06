//
//  BubbleState.swift
//  ScreenBubble
//
//  Created by 卓同学 on 2025/9/6.
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
    // 添加位置相关属性
    @Published var currentPosition: CGPoint = CGPoint(x: 100, y: 200)
    @Published var isDragging: Bool = false
    
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
    
    // 添加拖动相关方法
    func startDragging() {
        isDragging = true
        updateEvent(.panStart)
        state = .scan
        stopAutoFold() // 拖动时停止自动折叠
    }
    
    func updatePosition(_ newPosition: CGPoint) {
        currentPosition = newPosition
    }
    
    func endDragging(screenSize: CGSize) {
        isDragging = false
        
        updateEvent(.panEnd)
        
        // 拖动结束时才使用动画恢复状态
        withAnimation(.easeInOut(duration: 0.2)) {
            state = .normal
        }
        
        // 如果是浮动模式，拖动结束后可以重新开启自动折叠
        if position == .floating {
            snapToEdge(screenSize: screenSize)
        } else {
            
        }
        
        // 1 秒钟后悬浮球停到指定位置后开始自动折叠
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        //            self.startAutoFold()
        //        }
    }
    
    // 自动吸附到屏幕边缘的方法
    func snapToEdge(screenSize: CGSize) {
        guard position == .floating else { return }
        
        let bubbleSize: CGFloat = 56
        let margin: CGFloat = 20
        
        // 计算到左右边缘的距离
        let distanceToLeft = currentPosition.x
        let distanceToRight = screenSize.width - currentPosition.x
        
        // 吸附到最近的边缘
        let newX = distanceToLeft < distanceToRight ? margin : screenSize.width - bubbleSize - margin
        
        // 确保Y坐标在安全范围内
        let minY = margin + bubbleSize/2
        let maxY = screenSize.height - margin - bubbleSize/2
        let newY = max(minY, min(maxY, currentPosition.y))
        
        // 使用延迟确保之前的动画完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                self.currentPosition = CGPoint(x: newX, y: newY)
            }
        }
    }
}
