//
//  ThemeManager.swift
//  kyle-chat
//
//  Created by lmafia on 2025/2/25.
//

import SwiftUI

/// 主题类型
enum ThemeType: String {
    case light = "light"
    case dark = "dark"
    case system = "system"
}

/// 主题颜色
struct ThemeColors {
    let background: Color
    let foreground: Color
    let primary: Color
    let secondary: Color
    let accent: Color
    
    // 亮色主题颜色
    static let light = ThemeColors(
        background: Color("BackgroundLight"),
        foreground: Color("ForegroundLight"),
        primary: Color("PrimaryLight"),
        secondary: Color("SecondaryLight"),
        accent: Color.accentColor
    )
    
    // 暗色主题颜色
    static let dark = ThemeColors(
        background: Color("BackgroundDark"),
        foreground: Color("ForegroundDark"),
        primary: Color("PrimaryDark"),
        secondary: Color("SecondaryDark"),
        accent: Color.accentColor
    )
}

/// 主题管理器
class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: ThemeType = .system {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "AppTheme")
            updateThemeColors()
        }
    }
    
    @Published var colors: ThemeColors = .light
    private var appearanceObserver: NSKeyValueObservation?
    
    private init() {
        // 从 UserDefaults 读取保存的主题设置
        if let savedTheme = UserDefaults.standard.string(forKey: "AppTheme"),
           let theme = ThemeType(rawValue: savedTheme) {
            self.currentTheme = theme
            // 根据当前主题设置颜色
            self.colors = ThemeManager.getThemeColors(for: currentTheme)
        }
        
        // 监听系统主题变化
        appearanceObserver = NSApplication.shared.observe(\NSApplication.effectiveAppearance) { [weak self] _, _ in
            self?.updateThemeColors()
        }
    }
    
    /// 切换主题
    func toggleTheme() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch currentTheme {
            case .light:
                currentTheme = .dark
            case .dark:
                currentTheme = .system
            case .system:
                currentTheme = .light
            }
        }
    }
    
    /// 更新主题颜色
    private func updateThemeColors() {
        withAnimation(.easeInOut(duration: 0.3)) {
            colors = ThemeManager.getThemeColors(for: currentTheme)
        }
    }
    
    /// 获取主题颜色
    private static func getThemeColors(for theme: ThemeType) -> ThemeColors {
        switch theme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return isDarkMode ? .dark : .light
        }
    }
    
    /// 检查系统是否为暗色模式
    private static var isDarkMode: Bool {
        return NSApplication.shared.effectiveAppearance.bestMatch(from: [NSAppearance.Name.darkAqua, NSAppearance.Name.aqua]) == NSAppearance.Name.darkAqua
    }
}