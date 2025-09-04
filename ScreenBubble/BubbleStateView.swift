//
//  BubbleStateView.swift
//  ScreenBubble
//
//  Created by 卓同学 on 2025/9/4.
//

import SwiftUI

struct BubbleStateView: View {
    
    var body: some View {
        ZStack {
            Image(.bgPhone)
                .resizable()
                .scaledToFill()
            VStack {
                HStack(spacing: 12) {
                    BubbleView(state: .normal)
                    BubbleView(state: .inactive)
                }
            }
     
        }
    }
}

struct BubbleView: View {
    let state: BubbleState
    
    var body: some View {
        switch state {
        case .normal:
            Image(.bubbleDefautl)
                .resizable()
                .frame(width: 56, height: 56)
        case .inactive:
            Image(.bubbleDefautl)
                .resizable()
                .frame(width: 44, height: 44)
                .opacity(0.6)
        }
    }
    
    enum BubbleState {
        case normal
        case inactive
    }
}


#Preview {
    BubbleStateView()
}
