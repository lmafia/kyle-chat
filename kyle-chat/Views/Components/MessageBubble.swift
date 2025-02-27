//
//  MessageBubble.swift
//  kyle-chat
//
//  Created by lmafia on 2025/2/25.
//

import SwiftUI

/// 消息类型
enum MessageType {
    case user
    case assistant
}

/// 消息气泡组件
struct MessageBubble: View {
    let type: MessageType
    let content: String
    let timestamp: Date
    
    @StateObject private var themeManager = ThemeManager.shared
    
    private var bubbleColor: Color {
        switch type {
        case .user:
            return themeManager.colors.primary
        case .assistant:
            return themeManager.colors.secondary
        }
    }
    
    private var alignment: HorizontalAlignment {
        type == .user ? .trailing : .leading
    }
    
    var body: some View {
        VStack(alignment: alignment) {
            HStack(spacing: 0) {
                if type == .assistant {
                    Image(systemName: "brain")
                        .foregroundColor(themeManager.colors.accent)
                        .imageScale(.large)
                        .frame(width: 32, height: 32)
                }
                
                Text(content)
                    .foregroundColor(themeManager.colors.foreground)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(bubbleColor.opacity(0.1))
                    .cornerRadius(16)
                    .frame(maxWidth: 500, alignment: type == .user ? .trailing : .leading)
                
                if type == .user {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(themeManager.colors.accent)
                        .imageScale(.large)
                        .frame(width: 32, height: 32)
                }
            }
            .frame(maxWidth: .infinity, alignment: type == .user ? .trailing : .leading)
            .padding(.horizontal, 8)
            
            Text(timestamp, style: .time)
                .font(.caption2)
                .foregroundColor(themeManager.colors.foreground.opacity(0.6))
                .padding(.horizontal, 12)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    VStack {
        MessageBubble(type: .user, content: "这是用户发送的消息", timestamp: Date())
        MessageBubble(type: .assistant, content: "这是助手回复的消息", timestamp: Date())
    }
}
