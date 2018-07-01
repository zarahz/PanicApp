//
//  AppDelegate.swift
//  app
//
//  Created by Zarah Zahreddin on 24.04.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import UIKit
import ApiAI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    //rotation settings
    var enableAllOrientation = false
    
    //spotify var
    var auth = SPTAuth()
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if (enableAllOrientation == true){
            return UIInterfaceOrientationMask.allButUpsideDown
        }
        return UIInterfaceOrientationMask.portrait
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Spotify
        auth.redirectURL     = URL(string: "SpotifySDKDemo://panic.app")
            auth.sessionUserDefaultsKey = "current session"
        
        //Location
        Location.shared
        if(UserDefaults.standard.integer(forKey: "mode") == -1 && UserDefaults.standard.location(forKey: "homeLocation") != nil){
            Location.shared.setHomeLocation(location: UserDefaults.standard.location(forKey: "homeLocation")!)
        }
        
        //configure chatbot
        let configuration: AIConfiguration = AIDefaultConfiguration()
        configuration.clientAccessToken = "fc3346e375ea4d6fa885328284c52072"
        let apiai = ApiAI.shared()
        apiai?.configuration = configuration
        
        //set first screen
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if launchedBefore  {
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "NavigationController")
        } else {
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "TutorialController")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //spotify ONLY function
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // check if app can handle redirect URL
        if auth.canHandle(auth.redirectURL) {
            // handle callback in closure
            auth.handleAuthCallback(withTriggeredAuthURL: url, callback: { (error, session) in
                // handle error
                if error != nil {
                    print("error!")
                }
                // Add session to User Defaults
                let userDefaults = UserDefaults.standard
                let sessionData = NSKeyedArchiver.archivedData(withRootObject: session)
                userDefaults.set(sessionData, forKey: "SpotifySession")
                userDefaults.synchronize()
                // Tell notification center login is successful
                NotificationCenter.default.post(name: Notification.Name(rawValue: "loginSuccessfull"), object: nil)
            })
            return true
        }
        return false
    }



}

