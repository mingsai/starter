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
import SwiftUI

class SceneDelegate: UIResponder {
  var window: UIWindow?
}

extension SceneDelegate: UIWindowSceneDelegate {
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = scene as? UIWindowScene else { return }
    
    let window = UIWindow(windowScene: windowScene)

    // v1 - before adding environment variable    window.rootViewController = UIHostingController(rootView: ContentView())
    
    /***
     Two small steps do it all:

     You create the ContentView and append the value of the window variable.
     You pass that rootView variable to the UIHostingController instead of the old initializer.
     The environment method returns some View which basically means it’s taking your ContentView, shoving the value you pass into that view’s environment, and then returning the ContentView back to you. Any SwiftUI View which is presented from the ContentView will now also hold that value in its environment.

     If you create a new root view anywhere else, that root will not contain the environment values unless you explicitly pass them back in as well.***/
    let rootView = ContentView().environment(\.window, window)
    window.rootViewController = UIHostingController(rootView: rootView)

    self.window = window
    
    window.makeKeyAndVisible()
  }
}
