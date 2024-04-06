//
//  PertukApp.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 04/05/2023.
//

import SwiftUI
import GoogleMobileAds
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
struct PertukApp: App {
    
    let adsVM = AdsViewModel.shared

    init(){
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [GADSimulatorID]
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(adsVM)
        }
    }
}
