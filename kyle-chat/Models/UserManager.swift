import Foundation

class UserManager: ObservableObject {
    @Published var username: String = ""
    private let userDefaults = UserDefaults.standard
    private let usernameKey = "kyle_chat_username"
    
    init() {
        loadUsername()
    }
    
    func saveUsername(_ name: String) {
        username = name
        userDefaults.set(name, forKey: usernameKey)
    }
    
    private func loadUsername() {
        if let savedName = userDefaults.string(forKey: usernameKey) {
            username = savedName
        }
    }
    
    var isUsernameSet: Bool {
        return !username.isEmpty
    }
}
