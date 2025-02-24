//
//  CodeBlockView.swift
//  kyle-chat
//
//  Created by lmafia on 2025/2/25.
//

import SwiftUI

/// 代码块显示组件
struct CodeBlockView: View {
    let code: String
    let language: String?
    
    @StateObject private var themeManager = ThemeManager.shared
    @State private var isCopied = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 顶部工具栏
            HStack {
                if let lang = language {
                    Text(lang)
                        .font(.caption)
                        .foregroundColor(themeManager.colors.foreground.opacity(0.6))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(themeManager.colors.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Button(action: {
                    let pasteboard = NSPasteboard.general
                    pasteboard.clearContents()
                    pasteboard.setString(code, forType: .string)
                    withAnimation {
                        isCopied = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            isCopied = false
                        }
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                        Text(isCopied ? "已复制" : "复制")
                    }
                    .font(.caption)
                    .foregroundColor(themeManager.colors.foreground.opacity(0.6))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(themeManager.colors.secondary.opacity(0.1))
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
            
            // 代码内容
            ScrollView(.horizontal, showsIndicators: false) {
                Text(code)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(themeManager.colors.foreground)
                    .textSelection(.enabled)
                    .padding(12)
            }
        }
        .padding(8)
        .background(themeManager.colors.secondary.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(themeManager.colors.secondary.opacity(0.1), lineWidth: 1)
        )
    }
}

#Preview {
    CodeBlockView(
        code: "func example() {\n    print(\"Hello, World!\")\n}",
        language: "swift"
    )
    .padding()
}