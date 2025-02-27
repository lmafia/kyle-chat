//
//  MessageListView.swift
//  kyle-chat
//
//  Created by lmafia on 2025/2/25.
//

import SwiftUI

/// 消息列表视图
struct MessageListView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var messageManager = MessageManager.shared
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(messageManager.messages.indices, id: \.self) { index in
                        let (type, content, timestamp) = messageManager.messages[index]
                        MessageBubble(type: type, content: content, timestamp: timestamp)
                            .id(index)
                    }
                }
                .padding()
                .onChange(of: messageManager.messages.count) { _,_ in
                    withAnimation(.easeOut(duration: 0.3)) {
                        proxy.scrollTo(messageManager.messages.count - 1, anchor: .bottom)
                    }
                }
            }
            .background(themeManager.colors.background)
            .scrollIndicators(.visible)
        }
    }
}

#Preview {
    MessageListView()
        .frame(width: 400, height: 600)
}
