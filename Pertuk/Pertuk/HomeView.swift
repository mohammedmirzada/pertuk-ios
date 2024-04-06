//
//  HomeView.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 04/05/2023.
//

import SwiftUI
import RealmSwift
import URLImage
import GoogleMobileAds
import UIKit

let realm = try! Realm()
let db = Database()

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowBookView = false
    @EnvironmentObject var adsViewModel: AdsViewModel
    
    var body: some View {
        ScrollView(.vertical){
            VStack(){
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(db.GetCategories(), id: \.self) { item in
                            NavigationLink {
                                ShowAllBooksView(category_id: item.id, navigation_title: item.name).toolbarRole(.editor)
                            } label: {
                                HStack{
                                    Text(item.name).padding(.leading, 10.0).frame(height: 35.0).foregroundColor(Color("category_text_button")).font(.bold(.body)())
                                    Image(systemName: item.image).symbolRenderingMode(.hierarchical)
                                        .font(.system(size: 20)).foregroundColor(colorScheme == .dark ? Color.white : Color.black).padding(.trailing, 10.0)
                                }.background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("category_background_color")/*@END_MENU_TOKEN@*/).cornerRadius(8)
                            }.simultaneousGesture(TapGesture().onEnded{
                                adsViewModel.showInterstitial = true
                            })
                        }
                    }
                }.padding().background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("category_background_color")/*@END_MENU_TOKEN@*/).cornerRadius(12)
            }
            BannerView().padding(.top, 60.0)
            VStack(alignment: .leading){
                HStack(spacing: 10) {
                    Text("books")
                    Spacer()
                    NavigationLink {
                        ShowAllBooksView(category_id: 0, navigation_title: langStr == "en" ? "All Books" : "هەموو کتێبەکان")
                    } label: {
                        Text("view_all").padding(.all).frame(height: 35.0).foregroundColor(Color("category_text_button")).font(.bold(.body)()).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("category_background_color")/*@END_MENU_TOKEN@*/).cornerRadius(8)
                    }.simultaneousGesture(TapGesture().onEnded{
                        adsViewModel.showInterstitial = true
                    })
                }
                LazyVGrid(columns: UIDevice.current.userInterfaceIdiom == .pad ? [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] : [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(db.GetBooks().prefix(10), id: \.id) { item in
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
            }.padding(.all).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("category_background_color")/*@END_MENU_TOKEN@*/).cornerRadius(12)
            Spacer(minLength: 20)
            BannerView().padding(.top, 60.0)
            VStack(alignment: .leading){
                HStack(spacing: 10) {
                    Text("authors")
                    Spacer()
                    NavigationLink {
                        ShowAllAuthorsView()
                    } label: {
                        Text("view_all").padding(.all).frame(height: 35.0).foregroundColor(Color("category_text_button")).font(.bold(.body)()).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("category_background_color")/*@END_MENU_TOKEN@*/).cornerRadius(8)
                    }.simultaneousGesture(TapGesture().onEnded{
                        adsViewModel.showInterstitial = true
                    })
                }
                LazyVGrid(columns: UIDevice.current.userInterfaceIdiom == .pad ? [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())] : [GridItem(.flexible()), GridItem(.flexible())], spacing: 30) {
                    ForEach(db.GetAuthors().prefix(10), id: \.id) { item in
                        NavigationLink {
                            ShowSingleAuthorView(id: item.id, name: item.name, image: item.image)
                        } label: {
                            VStack(alignment: .center){
                                URLImage(URL(string: item.image)!) {
                                    EmptyView()
                                } inProgress: { progress in
                                    ZStack{
                                        Image("auth_no_img").resizable().aspectRatio(contentMode: .fit).clipShape(Circle())
                                        ProgressView().scaleEffect(2).progressViewStyle(CircularProgressViewStyle(tint: Color("programnas_blue")))
                                    }
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
            }.padding(.all).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("category_background_color")/*@END_MENU_TOKEN@*/).cornerRadius(12)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
