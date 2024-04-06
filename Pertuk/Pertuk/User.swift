//
//  User.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 06/05/2023.
//

import UIKit

class User {
    
    var userDefaults: UserDefaults
    
    var API_AUTH = "UPCSCFSJIEFOXHAZ0XASQQOLPXRTXBJVQDHZWKEJRBDG"
    
    init(){
        self.userDefaults = UserDefaults.standard
    }
    
    func SetLoggedIn(login: Bool) {
        self.userDefaults.set(login, forKey: "IsLoggedIn")
    }
    
    func IsLoggedIn() -> Bool {
        if isKeyPresentInUserDefaults(key: "IsLoggedIn"){
            return self.userDefaults.bool(forKey: "IsLoggedIn")
        }else{
            SetLoggedIn(login: false)
            return false
        }
    }
    
    func SetUserId(user_id: Int) {
        self.userDefaults.set(user_id, forKey: "UserId")
    }
    
    func GetUserId() -> Int {
        if isKeyPresentInUserDefaults(key: "UserId"){
            return self.userDefaults.integer(forKey: "UserId")
        }else{
            SetUserId(user_id: 0)
            return 0
        }
    }
    
    func SetUsername(username: String) {
        self.userDefaults.set(username, forKey: "Username")
    }
    
    func GetUsername() -> String {
        if isKeyPresentInUserDefaults(key: "Username"){
            return self.userDefaults.string(forKey: "Username")!
        }else{
            SetUsername(username: "")
            return ""
        }
    }
    
    func SetName(name: String) {
        self.userDefaults.set(name, forKey: "Name")
    }
    
    func GetName() -> String {
        if isKeyPresentInUserDefaults(key: "Name"){
            return self.userDefaults.string(forKey: "Name")!
        }else{
            SetName(name: "")
            return ""
        }
    }
    
    func SetImage(image: String) {
        self.userDefaults.set(image, forKey: "Image")
    }
    
    func GetImage() -> String {
        if isKeyPresentInUserDefaults(key: "Image"){
            return self.userDefaults.string(forKey: "Image")!
        }else{
            SetImage(image: "")
            return ""
        }
    }
    
    func SetLibraryUpdateId(library_update_id: Int) {
        self.userDefaults.set(library_update_id, forKey: "LibraryUpdateId")
    }
    
    func GetLibraryUpdateId() -> Int {
        if isKeyPresentInUserDefaults(key: "LibraryUpdateId"){
            return self.userDefaults.integer(forKey: "LibraryUpdateId")
        }else{
            SetLibraryUpdateId(library_update_id: 0)
            return 0
        }
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func SetLanguage(language: String) {
        self.userDefaults.set(language, forKey: "Language")
    }
    
    func GetLanguage() -> String {
        if isKeyPresentInUserDefaults(key: "Language"){
            return self.userDefaults.string(forKey: "Language")!
        }else{
            SetLanguage(language: "")
            return ""
        }
    }
    
    func SetSupportCode(support_code: String) {
        self.userDefaults.set(support_code, forKey: "SupportCode")
    }
    
    func GetSupportCode() -> String {
        if isKeyPresentInUserDefaults(key: "SupportCode"){
            return self.userDefaults.string(forKey: "SupportCode")!
        }else{
            SetSupportCode(support_code: "")
            return ""
        }
    }
    
}
