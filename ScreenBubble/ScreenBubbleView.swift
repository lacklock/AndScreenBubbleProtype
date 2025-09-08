//
//  ScreenBubbleView.swift
//  ScreenBubble
//
//  Created by 卓同学 on 2025/9/5.
//

import SwiftUI

/// 管理悬浮球交互和 UI
struct ScreenBubbleView: View {
    @ObservedObject var stateManager: BubbleStateManager
    @State private var screenSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            BubbleView(state: stateManager.state)
                .position(stateManager.currentPosition)
                .id("bubble-view") // 添加固定的 id
                .gesture(
                    DragGesture(coordinateSpace: .local)
                        .onChanged { value in
                            if !stateManager.isDragging {
                                print("pan start")
                                stateManager.startDragging()
                            }
                            stateManager.updatePosition(value.location)
                            print("panLoaction: \(value.location)")
                        }
                        .onEnded { _ in
                            print("pan end")
                            stateManager.endDragging(screenSize: geometry.size)
                        }
                )
            .simultaneousGesture(
                TapGesture()
                    .onEnded {
                        print("Tap end")
                        if !stateManager.isDragging {
                            stateManager.updateEvent(.tap)
                        }
                    }
            )
            .onAppear {
                screenSize = geometry.size
                print("screenSize: \(screenSize.width) \(screenSize.height)")
                // 初始化位置到屏幕右侧
                if stateManager.currentPosition == CGPoint(x: 100, y: 200) {
                    let initialX = geometry.size.width - 20 - 56.0/2.0 // 56 + 20 margin
                    let initialY = geometry.size.height / 2
                    stateManager.currentPosition = CGPoint(x: initialX, y: initialY)
                }
            }
            .onChange(of: geometry.size) { (_, newSize) in
                print("screenSize onChange: \(screenSize.width) \(screenSize.height)")
                screenSize = newSize
            }
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
            ScreenBubbleView(stateManager: stateManager)
        }
    }
}

#Preview {
    ScreenBubblePreview()
}
