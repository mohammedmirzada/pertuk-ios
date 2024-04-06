//
//  Interstital.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 12/06/2023.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

class AdsManager: NSObject, ObservableObject {
    
    private struct AdMobConstant {
        static let interstitial1ID = "ca-app-pub-9877420063334339/6051084944"
    }
    
    final class Interstitial: NSObject, GADFullScreenContentDelegate, ObservableObject {

        private var interstitial: GADInterstitialAd?
        
        override init() {
            super.init()
            requestInterstitialAds()
        }

        func requestInterstitialAds() {
            let request = GADRequest()
            request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                GADInterstitialAd.load(withAdUnitID: AdMobConstant.interstitial1ID, request: request, completionHandler: { [self] ad, error in
                    if let error = error {
                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                        return
                    }
                    interstitial = ad
                    interstitial?.fullScreenContentDelegate = self
                })
            })
        }
        
        func seondRequestInterstitialAds() {
            let request = GADRequest()
            request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                GADInterstitialAd.load(withAdUnitID: AdMobConstant.interstitial1ID, request: request, completionHandler: { ad, error in
                    if let error = error {
                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                        return
                    }
                })
            })
        }
        
        func showAd() {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let root = windowScene.windows.last?.rootViewController {
                
                if let fullScreenAds = interstitial {
                    fullScreenAds.present(fromRootViewController: root)
                } else {
                    print("not ready")
                }
            }
        }
        
        func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
            
        }
        
        func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {}
        
        func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
            //requestInterstitialAds()
            seondRequestInterstitialAds()
        }
        
        func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            //requestInterstitialAds()
        }
            
        func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {}
            
        func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {}
        
    }
    
    
}


class AdsViewModel: ObservableObject {
    static let shared = AdsViewModel()
    @Published var interstitial = AdsManager.Interstitial()
    @Published var showInterstitial = false {
        didSet {
            if showInterstitial {
                interstitial.showAd()
                showInterstitial = false
            } else {
                //interstitial.requestInterstitialAds()
            }
        }
    }
}
