//
//  NSAlert+Extensions.swift
//  kyle-chat
//
//  Created by lmafia on 2025/2/25.
//

import AppKit

extension NSAlert {
    /// 显示错误提示
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 错误信息
    static func showError(_ title: String, _ message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .critical
        alert.addButton(withTitle: "确定")
        alert.runModal()
    }
    
    /// 显示信息提示
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 提示信息
    static func showInfo(_ title: String, _ message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "确定")
        alert.runModal()
    }
}