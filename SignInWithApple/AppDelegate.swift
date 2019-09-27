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

import UIKit
/***
 Runtime Checks
At any point during the lifetime of your app, the user can go into device settings and disable Sign In with Apple for your app. You’ll want to check, depending on the action to be performed, whether or not they are still signed in. Apple recommends you run this code:

let provider = ASAuthorizationAppleIDProvider()
provider.getCredentialState(forUserID: "currentUserIdentifier") { state, error in switch state { case .authorized: break case .revoked: break case .notFound: break
  }
}
 Apple has said that the getCredentialState(forUserId:) call is extremely fast. So you should run it during app startup and any time you need to ensure the user is still authenticated. I recommend you not run at app startup unless you must. Does your app really require a logged in or registered user for everything? Don’t require them to log in until they try to perform an action that actually requires being signed in. In fact, even the Human Interface Guidelines recommend this too!

 Remember that many users will uninstall a just downloaded app if the first thing they are asked to do is register.

 Instead, listen to the notification that Apple provides to know when a user has logged out. Simply listen for the ASAuthorizationAppleIDProvider.credentialRevokedNotification notification and take appropriate action.
 
 Logins Do not Scroll
 One downside to Sign In with Apple to keep in mind is that the window that iOS displays will not scroll! For most users that won’t matter, but it’s important to note. As the owner of the site that my app uses, for example, I have numerous logins. Not only do I have the app login itself, but I’ve got a login for the SQL database, for the PHP admin site, etc.

 If you’ve got too many logins, it’s possible end users won’t see what they actually need. Try to ensure that if you’re linking an app to a site that the site only has logins which will matter to the app. Don’t just bundle all your apps under a single domain.
 
 Where to Go From Here?
 You can download the completed project files by clicking the Download Materials button at the top or bottom of the tutorial.

 SignInWithAppleDelegates.swift currently returns a Boolean success, but you’ll likely want to use something more like Swift 5’s Result type so that you can return not only data from your server, but also custom error types on failure. Please see our video course, What’s New in Swift 5: Types if you’re not familiar with the Result type.

 We hope you enjoyed this tutorial, and if you have any questions or comments, please join the forum discussion below!

 Other Core APIs iOS & Swift Tutorials
 source:
 
 https://www.raywenderlich.com/4875322-sign-in-with-apple-using-swiftui
 
 ****/
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
}

