//
//  AppDelegate.swift
//  FineDiner
//
//  Created by iOS Developer on 12/12/2021.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseAnalytics
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import IQKeyboardManager
import OneSignal
import GooglePlaces
import GoogleMaps
import Adjust



@main
// func logEvent(_ name: String, parameters: [String : Any]?)

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationBarAppearace = UINavigationBar.appearance()
    let googleClientId = "295387888589-62pg4l7keivi20lq1il05vuritg4qdns.apps.googleusercontent.com"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        navigationBarAppearace.isTranslucent = false
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().enableDebugging = true
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = true
      
    
        // Remove this method to stop OneSignal Debugging
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("ea046acc-4916-4bb3-8ae6-c7fe2bafaf4d")
        OneSignal.promptForPushNotifications(userResponse: { accepted in
          print("User accepted notifications: \(accepted)")
        })
//        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
//          AnalyticsParameterItemID: "id-\(title!)",
//          AnalyticsParameterItemName: title!,
//          AnalyticsParameterContentType: "cont",
//        ])
        GMSServices.provideAPIKey("AIzaSyChKreZq4LCP_t-dO_pPMzhZgBrhpeHTxM")
        GMSPlacesClient.provideAPIKey("AIzaSyChKreZq4LCP_t-dO_pPMzhZgBrhpeHTxM")
        let deviceState = OneSignal.getDeviceState()
        let pleyerId = deviceState?.userId
        let yourAppToken = "o7ruyf8w0mio"
        let environment = ADJEnvironmentProduction
        let adjustConfig = ADJConfig(appToken: yourAppToken,environment: environment)
        adjustConfig?.logLevel = ADJLogLevelVerbose
        Adjust.appDidLaunch(adjustConfig)
//        GIDSignIn.sharedInstance.clientID = googleClientId
//         GIDSignIn.sharedInstance.restorePreviousSignIn()

        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        
        
        
        return true
    }
    func application(_ app: UIApplication,open url: URL,options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        }
//    func application(_ app: UIApplication,open url: URL,options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//            return GIDSignIn.sharedInstance.handle(url)
//    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }
    



}

