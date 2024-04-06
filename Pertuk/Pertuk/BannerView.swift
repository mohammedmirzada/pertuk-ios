import GoogleMobileAds
import SwiftUI
import UIKit

class BannerViewController: UIViewController, GADBannerViewDelegate {
    
    var bannerView: GADBannerView!
    @State var adFailed = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }

    func load() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-9877420063334339/9638976162"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        addBannerViewToView(bannerView)
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,attribute: .bottom,relatedBy: .equal,toItem: view.safeAreaLayoutGuide,attribute: .bottom,multiplier: 1,constant: 0),
             NSLayoutConstraint(item: bannerView,attribute: .centerX,relatedBy: .equal,toItem: view,attribute: .centerX,multiplier: 1,constant: 0)])
   }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        adFailed += 1
        if adFailed < 10{
            load()
        }
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
   
}

struct BannerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = BannerViewController
    
    func makeUIViewController(context: Context) -> BannerViewController {
        let vc = BannerViewController()
        // Do some configurations here if needed.
        return vc
    }
    
    func updateUIViewController(_ uiViewController: BannerViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
}
