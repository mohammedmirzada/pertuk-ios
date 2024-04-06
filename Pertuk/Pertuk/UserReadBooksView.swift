//
//  RFBooksView.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 10/05/2023.
//

import SwiftUI
import RealmSwift
import URLImage

class FetchData: ObservableObject{
    var isHidden = false {
        willSet {
            objectWillChange.send()
        }
    }
    var found = false {
        willSet {
            objectWillChange.send()
        }
    }
    var book_ids = [Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    init() {
        let url = URL(string: "https://programnas.com/control/template/php/api/library/get/?API=\(user.API_AUTH)&tool=rf&get=read&user_id=\(user.GetUserId())")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let urlstr = "tool=rf"
        request.httpBody = urlstr.data(using: .utf8)!
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async{
                if let response = response as? HTTPURLResponse {
                    let statusCode = response.statusCode
                    if statusCode >= 200 && statusCode <= 299{                       self.isHidden = true
                        let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                        if let data_books = json?["books"] as? [Any] {
                            for item in data_books {
                                if let object = item as? [String: Any] {
                                    self.found = object["found"] as? Bool ?? false
                                    if self.found{
                                        let book_id = object["book_id"] as? Int ?? 0
                                        self.book_ids.append(book_id)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }.resume()
    }
}


struct UserReadBooksView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var fetchData = FetchData()
    @EnvironmentObject var adsViewModel: AdsViewModel
    
    var body: some View {
        NavigationStack{
            if fetchData.isHidden{
                if fetchData.found{
                    ScrollView{
                        VStack{
                            Spacer()
                            VStack{
                                LazyVGrid(columns: UIDevice.current.userInterfaceIdiom == .pad ? [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] : [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                    ForEach(self.fetchData.book_ids, id: \.self) { book_id in
                                        ForEach(db.GetBooks(category_id: 0, author_id: 0, book_id: book_id), id: \.id) { item in
                                            NavigationLink {
                                                ShowSingleBookView(id: item.id, name: item.name, image: item.image, author_id: item.author_id, category_ids: item.category_ids, book1: item.book1, book2: item.book2, book3: item.book3, book4: item.book4, book5: item.book5, book6: item.book6, book7: item.book7, book8: item.book8, book9: item.book9, book10: item.book10, views: item.views, downloads: item.downloads)
                                            } label: {
                                                VStack(alignment: .center){
                                                    URLImage(URL(string: item.image)!) {
                                                        EmptyView()
                                                    } inProgress: { progress in
                                                        ZStack{
                                                            Image("lib_no_image").resizable().aspectRatio(contentMode: .fit).cornerRadius(12)
                                                            ProgressView().scaleEffect(2).progressViewStyle(CircularProgressViewStyle(tint: Color("programnas_blue")))
                                                        }
                                                    } failure: { error, retry in
                                                        VStack {
                                                            Text(error.localizedDescription)
                                                            Button("retry", action: retry)
                                                        }
                                                    } content: { image in
                                                        image.resizable().aspectRatio(contentMode: .fit).cornerRadius(12)
                                                    }
                                                    Text(item.name).fixedSize(horizontal: false, vertical: true).multilineTextAlignment(.center).lineLimit(1)
                                                        .truncationMode(.tail).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                                }
                                            }.simultaneousGesture(TapGesture().onEnded{
                                                adsViewModel.showInterstitial = true
                                            })
                                        }
                                    }
                                }
                            }.padding(20)
                        }.padding(12)
                    }.navigationTitle("my_read_books").toolbarRole(.editor)
                }else{
                    VStack{
                        Image(systemName: "archivebox.fill").symbolRenderingMode(.hierarchical)
                            .font(.system(size: 100)).foregroundColor(colorScheme == .dark ? Color.white : Color.black).padding().opacity(0.2)
                    }.navigationTitle("my_read_books").toolbarRole(.editor)
                }
            }else{
                VStack {
                    ProgressView().scaleEffect(2)
                }.navigationTitle("my_read_books").toolbarRole(.editor)
            }
        }
    }
}

struct UserReadBooksView_Previews: PreviewProvider {
    static var previews: some View {
        UserReadBooksView()
    }
}
