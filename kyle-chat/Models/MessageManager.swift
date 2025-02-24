//
//  MessageManager.swift
//  kyle-chat
//
//  Created by lmafia on 2025/2/25.
//

import SwiftUI

/// 消息管理器
class MessageManager: ObservableObject {
    static let shared = MessageManager()
    
    /// 消息列表
    @Published private(set) var messages: [(MessageType, String, Date)] = [
        (.assistant, "你好！我是 Kyle，一个 AI 助手。我可以帮你回答问题、编写代码，或者进行日常对话。", Date())
    ]
    
    private init() {}
    
    /// 添加新消息
    /// - Parameters:
    ///   - type: 消息类型
    ///   - content: 消息内容
    func addMessage(_ type: MessageType, _ content: String) {
        messages.append((type, content, Date()))
    }
    
    /// 清空消息
    func clearMessages() {
        messages.removeAll()
    }
    
    /// 删除指定索引的消息
    /// - Parameter index: 消息索引
    func removeMessage(at index: Int) {
        guard index >= 0 && index < messages.count else { return }
        messages.remove(at: index)
    }
}