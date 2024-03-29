//
//  job_hunterApp.swift
//  job hunter
//
//  Created by Qingyuan Ma on 9/24/23.
//

import SwiftUI
import Firebase
import FirebaseAppCheck


class MyAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
      if #available(iOS 14.0, *) {
        // Use App Attest provider on real devices.
        return AppAttestProvider(app: app)
      }
      else {
        return DeviceCheckProvider(app: app)
      }
      
  }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            print("AppDelegate running on preview")
            let providerFactory = AppCheckDebugProviderFactory()
            AppCheck.setAppCheckProviderFactory(providerFactory)
        } else {
            #if targetEnvironment(simulator)
            print("AppDelegate running on simulator")
            let providerFactory = AppCheckDebugProviderFactory()
            AppCheck.setAppCheckProviderFactory(providerFactory)
            return true
            #else
            print("AppDelegate running on production")
            let providerFactory = MyAppCheckProviderFactory()
            AppCheck.setAppCheckProviderFactory(providerFactory)
            #endif
        }
        #else
        AppCheck.setAppCheckProviderFactory(MyAppCheckProviderFactory())
        #endif
        return true
    }
}


@main
struct job_hunterApp: App {
    //register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
