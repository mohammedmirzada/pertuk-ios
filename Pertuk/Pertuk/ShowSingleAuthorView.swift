//
//  ShowSingleAuthorView.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 10/05/2023.
//

import SwiftUI
import RealmSwift
import URLImage

struct ShowSingleAuthorView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var adsViewModel: AdsViewModel
    var id: Int
    var name: String
    var image: String
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    Spacer()
                    URLImage(URL(string: image)!) {
                        EmptyView()
                    } inProgress: { progress in
                        ProgressView()
                    } failure: { error, retry in
                        VStack {
                            Text(error.localizedDescription)
                            Button("retry", action: retry)
                        }
                    } content: { image in
                        image.resizable().aspectRatio(contentMode: .fit).cornerRadius(20).frame(maxWidth: 300.0, maxHeight: 300.0)
                    }
                    Spacer()
                    VStack{
                        HStack(){
                            Text("books")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())], spacing: 20) {
                            ForEach(db.GetBooks(category_id: 0, author_id: id), id: \.id) { item in
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
                        BannerView().padding(.top, 90.0)
                    }.padding(20)
                }.padding(12)
            }.navigationTitle(name).toolbarRole(.editor)
        }
    }
}

struct ShowSingleAuthorView_Previews: PreviewProvider {
    static var previews: some View {
        ShowSingleAuthorView(id: 37, name: "Paulo Coelho", image: "https://programnas.com/control/lpictures/6128-6125f38d4d56f-1629877133.jpg")
    }
}
