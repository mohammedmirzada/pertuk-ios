//
//  ShowAllBooksView.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 10/05/2023.
//

import SwiftUI
import RealmSwift
import URLImage

struct ShowAllBooksView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var adsViewModel: AdsViewModel
    var category_id: Int
    var navigation_title: String
    
    init(category_id: Int = 0, navigation_title: String = "allbooks"){
        self.category_id = category_id
        self.navigation_title = navigation_title
    }
    
    var body: some View {
        NavigationView {
            ScrollView{
                LazyVGrid(columns: UIDevice.current.userInterfaceIdiom == .pad ? [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] : [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(db.GetBooks(category_id: category_id), id: \.id) { item in
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
            }.padding(10)
        }.navigationTitle(navigation_title).toolbarRole(.editor)
    }
}

struct ShowAllBooksView_Previews: PreviewProvider {
    static var previews: some View {
        ShowAllBooksView()
    }
}
