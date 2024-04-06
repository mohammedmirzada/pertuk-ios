//
//  Database.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 06/05/2023.
//

import Foundation
import RealmSwift

class Categories: Object {
    @Persisted var id: Int
    @Persisted var name: String
    @Persisted var image: String
}

class Authors: Object {
    @Persisted var id: Int
    @Persisted var name: String
    @Persisted var image: String
}

class Books: Object {
    @Persisted var id: Int
    @Persisted var name: String
    @Persisted var image: String
    @Persisted var author_id: Int
    @Persisted var category_ids: Int
    @Persisted var book1: String
    @Persisted var book2: String
    @Persisted var book3: String
    @Persisted var book4: String
    @Persisted var book5: String
    @Persisted var book6: String
    @Persisted var book7: String
    @Persisted var book8: String
    @Persisted var book9: String
    @Persisted var book10: String
    @Persisted var views: Int
    @Persisted var downloads: Int
}

class Database {
    
    func SetCategories(id: Int, name: String, image: String) {
        let realm = try! Realm()
        let categories = Categories()
        categories.id = id
        categories.name = name
        categories.image = image
        try! realm.write {
            realm.add(categories)
        }
    }
    
    func GetCategories() -> Results<Categories> {
        let realm = try! Realm()
        let categories = realm.objects(Categories.self)
        return categories
    }
    
    func GetCategory(id: Int) -> [String] {
        let realm = try! Realm()
        let categories = realm.objects(Categories.self)
        let realmSwiftQuery = categories.where {
            ($0.id == id)
        }
        var name = ""
        var image = ""
        for data in realmSwiftQuery{
            name = data.name
            image = data.image
        }
        return [name, image]
    }
    
    func DeleteCategories() {
        let realm = try! Realm()
        try! realm.write {
            let categories = realm.objects(Categories.self)
            realm.delete(categories)
        }
    }
    
    func SetAuthors(id: Int, name: String, image: String) {
        let realm = try! Realm()
        let authors = Authors()
        authors.id = id
        authors.name = name
        authors.image = image
        try! realm.write {
            realm.add(authors)
        }
    }
    
    func GetAuthors() -> Results<Authors> {
        let realm = try! Realm()
        let authors = realm.objects(Authors.self)
        return authors
    }
    
    func GetAuthor(id: Int) -> [String] {
        let realm = try! Realm()
        let authors = realm.objects(Authors.self)
        let realmSwiftQuery = authors.where {
            ($0.id == id)
        }
        var name = ""
        var image = ""
        for data in realmSwiftQuery{
            name = data.name
            image = data.image
        }
        return [name, image]
    }
    
    func DeleteAuthors() {
        let realm = try! Realm()
        try! realm.write {
            let authors = realm.objects(Authors.self)
            realm.delete(authors)
        }
    }
    
    func SetBooks(id: Int, name: String, image: String, author_id: Int, category_ids: Int, book1: String, book2: String, book3: String, book4: String, book5: String, book6: String, book7: String, book8: String, book9: String, book10: String, views: Int, downloads: Int) {
        let realm = try! Realm()
        let books = Books()
        books.id = id
        books.name = name
        books.image = image
        books.author_id = author_id
        books.category_ids = category_ids
        books.book1 = book1
        books.book2 = book2
        books.book3 = book3
        books.book4 = book4
        books.book5 = book5
        books.book6 = book6
        books.book7 = book7
        books.book8 = book8
        books.book9 = book9
        books.book10 = book10
        books.views = views
        books.downloads = downloads
        try! realm.write {
            realm.add(books)
        }
    }
    
    func GetBooks(category_id: Int = 0, author_id: Int = 0, book_id: Int = 0, book_name: String = "") -> Results<Books> {
        let realm = try! Realm()
        let books = realm.objects(Books.self)
        if(category_id != 0){
            let realmSwiftQuery = books.where {
                ($0.category_ids == category_id)
            }
            return realmSwiftQuery
        }else if(author_id != 0){
            let realmSwiftQuery = books.where {
                ($0.author_id == author_id)
            }
            return realmSwiftQuery
        }else if(book_id != 0){
            let realmSwiftQuery = books.where {
                ($0.id == book_id)
            }
            return realmSwiftQuery
        }else if(book_name.count > 2){
            let realmSwiftQuery = books.where {
                $0.name.contains(book_name)
            }
            return realmSwiftQuery
        }else{
            return books
        }
    }
    
    func DeleteLibraryBooks() {
        let realm = try! Realm()
        try! realm.write {
            let books = realm.objects(Books.self)
            realm.delete(books)
        }
    }
    
    func DeleteAll() {
        try! realm.write {
          realm.deleteAll()
        }
    }
    
}
