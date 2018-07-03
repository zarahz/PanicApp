
//
//  SpotifySingleton.swift
//  app
//
//  Created by Zarah Zahreddin on 02.07.18.
//  Copyright © 2018 Zarah Zahreddin. All rights reserved.
//

import Foundation

class Spotify: NSObject, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    static let shared = Spotify()
    
    //MARK: spotify
    @IBOutlet var login: UIButton!
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    
    var playing: Bool!
    
    override init(){
        super.init()
        //init spotify
        playing = false
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAfterFirstLogin), name: nil,                                        object: nil)
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
            playing = true;
            self.player!.login(withAccessToken: authSession.accessToken)
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // after a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        self.player?.playSpotifyURI("spotify:user:spotify:playlist:37i9dQZF1DX4sWSpwq3LiO", startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if (error != nil) {
                print("playing!")
            }
        })
    }
    
    func pausePlayer(){
        if playing == false{
            self.player?.setIsPlaying(true,callback: {
                (error) in
                if (error != nil) {
                    print("playing!")
                }})
        }else{
            self.player?.setIsPlaying(false, callback: {
                (error) in
                if (error != nil) {
                    print("paused!")
                }})
        }
        self.playing = !self.playing
    }
    
    func changeVolumeTo(volume:Double){
        if playing == true{
            self.player?.setVolume(volume, callback: {
                (error) in
                if (error != nil) {
                    print("playing!")
                }})
        }}
    
    func startStopPlayer(play:Bool){
            self.player?.setIsPlaying(play, callback: nil)
        self.playing = play
    }
}
