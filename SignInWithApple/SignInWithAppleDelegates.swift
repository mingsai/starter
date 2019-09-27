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
import AuthenticationServices
class SignInWithAppleDelegates: NSObject {
  /***
   Just a few changes:

  Store a new weak reference to the window.
  Add the UIWindow parameter as the first argument to the initializer.
  Store the passed-in value to the property.*
   ***/
  private let signInSucceeded: (Bool) -> Void
  private weak var window: UIWindow!
  
  init(window: UIWindow?, onSignedIn: @escaping (Bool) -> Void) {
    self.window = window
    self.signInSucceeded = onSignedIn
  }
}
class SignInWithAppleDelegatesv1: NSObject {
  private let signInSucceeded: (Bool) -> Void

  init(onSignedIn: @escaping (Bool) -> Void) {
    self.signInSucceeded = onSignedIn
  }
}

extension SignInWithAppleDelegates: ASAuthorizationControllerDelegate {
  private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
    /** There are a few things occurring here:

    Save the desired details and the Apple-provided user in a struct.
    Store the details into the iCloud keychain for later use.
    Make a call to your service and signify to the caller whether registration succeeded or not.
     
     Notice the usage of credential.user. This property contains the unique identifier that Apple assigned to the end-user. Utilize this value — not an email or login name — when you store this user on your server. The provided value will exactly match across all devices that the user owns. In addition, Apple will provide the user with the same value for all of the apps associated with your Team ID. Any app a user runs receives the same ID, meaning you already possess all their information on your server and don’t need to ask the user to provide it!
     **/
    let userData = UserData(email: credential.email!, name: credential.fullName!, identifier: credential.user)
    let keychain = UserDataKeychain()
    do {
      try keychain.store(userData)
      
    } catch {
      self.signInSucceeded(false)
    }
   
    do {
      let success = try WebApi.Register( user: userData, identityToken: credential.identityToken, authorizationCode: credential.authorizationCode )
      self.signInSucceeded(success)
    } catch {
      self.signInSucceeded(false)
    }
  }
  private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
    /**
     The code you place in this method will be very app-specific. If you receive a failure from your server telling you the user is not registered, you should query your keychain, using retrieve(). With the details from the returned UserData struct, you then re-attempt registration for the end user.
     ***/
    self.signInSucceeded(true)
   }
  private func signInWithUserAndPassword(credential: ASPasswordCredential) {
    /**Again, your implementation will be app-specific. But, you’ll want to call your server login and pass along the username and password. If the server fails to know about the user, you’ll need to run a full registration flow as you don’t possess any details available from the keychain for their email and name. */
    self.signInSucceeded(true)
  }
  //Note: Apple will only provide you the requested details on the first authentication.
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    switch authorization.credential {
    case let appleIdCredential as ASAuthorizationAppleIDCredential:
      debugPrint(#file, #line, appleIdCredential.debugDescription)
      /**
       In this code:

       If you receive details, you know it’s a new registration.
       Call your registration method once you receive details.
       Call your existing account method if you don’t receive details.
        **/
        if let _ = appleIdCredential.email, let _ = appleIdCredential.fullName { registerNewAccount(credential: appleIdCredential)
        } else {
          
          signInWithExistingAccount(credential: appleIdCredential)
        }

      break

    case let passwordCredential as ASPasswordCredential:
      /***The other possibility, when using Sign In with Apple, is the end user will select credentials which are already stored in the iCloud keychain for the site. I*/
      signInWithUserAndPassword(credential: passwordCredential)

      debugPrint(#file, #line, passwordCredential.debugDescription)

      break

    default:
      break
    }
  }
 
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    debugPrint(#file, #line, error.localizedDescription)
  }
}
extension SignInWithAppleDelegates: ASAuthorizationControllerPresentationContextProviding {
  /***The delegate just has a single method to implement that is expected to return the window, which shows the Sign In with Apple modal dialog.

**/
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.window
  }
}
