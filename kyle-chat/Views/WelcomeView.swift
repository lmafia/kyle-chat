import SwiftUI

struct WelcomeView: View {
    @StateObject private var userManager = UserManager()
    @StateObject private var themeManager = ThemeManager.shared
    @State private var username: String = ""
    @State private var isNameEntered = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("欢迎使用 Kyle Chat")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("开始之前，请输入您的名字")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                TextField("请输入您的名字", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 300)
                    .padding(.top, 20)
                
                Button(action: {
                    if !username.isEmpty {
                        userManager.saveUsername(username)
                        isNameEntered = true
                    }
                }) {
                    Text("保存")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 160, height: 44)
                }
                .environment(\.colorScheme, themeManager.currentTheme == .dark ? .dark : .light)
                .frame(width: 160, height: 44) // 设置按钮整体尺寸
                .background(username.isEmpty ? Color.gray : Color.accentColor)
                .cornerRadius(10)
                .disabled(username.isEmpty)
                
            }
            .padding(40)
            .frame(minWidth: 400, minHeight: 300)
            .navigationDestination(isPresented: $isNameEntered) {
                MainView()
            }
        }
    }
}
#Preview {
    WelcomeView()
}
