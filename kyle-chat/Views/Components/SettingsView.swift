import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var userManager = UserManager()
    @StateObject private var apiManager = APIManager.shared
    @State private var username: String = ""
    @State private var apiKey: String = ""
    @State private var isAPIKeyVisible: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部标题栏
            HStack {
                Text("设置")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(themeManager.colors.foreground.opacity(0.6))
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(themeManager.colors.background)
            
            // 设置内容
            ScrollView {
                VStack(spacing: 20) {
                    // 个人资料设置
                    SettingsSection(title: "个人资料") {
                        VStack(alignment: .leading, spacing: 12) {
                            TextField("用户名", text: $username)
                                .textFieldStyle(.roundedBorder)
                                .onChange(of: username) {_, newValue in
                                    userManager.saveUsername(newValue)
                                }
                        }
                    }
                    
                    // API 设置
                    SettingsSection(title: "API 设置") {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                if isAPIKeyVisible {
                                    TextField("OpenAI API Key", text: $apiKey)
                                        .textFieldStyle(.roundedBorder)
                                } else {
                                    SecureField("OpenAI API Key", text: $apiKey)
                                        .textFieldStyle(.roundedBorder)
                                }
                                
                                Button(action: {
                                    isAPIKeyVisible.toggle()
                                }) {
                                    Image(systemName: isAPIKeyVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(themeManager.colors.foreground.opacity(0.6))
                                }
                                .buttonStyle(.plain)
                            }
                            .onChange(of: apiKey) {_, newValue in
                                apiManager.setAPIKey(newValue)
                            }
                            
                            Text("请输入您的 OpenAI API Key，它将被安全地存储在本地")
                                .font(.caption)
                                .foregroundColor(themeManager.colors.foreground.opacity(0.6))
                            
                            Button(action: {
                                Task {
                                    if await apiManager.validateAPIKey() {
                                        NSAlert.showInfo("验证成功", "API 密钥有效")
                                    } else {
                                        NSAlert.showError("验证失败", "API 密钥无效或网络连接出现问题")
                                    }
                                }
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.shield")
                                    Text("测试 API 密钥")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(.plain)
                            .background(themeManager.colors.secondary.opacity(0.1))
                            .cornerRadius(6)
                            .disabled(apiManager.isLoading)
                            .opacity(apiManager.isLoading ? 0.6 : 1)
                            
                            Picker("模型", selection: $apiManager.selectedModel) {
                                ForEach(apiManager.availableModels, id: \.self) { model in
                                    Text(model).tag(model)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity)
                            .background(themeManager.colors.secondary.opacity(0.1))
                            .cornerRadius(6)
                            
                            Text("选择要使用的 OpenAI 模型")
                                .font(.caption)
                                .foregroundColor(themeManager.colors.foreground.opacity(0.6))
                        }
                    }
                }
                .padding()
            }
        }
        .frame(width: 400, height: 500)
        .background(themeManager.colors.background)
        .onAppear {
            username = userManager.username
            apiKey = UserDefaults.standard.string(forKey: "OpenAIAPIKey") ?? ""
        }
    }
}

// 设置分区组件
struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    @StateObject private var themeManager = ThemeManager.shared
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(themeManager.colors.foreground)
            
            content
                .padding()
                .background(themeManager.colors.secondary.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

#Preview {
    SettingsView()
}
