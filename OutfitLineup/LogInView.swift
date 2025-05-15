//
//  LogInView.swift
//  OutfitLineup
//
//  Created by Hendrix, Skyla (514100) on 5/6/25.
//

import SwiftUI
import Security

class KeychainHelper {
    static func save(key: String, data: Data) -> OSStatus {
        let query: CFDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query) // Remove old value if exists
        return SecItemAdd(query, nil)
    }

    static func load(key: String) -> Data? {
        let query: CFDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        return status == errSecSuccess ? dataTypeRef as? Data : nil
    }
}

struct LogInView: View {
    @State private var password = ""
    @State private var username = ""
    @State private var loginSuccess = false
    @State private var showError = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .bold()

                TextField("Username", text: $username)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                SecureField("Password", text: $password)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                Button("Log in") {
                    login()
                }

                if showError {
                    Text("Invalid login")
                        .foregroundColor(.red)
                }

                Button("Register") {
                    register()
                }

                // Hidden navigation link that activates when loginSuccess is true
                NavigationLink(destination: ContentView(), isActive: $loginSuccess) {
                    EmptyView()
                }
            }
            .padding()
        }
    }

    func login() {
        if let savedPasswordData = KeychainHelper.load(key: username),
           let savedPassword = String(data: savedPasswordData, encoding: .utf8),
           savedPassword == password {
            loginSuccess = true
            showError = false
        } else {
            loginSuccess = false
            showError = true
        }
    }

    func register() {
        guard let passwordData = password.data(using: .utf8) else {
            showError = true
            return
        }

        let status = KeychainHelper.save(key: username, data: passwordData)
        loginSuccess = (status == errSecSuccess)
        showError = !loginSuccess
    }
}

#Preview {
    LogInView()
}
