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
                case .bubbleState:
                    BubbleStateUIView()
                }
            }
        }
    }
}


enum AppScreen: String, Identifiable, CaseIterable {
    case bubbleState
    
    var title: String {
        switch self {
        case .bubbleState:
            "悬浮球 UI"
        }
    }

    var id: String { self.rawValue }
}

#Preview {
    MainScreen()
}
