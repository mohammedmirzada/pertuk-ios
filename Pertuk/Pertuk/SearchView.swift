//
//  SearchView.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 12/05/2023.
//

import SwiftUI

struct ClearButton: ViewModifier{
    @Binding var text: String

    public func body(content: Content) -> some View{
        ZStack(alignment: .trailing){
            content
            if !text.isEmpty{
                Button(action:{
                    self.text = ""
                }){
                    Image(systemName: "multiply.circle.fill").foregroundColor(Color(UIColor.opaqueSeparator))
                }.padding(.trailing, 8)
            }
        }
    }
}

struct SearchView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var searchText = ""
    @FocusState private var focusedField: FocusedField?
    enum FocusedField {case search_text}
    
    var body: some View {
        VStack{
            if searchText.count > 2 {
                List{
                    ForEach(db.GetBooks(book_name: searchText), id: \.self) { item in
                        NavigationLink{
                            ShowSingleBookView(id: item.id, name: item.name, image: item.image, author_id: item.author_id, category_ids: item.category_ids, book1: item.book1, book2: item.book2, book3: item.book3, book4: item.book4, book5: item.book5, book6: item.book6, book7: item.book7, book8: item.book8, book9: item.book9, book10: item.book10, views: item.views, downloads: item.downloads)
                        } label: {
                            Text(item.name).frame(maxWidth: .infinity, alignment: .center).padding(8)
                        }
                    }
                }
            }else{
                Image(systemName: "rectangle.and.text.magnifyingglass").symbolRenderingMode(.hierarchical)
                    .font(.system(size: 100)).foregroundColor(colorScheme == .dark ? Color.white : Color.black).opacity(0.3)
            }
        }.toolbar {
            ToolbarItem(placement: .principal) {
                TextField("find_", text: $searchText).focused($focusedField, equals: .search_text).onAppear {focusedField = .search_text}.padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 34)).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("category_background_color")/*@END_MENU_TOKEN@*/).cornerRadius(12).modifier(ClearButton(text: $searchText))
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
