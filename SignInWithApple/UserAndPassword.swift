/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

/***
 Web Credentials
 If you have a website dedicated to your app, you can go a little further and handle web credentials as well. If you take a peek in UserAndPassword.swift, you’ll see a call to SharedWebCredential(domain:), which currently sends an empty string to the constructor. Replace that with the domain of your website.

 Now, log into your website and at the root of the site create a directory called .well-known. In there, create a new file called apple-app-site-association and paste in the following JSON:

 { "webcredentials": { "apps": [ "ABCDEFGHIJ.com.raywenderlich.SignInWithApple" ]
     }
 }
 Note: Make sure there is no extension on the filename.
 
  You’ll want to replace the ABCDEFGHIJ with your team’s 10-character Team ID. You can find your Team ID at https://developer.apple.com/account under the Membership tab. You’ll also need to make the bundle identifier match whatever you’re using for the app.

 By taking those steps, you’ve linked Safari’s stored login details with your app’s login details. They will now be available for Sign in with Apple.

 When the user manually enters a username and password the credentials will be stored so that they’re available for later use.

 ***/
struct UserAndPassword: View {
  @State var username: String = ""
  @State var password: String = ""
  @State var showingAlert = false
  @State var alertText: String = ""

  var body: some View {
    VStack {
      TextField("Username", text: $username)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .textContentType(.username)
        .autocapitalization(.none)
        .disableAutocorrection(true)

      SecureField("Password", text: $password)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .textContentType(.password)

      Button(action: signInTapped) {
        Text("Log In")
          .foregroundColor(Color.white)
      }
      .alert(isPresented: $showingAlert) {
        Alert(title: Text(alertText))
      }
    }
    .padding()
  }

  private func signInTapped() {
    let ws = CharacterSet.whitespacesAndNewlines

    let account = username.trimmingCharacters(in: ws)
    let pwd = password.trimmingCharacters(in: ws)

    guard !(account.isEmpty || pwd.isEmpty) else {
      alertText = "Please enter a username and password."
      showingAlert = true
      return
    }

    // Putting the user/pwd into the shared web credentials ensures that
    // it's available for your browser based logins if you haven't implemented
    // the web version of Sign in with Apple but also then makes it available
    // for future logins via Sign in with Apple on your iOS devices.
    SharedWebCredential(domain: "")
      .store(account: account, password: password) { result in
        guard case .failure = result else { return }

        self.alertText = "Failed to store password."
        self.showingAlert = true
    }
  }
}

#if DEBUG
struct UserAndPassword_Previews: PreviewProvider {
  static var previews: some View {
    UserAndPassword()
  }
}
#endif
