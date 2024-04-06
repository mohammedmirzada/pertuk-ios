//
//  ShowSingleAuthorView.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 10/05/2023.
//

import SwiftUI
import RealmSwift
import URLImage

class ModifyCheck: ObservableObject {
    @Published var book_id: Int
    var user = User()
    var read = false {
        willSet {
            objectWillChange.send()
        }
    }
    var favourite = false {
        willSet {
            objectWillChange.send()
        }
    }
    init(book_id: Int = 0) {
        self.book_id = book_id
        if(user.IsLoggedIn()){
            CheckStatus()
        }
    }
    func CheckStatus() {
        let url = URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=check_rf&book_id=\(self.book_id)&user_id=\(user.GetUserId())")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let urlstr = "tool=check_rf"
        request.httpBody = urlstr.data(using: .utf8)!
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async{ [self] in
                if let response = response as? HTTPURLResponse {
                    let statusCode = response.statusCode
                    if statusCode >= 200 && statusCode <= 299{
                        let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                        if let checked = json?["checked"] as? [String: Any] {
                            self.favourite = checked["favourite"] as? Bool ?? false
                            self.read = checked["read"] as? Bool ?? false
                        }
                    }
                }
            }
        }.resume()
    }
    func PushStatus(status_name: String) {
        var url = URL(string: "")
        if (status_name == "favourite"){
            self.favourite.toggle()
            url = URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=modify_rf&get=favourite&book_id=\(self.book_id)&user_id=\(user.GetUserId())")
        }else{
            self.read.toggle()
            url = URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=modify_rf&get=read&book_id=\(self.book_id)&user_id=\(user.GetUserId())")
        }
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let urlstr = "tool=modify_rf"
        request.httpBody = urlstr.data(using: .utf8)!
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in }.resume()
    }
}

