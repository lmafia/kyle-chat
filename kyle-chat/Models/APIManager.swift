//
//  APIManager.swift
//  kyle-chat
//
//  Created by lmafia on 2025/2/25.
//

import SwiftUI

/// API管理器
class APIManager: ObservableObject {
    static let shared = APIManager()
    
    /// API密钥
    @Published private(set) var apiKey: String = ""
    
    /// 是否正在加载
    @Published private(set) var isLoading = false
    
    /// 选中的模型
    @Published var selectedModel = "gpt-4o-mini"
    
    /// 可用的模型列表
    let availableModels = ["gpt-4o-mini", "gpt-3.5-turbo", "gpt-4o"]
    
    private init() {
        if let savedKey = UserDefaults.standard.string(forKey: "OpenAIAPIKey") {
            self.apiKey = savedKey
        }
    }
    
    /// 设置API密钥
    /// - Parameter key: API密钥
    func setAPIKey(_ key: String) {
        apiKey = key
        UserDefaults.standard.set(key, forKey: "OpenAIAPIKey")
    }
    
    /// 验证API密钥
    /// - Returns: 是否有效
    func validateAPIKey() async -> Bool {
        guard !apiKey.isEmpty else {
            return false
        }
        
        await MainActor.run { isLoading = true }
        defer { Task { @MainActor in isLoading = false } }
        
        let url = URL(string: "https://api.openai.com/v1/models")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return false
            }
            return (200...299).contains(httpResponse.statusCode)
        } catch {
            return false
        }
    }
    
    /// 发送消息到OpenAI API
    /// - Parameter message: 用户消息
    /// - Returns: AI响应
    func sendMessage(_ message: String) async throws -> String {
        guard !apiKey.isEmpty else {
            print("[API Error] Missing API Key")
            throw APIError.missingAPIKey
        }
        
        await MainActor.run { isLoading = true }
        defer { Task { @MainActor in isLoading = false } }
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": selectedModel,
            "messages": [
                ["role": "user", "content": message]
            ],
            "temperature": 0.7
        ]
        
        print("[API Request] Sending message to OpenAI API")
        print("[API Request] Model: \(selectedModel)")
        print("[API Request] Message: \(message)")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("[API Error] Invalid response type")
            throw APIError.invalidResponse
        }
        
        print("[API Response] Status Code: \(httpResponse.statusCode)")
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorData = String(data: data, encoding: .utf8) {
                print("[API Error] Response: \(errorData)")
            }
            throw APIError.invalidResponse
        }
        
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = jsonResponse["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            print("[API Error] Failed to parse response data")
            throw APIError.invalidResponse
        }
        
        print("[API Success] Received response from OpenAI API")
        return content
    }
}

/// API错误
enum APIError: Error {
    case missingAPIKey
    case invalidResponse
    case networkError
}
