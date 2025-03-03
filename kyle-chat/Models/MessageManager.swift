//
//  MessageManager.swift
//  kyle-chat
//
//  Created by lmafia on 2025/2/25.
//

import SwiftUI

/// 消息状态
enum MessageStatus: String {
    case normal = "normal"
    case generating = "generating"
}


/// 消息结构
struct Message {
    let type: MessageType
    let content: String
    let timestamp: Date
    var status: MessageStatus
    
    init(type: MessageType, content: String, timestamp: Date, status: MessageStatus) {
        self.type = type
        self.content = content
        self.timestamp = timestamp
        self.status = status
    }
}

/// 消息管理器
class MessageManager: ObservableObject {
    static let shared = MessageManager()
    
    /// 消息列表
    @Published private(set) var messages: [Message] = [
        Message(type: .assistant, content: "你好！我是 Kyle，一个 AI 助手。我可以帮你回答问题、编写代码，或者进行日常对话。", timestamp: Date(), status: .normal)
    ]
    
    /// API管理器
    private let apiManager = APIManager.shared
    
    private init() {}
    
    /// 添加新消息
    /// - Parameters:
    ///   - type: 消息类型
    ///   - content: 消息内容
    ///   - status: 消息状态
    func addMessage(_ type: MessageType, _ content: String, status: MessageStatus = .normal) {
        DispatchQueue.main.async {
            self.messages.append(Message(type: type, content: content, timestamp: Date(), status: status))
        }
    }
    
    /// 发送消息到OpenAI
    /// - Parameter content: 消息内容
    func sendMessageToAI(_ content: String) async throws {
        addMessage(.user, content)
        addMessage(.assistant, "正在生成回复...", status: .generating)
        
        do {
            let response = try await apiManager.sendMessage(content)
            DispatchQueue.main.async {
                if let lastIndex = self.messages.lastIndex(where: { $0.type == .assistant && $0.status == .generating }) {
                    self.messages.remove(at: lastIndex)
                }
                self.addMessage(.assistant, response)
            }
        } catch APIError.missingAPIKey {
            addMessage(.system, "请先设置OpenAI API密钥")
        } catch {
            addMessage(.system, "发送消息失败：\(error.localizedDescription)")
        }
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