struct ShowSingleBookView: View {
    @StateObject var modifyCheck: ModifyCheck
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) var openURL
    @EnvironmentObject var adsViewModel: AdsViewModel
    @State private var showingAlertFavourite = false
    @State private var showingAlertRead = false
        
    var user = User()
    
    var id: Int
    var name: String
    var image: String
    var author_id: Int
    var category_ids: Int
    var book1: String
    var book2: String
    var book3: String
    var book4: String
    var book5: String
    var book6: String
    var book7: String
    var book8: String
    var book9: String
    var book10: String
    var views: Int
    var downloads: Int
        
    init(id: Int = 803, name: String = "کیمیاگەر (بادینی)", image: String = "https://programnas.com/control/lpictures/312761-612a3fb92a54e-1630158777.jpg", author_id: Int = 37, category_ids: Int = 17, book1: String = "956982-612a55378c476-1630164279.pdf", book2: String = "", book3: String = "", book4: String = "", book5: String = "", book6: String = "", book7: String = "", book8: String = "", book9: String = "", book10: String = "", views: Int = 0, downloads: Int = 0) {
        self.id = id
        self.name = name
        self.image = image
        self.author_id = author_id
        self.category_ids = category_ids
        self.book1 = book1
        self.book2 = book2
        self.book3 = book3
        self.book4 = book4
        self.book5 = book5
        self.book6 = book6
        self.book7 = book7
        self.book8 = book8
        self.book9 = book9
        self.book10 = book10
        self.views = views
        self.downloads = downloads
        self._modifyCheck = StateObject(wrappedValue: ModifyCheck(book_id: id))
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    Spacer()
                    URLImage(URL(string: image)!) {
                        EmptyView()
                    } inProgress: { progress in
                        ProgressView()
                        ZStack{
                            Image("lib_no_image").resizable().aspectRatio(contentMode: .fit).cornerRadius(20).frame(maxWidth: 500.0, maxHeight: 500.0)
                            ProgressView().scaleEffect(2).progressViewStyle(CircularProgressViewStyle(tint: Color("programnas_blue")))
                        }
                    } failure: { error, retry in
                        VStack {
                            Text(error.localizedDescription)
                            Button("retry", action: retry)
                        }
                    } content: { image in
                        image.resizable().aspectRatio(contentMode: .fit).cornerRadius(20).frame(maxWidth: 500.0, maxHeight: 500.0)
                    }
                    Spacer()
                    HStack{
                        NavigationLink {
                            ShowAllBooksView(category_id: category_ids, navigation_title: "\(db.GetCategory(id: category_ids)[0])")
                        } label: {
                            HStack{
                                Text(db.GetCategory(id: category_ids)[0]).padding(.leading, 10.0).frame(height: 35.0).foregroundColor(Color("category_text_button")).font(.bold(.body)())
                                Image(systemName: db.GetCategory(id: category_ids)[1]).symbolRenderingMode(.hierarchical)
                                    .font(.system(size: 20)).foregroundColor(colorScheme == .dark ? Color.white : Color.black).padding(.trailing, 10.0)
                            }.background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("category_background_color")/*@END_MENU_TOKEN@*/).cornerRadius(8)
                        }.simultaneousGesture(TapGesture().onEnded{
                            adsViewModel.showInterstitial = true
                        })
                        if author_id != 0 {
                            NavigationLink {
                                ShowSingleAuthorView(id: author_id, name: db.GetAuthor(id: author_id)[0], image: db.GetAuthor(id: author_id)[1])
                            } label: {
                                HStack{
                                    Text(db.GetAuthor(id: author_id)[0]).padding(.horizontal, 10.0).frame(height: 35.0).foregroundColor(Color("category_text_button")).font(.bold(.body)())
                                }.background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("category_background_color")/*@END_MENU_TOKEN@*/).cornerRadius(8)
                            }.simultaneousGesture(TapGesture().onEnded{
                                adsViewModel.showInterstitial = true
                            })
                        }
                    }.padding(10)
                    HStack{
                        Image(systemName: "eye.fill").symbolRenderingMode(.hierarchical)
                            .font(.system(size: 26)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        Text("\(views)").padding(.trailing, 20.0)
                        Image(systemName: "arrow.down.to.line").symbolRenderingMode(.hierarchical)
                            .font(.system(size: 26)).foregroundColor(colorScheme == .dark ? Color.white : Color.black).padding(.leading, 20.0)
                        Text("\(downloads)")
                    }.padding(20)
                    VStack{
                        if book1 != "" {
                            NavigationLink{
                                WebViewView(url: "https://programnas.com/control/files/\(book1)")
                            } label: {
                                HStack{
                                    Text("read_book_one").frame(maxWidth: .infinity).padding(10).foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                }.background(colorScheme == .dark ? Color.white : Color.black).cornerRadius(12)
                            }.simultaneousGesture(TapGesture().onEnded{
                                adsViewModel.showInterstitial = true
                            })
                        }
                        if book2 != "" {
                            NavigationLink{
                                WebViewView(url: "https://programnas.com/control/files/\(book2)")
                            } label: {
                                HStack{
                                    Text("read_book_two").frame(maxWidth: .infinity).padding(10).foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                }.background(colorScheme == .dark ? Color.white : Color.black).cornerRadius(12)
                            }.simultaneousGesture(TapGesture().onEnded{
                                adsViewModel.showInterstitial = true
                            })
                        }
                        if book3 != "" {
                            NavigationLink{
                                WebViewView(url: "https://programnas.com/control/files/\(book3)")
                            } label: {
                                HStack{
                                    Text("read_book_three").frame(maxWidth: .infinity).padding(10).foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                }.background(colorScheme == .dark ? Color.white : Color.black).cornerRadius(12)
                            }.simultaneousGesture(TapGesture().onEnded{
                                adsViewModel.showInterstitial = true
                            })
                        }
                        if book4 != "" {
                            NavigationLink{
                                WebViewView(url: "https://programnas.com/control/files/\(book4)")
                            } label: {
                                HStack{
                                    Text("read_book_four").frame(maxWidth: .infinity).padding(10).foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                }.background(colorScheme == .dark ? Color.white : Color.black).cornerRadius(12)
                            }.simultaneousGesture(TapGesture().onEnded{
                                adsViewModel.showInterstitial = true
                            })
                        }
                        if book5 != "" {
                            NavigationLink{
                                WebViewView(url: "https://programnas.com/control/files/\(book5)")
                            } label: {
                                HStack{
                                    Text("read_book_five").frame(maxWidth: .infinity).padding(10).foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                }.background(colorScheme == .dark ? Color.white : Color.black).cornerRadius(12)
                            }.simultaneousGesture(TapGesture().onEnded{
                                adsViewModel.showInterstitial = true
                            })
                        }
                        if book6 != "" {
                            NavigationLink{
                                WebViewView(url: "https://programnas.com/control/files/\(book6)")
                            } label: {
                                HStack{
                                    Text("read_book_six").frame(maxWidth: .infinity).padding(10).foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                }.background(colorScheme == .dark ? Color.white : Color.black).cornerRadius(12)
                            }.simultaneousGesture(TapGesture().onEnded{
                                adsViewModel.showInterstitial = true
                            })
                        }
                        if book7 != "" {
                            NavigationLink{
                                WebViewView(url: "https://programnas.com/control/files/\(book7)")
                            } label: {
                                HStack{
                                    Text("read_book_seven").frame(maxWidth: .infinity).padding(10).foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                }.background(colorScheme == .dark ? Color.white : Color.black).cornerRadius(12)
                            }.simultaneousGesture(TapGesture().onEnded{
                                adsViewModel.showInterstitial = true
                            })
                        }
                        if book8 != "" {
                            NavigationLink{
                                WebViewView(url: "https://programnas.com/control/files/\(book8)")
                            } label: {
                                HStack{
                                    Text("read_book_eight").frame(maxWidth: .infinity).padding(10).foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                }.background(colorScheme == .dark ? Color.white : Color.black).cornerRadius(12)
                            }.simultaneousGesture(TapGesture().onEnded{
                                adsViewModel.showInterstitial = true
                            })
                        }
                        if book9 != "" {
                            NavigationLink{
                                WebViewView(url: "https://programnas.com/control/files/\(book9)")
                            } label: {
                                HStack{
                                    Text("read_book_nine").frame(maxWidth: .infinity).padding(10).foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                }.background(colorScheme == .dark ? Color.white : Color.black).cornerRadius(12)
                            }.simultaneousGesture(TapGesture().onEnded{
                                adsViewModel.showInterstitial = true
                            })
                        }
                        if book10 != "" {
                            NavigationLink{
                                WebViewView(url: "https://programnas.com/control/files/\(book10)")
                            } label: {
                                HStack{
                                    Text("read_book_ten").frame(maxWidth: .infinity).padding(10).foregroundColor(colorScheme == .light ? Color.white : Color.black)
                                }.background(colorScheme == .dark ? Color.white : Color.black).cornerRadius(12)
                            }.simultaneousGesture(TapGesture().onEnded{
                                adsViewModel.showInterstitial = true
                            })
                        }
                    }
                    VStack{
                        if book1 != "" {
                          Button {
                            openURL(URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=download&book_id=\(id)&file=\(book1)")!)
                          } label: {
                            HStack {
                              Text("download_book_one").frame(maxWidth: .infinity).padding(10).foregroundColor(
                                colorScheme == .light ? Color.white : Color.black)
                            }.background(colorScheme == .dark ? Color.white : Color.indigo).cornerRadius(12)
                          }
                        }
                        if book2 != "" {
                          Button {
                            openURL(URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=download&book_id=\(id)&file=\(book2)")!)
                          } label: {
                            HStack {
                              Text("download_book_two").frame(maxWidth: .infinity).padding(10).foregroundColor(
                                colorScheme == .light ? Color.white : Color.black)
                            }.background(colorScheme == .dark ? Color.white : Color.indigo).cornerRadius(12)
                          }
                        }
                        if book3 != "" {
                          Button {
                            openURL(URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=download&book_id=\(id)&file=\(book3)")!)
                          } label: {
                            HStack {
                              Text("download_book_three").frame(maxWidth: .infinity).padding(10).foregroundColor(
                                colorScheme == .light ? Color.white : Color.black)
                            }.background(colorScheme == .dark ? Color.white : Color.indigo).cornerRadius(12)
                          }
                        }
                        if book4 != "" {
                          Button {
                            openURL(URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=download&book_id=\(id)&file=\(book4)")!)
                          } label: {
                            HStack {
                              Text("download_book_four").frame(maxWidth: .infinity).padding(10).foregroundColor(
                                colorScheme == .light ? Color.white : Color.black)
                            }.background(colorScheme == .dark ? Color.white : Color.indigo).cornerRadius(12)
                          }
                        }
                        if book5 != "" {
                          Button {
                            openURL(URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=download&book_id=\(id)&file=\(book5)")!)
                          } label: {
                            HStack {
                              Text("download_book_five").frame(maxWidth: .infinity).padding(10).foregroundColor(
                                colorScheme == .light ? Color.white : Color.black)
                            }.background(colorScheme == .dark ? Color.white : Color.indigo).cornerRadius(12)
                          }
                        }
                        if book6 != "" {
                          Button {
                            openURL(URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=download&book_id=\(id)&file=\(book6)")!)
                          } label: {
                            HStack {
                              Text("download_book_six").frame(maxWidth: .infinity).padding(10).foregroundColor(
                                colorScheme == .light ? Color.white : Color.black)
                            }.background(colorScheme == .dark ? Color.white : Color.indigo).cornerRadius(12)
                          }
                        }
                        if book7 != "" {
                          Button {
                            openURL(URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=download&book_id=\(id)&file=\(book7)")!)
                          } label: {
                            HStack {
                              Text("download_book_seven").frame(maxWidth: .infinity).padding(10).foregroundColor(
                                colorScheme == .light ? Color.white : Color.black)
                            }.background(colorScheme == .dark ? Color.white : Color.indigo).cornerRadius(12)
                          }
                        }
                        if book8 != "" {
                          Button {
                            openURL(URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=download&book_id=\(id)&file=\(book8)")!)
                          } label: {
                            HStack {
                              Text("download_book_eight").frame(maxWidth: .infinity).padding(10).foregroundColor(
                                colorScheme == .light ? Color.white : Color.black)
                            }.background(colorScheme == .dark ? Color.white : Color.indigo).cornerRadius(12)
                          }
                        }
                        if book9 != "" {
                          Button {
                            openURL(URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=download&book_id=\(id)&file=\(book9)")!)
                          } label: {
                            HStack {
                              Text("download_book_nine").frame(maxWidth: .infinity).padding(10).foregroundColor(
                                colorScheme == .light ? Color.white : Color.black)
                            }.background(colorScheme == .dark ? Color.white : Color.indigo).cornerRadius(12)
                          }
                        }
                        if book10 != "" {
                          Button {
                            openURL(URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=download&book_id=\(id)&file=\(book10)")!)
                          } label: {
                            HStack {
                              Text("download_book_ten").frame(maxWidth: .infinity).padding(10).foregroundColor(
                                colorScheme == .light ? Color.white : Color.black)
                            }.background(colorScheme == .dark ? Color.white : Color.indigo).cornerRadius(12)
                          }
                        }
                    }
                    BannerView().padding(.top, 90.0)
                }.padding(12)
            }.navigationTitle(name).toolbar {
                if user.IsLoggedIn(){
                    Button {
                        modifyCheck.PushStatus(status_name: "favourite")
                    } label: {
                        Image(systemName: self.modifyCheck.favourite ? "heart.fill" : "heart").symbolRenderingMode(.hierarchical)
                            .font(.system(size: 20)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                    Button {
                        modifyCheck.PushStatus(status_name: "read")
                    } label: {
                        Image(systemName: self.modifyCheck.read ? "checkmark.circle.fill" : "checkmark.circle").symbolRenderingMode(.hierarchical)
                            .font(.system(size: 20)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                }else{
                    Button {
                        showingAlertFavourite = true
                    } label: {
                        Image(systemName: "heart").symbolRenderingMode(.hierarchical)
                            .font(.system(size: 20)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }.alert(langStr == "en" ? "Please Log in to add this book to your favorite list." : "تکایە بڕۆ ناو هەژمارەکەت بۆ دانانی ئەم کتێبە لە لیستی کتێبە دڵخوازەکانت.", isPresented: $showingAlertFavourite) {
                        Button("ok", role: .cancel) {}
                    }
                    Button {
                        showingAlertRead = true
                    } label: {
                        Image(systemName: "checkmark.circle").symbolRenderingMode(.hierarchical)
                            .font(.system(size: 20)).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }.alert(langStr == "en" ? "Please Log in to add this book to your read list." : "تکایە بڕۆ ناو هەژمارەکەت بۆ دانانی ئەم کتێبە لە لیستی کتێبە خوێنراوەکانت.", isPresented: $showingAlertRead) {
                        Button("ok", role: .cancel) {}
                    }
                }
            }
        }.toolbarRole(.editor)
    }
}

struct ShowSingleBookView_Previews: PreviewProvider {
    static var previews: some View {
//        ShowSingleBookView(id: 803, name: "کیمیاگەر (بادینی)", image: "https://programnas.com/control/lpictures/312761-612a3fb92a54e-1630158777.jpg", author_id: 37, category_ids: 17, book1: "956982-612a55378c476-1630164279.pdf", book2: "", book3: "", book4: "", book5: "", book6: "", book7: "", book8: "", book9: "", book10: "", views: 0, downloads: 0)
        ShowSingleBookView()
    }
}
