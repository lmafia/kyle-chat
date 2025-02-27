//
//  MainView.swift
//  kyle-chat
//
//  Created by lmafia on 2025/2/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @State private var showSettings = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部工具栏
            HStack {
                Spacer()
                
                // 主题切换按钮
                Button(action: {
                    themeManager.toggleTheme()
                }) {
                    Image(systemName: themeManager.currentTheme == .light ? "sun.max.fill" : "moon.fill")
                        .foregroundColor(themeManager.colors.foreground)
                        .frame(width: 32, height: 32)
                        .background(themeManager.colors.background)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 4)
                .contentShape(Rectangle())
                .help("切换主题")
                .onHover{ isHovered in
                    if isHovered {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
                
                // 设置按钮
                Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(themeManager.colors.foreground)
                        .frame(width: 32, height: 32)
                        .background(themeManager.colors.background)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 8)
                .contentShape(Rectangle())
                .help("设置")
                .onHover { isHovered in
                    if isHovered {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
            }
            .frame(height: 40)
            .background(themeManager.colors.background)
            
            HSplitView {
                // 左侧聊天列表
                ChatListView()
                    .frame(minWidth: 200, maxWidth: 300)
                
                // 右侧聊天内容
                ChatContentView()
                    .frame(minWidth: 400)
            }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .background(themeManager.colors.background)
    }
}

// 聊天列表视图
struct ChatListView: View {
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        List {
            Text("聊天列表")
                .foregroundColor(themeManager.colors.foreground)
        }
        .listStyle(SidebarListStyle())
        .background(themeManager.colors.background)
        .scrollContentBackground(.hidden)
    }
}

// 聊天内容视图
struct ChatContentView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @State private var inputMessage = ""
    
    var body: some View {
        VStack {
            // 消息列表区域
            MessageListView()
            
            // 输入区域
            HStack(spacing: 12) {
                TextField("输入消息...", text: $inputMessage)
                    .foregroundStyle(themeManager.colors.foreground)
                    .textFieldStyle(.plain)
                    .tint(themeManager.colors.accent)
                    .environment(\.colorScheme, themeManager.currentTheme == .dark ? .dark : .light)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(themeManager.colors.secondary.opacity(0.1))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(themeManager.colors.secondary.opacity(0.2), lineWidth: 1)
                    )
                    .onSubmit {
                        guard !inputMessage.isEmpty else { return }
                        MessageManager.shared.addMessage(.user, inputMessage)
                        inputMessage = ""
                    }
                
                Button(action: {
                    guard !inputMessage.isEmpty else { return }
                    MessageManager.shared.addMessage(.user, inputMessage)
                    inputMessage = ""
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(themeManager.colors.accent)
                }
                .buttonStyle(.plain)
                .contentShape(Circle())
                .help("发送消息")
                .onHover { isHovered in
                    if isHovered {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(themeManager.colors.background)
    }
}


}
#Preview {
    MainView()
}
