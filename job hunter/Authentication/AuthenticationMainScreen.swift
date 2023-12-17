import SwiftUI
import UIKit

struct AuthenticationMainScreen: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                SignInView()
                VStack(spacing: 10) {
                    NavigationLink("No Account? Sign up here") {
                        SignUpEmailView()
                    }
                    NavigationLink("Forgot Password?") {
                        ResetPasswordView()
                    }
                }
            }
        }
    }
}

struct AuthButton: View {
    var label: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(20)
        }
    }
}


#Preview {
    AuthenticationMainScreen()
}
