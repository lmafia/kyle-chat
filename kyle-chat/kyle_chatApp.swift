//
//  kyle_chatApp.swift
//  kyle-chat
//
//  Created by lmafia on 2025/2/25.
//

import SwiftUI

@main
struct kyle_chatApp: App {
    @StateObject private var userManager = UserManager()
    
    init() {
        // 仅在开发时使用，发布时记得删除这行
//        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
    var body: some Scene {
        WindowGroup {
            if userManager.isUsernameSet {
                MainView()
            } else {
                WelcomeView()
            }
        }
    }
}
