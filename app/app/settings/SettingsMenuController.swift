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

class SettingsMenuController: UIViewController{
    
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
    
    //MARK: spotify button outlets
    @IBOutlet var spotifyLogOut: UIButton!
    @IBOutlet var spotifyLogIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //highlight previously used buttons
        highlightActiveButton();
        
        //make design button circled
        shapeDesignButton(defaultDesignButton);
        shapeDesignButton(blueDesignButton);
        shapeDesignButton(greenDesignButton);
        shapeDesignButton(redDesignButton);
        
        disableSpotifyLogOut()
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
    
    //MARK: Location Buttons
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
    
    //MARK: Spotify functions
    func disableSpotifyLogOut(){
        if((Spotify.shared.player?.initialized)!==false){
            spotifyLogOut.isEnabled = false;
        }
    }
    
    @IBAction func spotifyLogoutPressed(_ sender: Any) {
        Spotify.shared.logOut()
        normalizeButton(spotifyLogOut)
        normalizeButton(spotifyLogIn)
        spotifyLogIn.setTitle("Anmelden", for: UIControlState.normal)
    }
    
    @IBAction func spotifyLoginPressed(_ sender: Any) {
       if UIApplication.shared.openURL(Spotify.shared.loginUrl!) {
            if Spotify.shared.auth.canHandle(Spotify.shared.auth.redirectURL) {
                spotifyLogIn.setTitle("Angemeldet", for: UIControlState.normal)
                highlightClickedButton(spotifyLogIn)
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
        //highlight mode
        if(UserDefaults.standard.integer(forKey: "mode") == 1){
            atHomeClicked(self)
        }else if(UserDefaults.standard.integer(forKey: "mode") == 0){
            onRoadClicked(self)
        }else{
            activateGPS(self)
        }
        
        if(Spotify.shared.player?.initialized)!{
            highlightClickedButton(spotifyLogIn)
            spotifyLogIn.setTitle("Angemeldet", for: UIControlState.normal)
        }
    }
}

