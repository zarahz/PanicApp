//
//  SettingsController.swift
//  app
//
//  Created by Zarah Zahreddin on 18.05.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SettingsMenuController: UIViewController, CLLocationManagerDelegate, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    //MARK: delegate
    var settingsDelegate: SettingsProtocol!
    
    //MARK: Design button outlets
    @IBOutlet var defaultDesignButton: UIButton!
    @IBOutlet var blueDesignButton: UIButton!
    @IBOutlet var greenDesignButton: UIButton!
    @IBOutlet var redDesignButton: UIButton!
    
    //MARK: Location Button outlets
    @IBOutlet var homeLocationButton: UIButton!
    
    //MARK: Mode button outlets
    @IBOutlet var onRoadMode: UIButton!
    @IBOutlet var atHomeMode: UIButton!
    @IBOutlet var GPSMode: UIButton!
    
    //MARK: spotify
    @IBOutlet var login: UIButton!
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    //MARK: location
    var userPosition: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded menu");
        
        highlightActiveButton();
        
        //init spotify
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsMenuController.updateAfterFirstLogin), name: nil,                                        object: nil)
        
        //make design button circled
        shapeDesignButton(defaultDesignButton);
        shapeDesignButton(blueDesignButton);
        shapeDesignButton(greenDesignButton);
        shapeDesignButton(redDesignButton);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Mode Click Handler
    @IBAction func atHomeClicked(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "mode")
        Location.shared.stopGPS()
        UserDefaults.standard.set(1, forKey: "mode")
        highlightClickedButton(atHomeMode)
        normalizeButton(onRoadMode)
        normalizeButton(GPSMode)
        setupNavigationBar()
    }
    
    @IBAction func onRoadClicked(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "mode")
        Location.shared.stopGPS()
        UserDefaults.standard.set(0, forKey: "mode")
        highlightClickedButton(onRoadMode)
        normalizeButton(atHomeMode)
        normalizeButton(GPSMode)
        setupNavigationBar()
    }
    
    @IBAction func activateGPS(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "mode")
        Location.shared.trackLocations(setCurrentPositionHome: false);
        UserDefaults.standard.set(-1, forKey: "mode")
        normalizeButton(homeLocationButton)
        normalizeButton(atHomeMode)
        normalizeButton(onRoadMode)
        highlightClickedButton(GPSMode)
    }
    
    @IBAction func openMap(_ sender: Any) {
        activateGPS(self);
    }
    
    @IBAction func homeLocationClicked(_ sender: Any) {
        Location.shared.trackLocations(setCurrentPositionHome: true)
        
        normalizeButton(homeLocationButton)
        normalizeButton(atHomeMode)
        normalizeButton(onRoadMode)
        highlightClickedButton(GPSMode)
    }
    
    //MARK: Design Button functions
    func shapeDesignButton(_ button:UIButton){
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
    }
    
    @IBAction func defaultWallpaper(_ sender: Any) {
        UserDefaults.standard.set("background", forKey: "background")
        settingsDelegate.changeBackground()
    }
    @IBAction func blueWallpaper(_ sender: Any) {
        UserDefaults.standard.set("backgroundBlue", forKey: "background")
        settingsDelegate.changeBackground()
    }
    @IBAction func greenWallpaper(_ sender: Any) {
        UserDefaults.standard.set("backgroundGreen", forKey: "background")
        settingsDelegate.changeBackground()
    }
    @IBAction func redWallpaper(_ sender: Any) {
        UserDefaults.standard.set("backgroundRed", forKey: "background")
        settingsDelegate.changeBackground()
    }
    
    //MARK: Spotify Functions
    func setup(){
        SPTAuth.defaultInstance().clientID = "50c794cf3c2e40888e3b43cd8c3556ee";
        SPTAuth.defaultInstance().redirectURL = URL(string:"SpotifySDKDemo://panic.app");
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistReadPrivateScope];
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL();
    }
    
    @objc func updateAfterFirstLogin () {
        if let sessionObj:AnyObject = UserDefaults.standard.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
        }
    }
    
    func initializePlayer(authSession:SPTSession){
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("logged in")
        self.player?.playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
    
    @IBAction func spotifyLoginPressed(_ sender: Any) {
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                // To do - build in error handling
            }
        }
    }
    
    //MARK: Helper functions
    func adjustTextSize(_ button:UIButton){
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = NSTextAlignment.center
    }
    
    func highlightClickedButton(_ button:UIButton){
        button.setTitleColor(UIColor(red: 111.0/255.0, green: 127.0/255.0, blue: 166.0/255.0,alpha:1), for: .normal);
    }
    
    func normalizeButton(_ button:UIButton){
        button.setTitleColor(UIColor.black, for: .normal);
        button.alpha = 0.8;
    }
    
    func highlightActiveButton(){
        if(UserDefaults.standard.integer(forKey: "mode") == 1){
            atHomeClicked(self)
        }else if(UserDefaults.standard.integer(forKey: "mode") == 0){
            onRoadClicked(self)
        }else{
            activateGPS(self)
        }
    }
}

