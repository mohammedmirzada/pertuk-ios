//
//  ContentView.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 04/05/2023.
//

import SwiftUI
import Network
import RealmSwift

let langStr = Locale.current.language.languageCode?.identifier

class WebStatus: ObservableObject {
    var statusCode = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    var loaded = false {
        willSet {
            objectWillChange.send()
        }
    }
    var error = false {
        willSet {
            objectWillChange.send()
        }
    }
    var isHidden = true {
        willSet {
            objectWillChange.send()
        }
    }
    init() {
        Push()
    }
    func Push() {
        let user = User()
        let db = Database()
        
        if (user.GetLanguage() != langStr){
            user.SetLibraryUpdateId(library_update_id: 0)
        }
        
        self.isHidden = false
        
        let url = URL(string: "https://programnas.com/control/template/php/api/library/tools/?API=\(user.API_AUTH)&tool=internet&system=ios&lang=\(langStr!)&library_update_id=\(user.GetLibraryUpdateId())&API_AUTH=\(user.API_AUTH)")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let urlstr = "tool=internet"
        request.httpBody = urlstr.data(using: .utf8)!
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async{
                if let response = response as? HTTPURLResponse {
                    self.statusCode = response.statusCode
                    if self.statusCode >= 200 && self.statusCode <= 299{
                        
                        self.loaded = true
                        self.isHidden = true
                        
                        var categories_bool = false
                        var books_bool = false
                        var authors_bool = false
                        
                        let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                        
                        let library_update_id = json?["library_update_id"] as? Int
                        
                        if(user.GetLibraryUpdateId() != library_update_id!){
                            
                            db.DeleteAll()
                            
                            if let data_categories = json?["categories"] as? [Any] {
                                for item in data_categories {
                                    if let object = item as? [String: Any] {
                                        let id = object["id"] as? Int ?? 0
                                        let name = object["name"] as? String ?? ""
                                        let image = object["image"] as? String ?? "seal.fill"
                                        db.SetCategories(id: id, name: name, image: image)
                                        categories_bool = true
                                    }
                                }
                            }
                            if let data_books = json?["books"] as? [Any] {
                                for item in data_books {
                                    if let object = item as? [String: Any] {
                                        let id = object["id"] as? Int ?? 0
                                        let name = object["name"] as? String ?? "N/A"
                                        let image = object["image"] as? String ?? ""
                                        let author_id = object["author_id"] as? Int ?? 0
                                        let category_ids = object["category_ids"] as? Int ?? 0
                                        let book1 = object["book1"] as? String ?? ""
                                        let book2 = object["book2"] as? String ?? ""
                                        let book3 = object["book3"] as? String ?? ""
                                        let book4 = object["book4"] as? String ?? ""
                                        let book5 = object["book5"] as? String ?? ""
                                        let book6 = object["book6"] as? String ?? ""
                                        let book7 = object["book7"] as? String ?? ""
                                        let book8 = object["book8"] as? String ?? ""
                                        let book9 = object["book9"] as? String ?? ""
                                        let book10 = object["book10"] as? String ?? ""
                                        let downloads = object["downloads"] as? Int ?? 0
                                        let views = object["views"] as? Int ?? 0
                                        db.SetBooks(id: id, name: name, image: image, author_id: author_id, category_ids: category_ids, book1: book1, book2: book2, book3: book3, book4: book4, book5: book5, book6: book6, book7: book7, book8: book8, book9: book9, book10: book10, views: views, downloads: downloads)
                                        books_bool = true
                                    }
                                }
                            }
                            if let data_authors = json?["authors"] as? [Any] {
                                for item in data_authors {
                                    if let object = item as? [String: Any] {
                                        let id = object["id"] as? Int ?? 0
                                        let name = object["name"] as? String ?? "N/A"
                                        let image = object["image"] as? String ?? ""
                                        db.SetAuthors(id: id, name: name, image: image)
                                        authors_bool = true
                                    }
                                }
                            }
                            
                            user.SetLibraryUpdateId(library_update_id: library_update_id!)
                            user.SetLanguage(language: langStr!)
                            
                        }
                        
                        if categories_bool && books_bool && authors_bool{
                            self.loaded = true
                            self.isHidden = true
                        }
                    }else{
                        self.loaded = false
                        self.error = true
                        self.isHidden = true
                    }
                }
            }
        }.resume()
    }
}

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}

extension View {
    @ViewBuilder func isHidden(_ isHidden: Bool) -> some View {
        if isHidden {
            self.hidden()
        } else {
            self
        }
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var adsViewModel: AdsViewModel
    @StateObject var networkMonitor = NetworkMonitor()
    @StateObject var webStatus = WebStatus()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack{
            VStack {
                if networkMonitor.isConnected && webStatus.statusCode >= 200 && webStatus.statusCode <= 299 && webStatus.loaded{
                    HStack(alignment: .center) {
                        Image("pertuk_logo").resizable().scaledToFit().frame(width: 149.0, height: 41.0, alignment: .center)
                        Spacer()
                        NavigationLink {
                            SearchView()
                        } label: {
                            Image(systemName: "magnifyingglass").symbolRenderingMode(.hierarchical)
                                .font(.system(size: 26)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        }.simultaneousGesture(TapGesture().onEnded{
                            adsViewModel.showInterstitial = true
                        })
                    }.padding(.bottom, 4.0)
                    TabView() {
                        HomeView()
                            .tabItem {
                                Image(systemName: "books.vertical.fill").symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 26)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            }
                        SettingsView()
                            .tabItem {
                                Image(systemName: "gearshape.fill").symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 26)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            }
                    }
                    .onAppear(){
                        UITabBar.appearance().isTranslucent = false
                    }.accentColor(colorScheme == .dark ? Color.white : Color.black)
                }else{
                    if webStatus.error {
                        VStack(alignment: .center){
                            Image(systemName: "exclamationmark.icloud.fill").symbolRenderingMode(.hierarchical)
                                .font(.system(size: 80)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            Text("Oops! It could be an error from our server or your network conection.").multilineTextAlignment(.center)
                            Button(action: {
                                webStatus.Push()
                                webStatus.objectWillChange.send()
                            }) {
                                Image(systemName: "arrow.clockwise.circle").symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 50)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            }.disabled(false).padding(.top, 50.0/*@END_MENU_TOKEN@*/)
                            if(webStatus.isHidden){
                                ProgressView().isHidden(true)
                            }else{
                                ProgressView().isHidden(false)
                            }
                        }
                    }else{
                        Image("splash").resizable().scaledToFit().padding(30)
                        ProgressView().scaleEffect(2)
                    }
                }
            }
            .padding()
        }.accentColor(Color("category_text_button")).toolbarRole(.editor).navigationViewStyle(.stack).navigationBarBackButtonHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
