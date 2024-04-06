//
//  WebViewView.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 09/05/2023.
//

import SwiftUI
import WebKit

struct ActivityIndicatorView: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingView<Content>: View where Content: View {
    @Binding var isShowing: Bool
    var content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                
                VStack {
                    ProgressView().scaleEffect(2).progressViewStyle(CircularProgressViewStyle(tint: Color("programnas_blue")))
                }.opacity(self.isShowing ? 1 : 0)
                
            }
        }
    }
}

class WebViewModel: ObservableObject {
    @Published var isLoading: Bool = true
}

struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel
    let webView = WKWebView()
    var url: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self.viewModel)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        private var viewModel: WebViewModel
        
        init(_ viewModel: WebViewModel) {
            self.viewModel = viewModel
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.viewModel.isLoading = false
        }
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<WebView>) { }
    
    func makeUIView(context: Context) -> UIView {
        self.webView.navigationDelegate = context.coordinator

        if let url = URL(string: url) {
            self.webView.load(URLRequest(url: url))
        }

        return self.webView
    }
}

struct WebViewView: View {
    @StateObject var model = WebViewModel()
    @EnvironmentObject var adsViewModel: AdsViewModel
    var url: String
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: self.$model.isLoading) {
                WebView(viewModel: self.model, url: url).simultaneousGesture(TapGesture().onEnded{
                    adsViewModel.showInterstitial = true
                })
            }
        }.toolbarRole(.editor)
    }
}

struct WebViewView_Previews: PreviewProvider {
    static var previews: some View {
        WebViewView(url: "https://programnas.com/library/")
    }
}
