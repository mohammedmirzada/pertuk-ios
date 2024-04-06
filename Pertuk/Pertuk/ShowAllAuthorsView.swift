//
//  ShowAllBooksView.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 10/05/2023.
//

import SwiftUI
import RealmSwift
import URLImage

struct ShowAllAuthorsView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var adsViewModel: AdsViewModel
    
    var body: some View {
        NavigationView {
            ScrollView{
                LazyVGrid(columns: UIDevice.current.userInterfaceIdiom == .pad ? [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] : [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(db.GetAuthors(), id: \.id) { item in
                        NavigationLink {
                            ShowSingleAuthorView(id: item.id, name: item.name, image: item.image)
                        } label: {
                            VStack(alignment: .center){
                                URLImage(URL(string: item.image)!) {
                                    EmptyView()
                                } inProgress: { progress in
                                    ProgressView()
                                } failure: { error, retry in
                                    VStack {
                                        Text(error.localizedDescription)
                                        Button("retry", action: retry)
                                    }
                                } content: { image in
                                    image.resizable().aspectRatio(contentMode: .fit).clipShape(Circle())
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
        }.navigationTitle("all_uthors").toolbarRole(.editor)
    }
}

struct ShowAllAuthorsView_Previews: PreviewProvider {
    static var previews: some View {
        ShowAllAuthorsView()
    }
}
