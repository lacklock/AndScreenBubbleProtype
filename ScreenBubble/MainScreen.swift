//
//  MainScreen.swift
//  ScreenBubble
//
//  Created by 卓同学 on 2025/9/4.
//

import SwiftUI

struct MainScreen: View {
    
    var body: some View {
        NavigationStack {
            List(AppScreen.allCases) { screen in
                NavigationLink(value: screen) {
                    Text(screen.title)
                }
            }
            .navigationDestination(for: AppScreen.self) { screen in
                switch screen {
                case .bubbleUI:
                    BubbleStateUIView()
                case .bubbleState:
                    ScreenBubblePreview()
                }
            }
        }
    }
}


enum AppScreen: String, Identifiable, CaseIterable {
    case bubbleUI
    case bubbleState
    
    var title: String {
        switch self {
        case .bubbleUI:
            "悬浮球 UI"
        case .bubbleState:
            "悬浮球状态"
        }
    }

    var id: String { self.rawValue }
}

#Preview {
    MainScreen()
}
