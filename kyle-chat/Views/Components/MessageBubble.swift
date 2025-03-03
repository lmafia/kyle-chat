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
    case system
}

/// 消息气泡组件
struct MessageBubble: View {
    let type: MessageType
    let content: String
    let timestamp: Date
    let status: MessageStatus
    
    @StateObject private var themeManager = ThemeManager.shared
    @State private var isAnimating = false
    
    private var bubbleColor: Color {
        switch type {
        case .user:
            return themeManager.colors.primary
        case .assistant:
            return themeManager.colors.secondary
        case .system:
            return themeManager.colors.accent
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
                } else if type == .system {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(themeManager.colors.accent)
                        .imageScale(.large)
                        .frame(width: 32, height: 32)
                }
                
                HStack(spacing: 8) {
                    Text(content)
                        .foregroundColor(themeManager.colors.foreground)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(bubbleColor.opacity(0.15))
                        .cornerRadius(18)
                        .shadow(color: bubbleColor.opacity(0.1), radius: 2, x: 0, y: 1)
                        .frame(maxWidth: 500, alignment: type == .user ? .trailing : .leading)
                    
                    if status == .generating {
                        HStack(spacing: 4) {
                            ForEach(0..<3) { index in
                                Circle()
                                    .fill(themeManager.colors.accent)
                                    .frame(width: 6, height: 6)
                                    .opacity(isAnimating ? 0.2 : 1)
                                    .animation(
                                        .easeInOut(duration: 0.8)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                        value: isAnimating
                                    )
                            }
                        }
                        .padding(.trailing, 16)
                        .onAppear {
                            isAnimating = true
                        }
                    }
                }
                
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
        MessageBubble(type: .user, content: "这是用户发送的消息", timestamp: Date(), status: .generating)
        MessageBubble(type: .assistant, content: "这是助手回复的消息", timestamp: Date(), status: .normal)
    }
}
