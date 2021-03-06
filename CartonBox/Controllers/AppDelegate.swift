//
//  AppDelegate.swift
//  CartonBox
//
//  Created by kay weng on 28/09/2017.
//  Copyright © 2017 kay weng. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import AWSCognito
import SnackKit
import AVFoundation

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isInitialized:Bool = false
    var loadingDisplay = sb.instantiateViewController(withIdentifier: loadingVC) as! LoadingController
    lazy var timer = Timer()
    var awsConfiguration:JSON!
    
    public var facebookUser:FacebookUser?
    public var cognitoUser:CognitoUser?
    public var cartonboxUser:User?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = UIColor.white
        
        self.awsConfiguration = FileIOHelper.readJSONFile(name: "awsconfiguration", type: "json")

        //Facebook delegate
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)

        //Audio Session
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.moviePlayback, options: AVAudioSession.CategoryOptions.allowAirPlay)
        }catch{
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        FBSDKAppEvents.activateApp()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface
        
        applicationLoadFacebookSession()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication] as! String!, annotation: options[.annotation])
    }
    
    func applicationDidBecomeActive(application: UIApplication!) {
        FBSDKAppEvents.activateApp()
    }
    
    //MARK: - Private Action
    func applicationLoadFacebookSession(){
        if let _ = FBSDKAccessToken.current() {
            self.facebookUser = FacebookUser.currentUser()
            
            showLoading(closure: { (hideLoading) in
                
                let group = DispatchGroup()
                group.enter()
                
                DispatchQueue.global().async {
                    self.loginAmazonCognito(completionHandler: { (error) in
                        
                        if let _ = error {
                            print(error!.localizedDescription)
                        }
                        
                        if let _ = self.cartonboxUser {
                            group.leave()
                            return
                        }
                        
                        self.loadCartonBoxUser(completionHandler: { (error) in
                            
                            if let _ = error {
                                print(error!.localizedDescription)
                            }
                            
                            group.leave()
                        })
                    })
                }
                
                group.wait()
                
                hideLoading()
            })
        }
    }
    
    fileprivate func loginAmazonCognito(completionHandler:AmazonClientCompletition?){
        AmazonCognitoManager.shared.loginAmazonCognito(token: self.facebookUser!.tokenString, successBlock: { (result) in
            completionHandler?(nil)
        }) { (error) in
            let _error = NSError(domain: AmazonErrorDomain.AWSCognitoErrorDomain.rawValue, code: CognitoError.cognitoLoginFailed.rawValue, userInfo: nil)
            
            completionHandler?(_error)
        }
    }
    
    fileprivate func loadCartonBoxUser(completionHandler:AmazonClientCompletition?){
        
        AmazonDynamoDBManager.shared.GetItem(User.self, hasKey: self.facebookUser!.userId, rangeKey: nil) { (result) in
            if let _ =  result {
                self.cartonboxUser = result as? User
                completionHandler?(nil)
            }else{
                let _error = NSError(domain: AmazonErrorDomain.AWSDynamoDBErrorDomain.rawValue, code: DynamoDBError.getItemFailed.rawValue, userInfo: nil)
                completionHandler?(_error)
            }
        }
    }
    
    @objc func showLoading(closure: @escaping (_ hiding:@escaping()->Void)->Void){
        //loading auto hide after 5 minutes
        self.timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(AppDelegate.hideLoading), userInfo: nil, repeats: true)
        
        window?.rootViewController?.present(self.loadingDisplay, animated: true, completion: {
            closure({
                self.hideLoading()
            })
        })
    }

    @objc func hideLoading(){
        self.loadingDisplay.dismiss(animated: true) {
            self.timer.invalidate()
            self.timer = Timer()
        }
    }
}

