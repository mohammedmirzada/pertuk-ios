//
//  SignUpView.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 03/06/2023.
//

import SwiftUI

class UserSignUp: ObservableObject {
    var isHidden = true {
        willSet {
            objectWillChange.send()
        }
    }
    var message = "" {
        willSet {
            objectWillChange.send()
        }
    }
    var success = false {
        willSet {
            objectWillChange.send()
        }
    }
    func Create(name: String, email: String, username: String, password: String, confirm_password: String) {
        self.isHidden = false
        let url = URL(string: "https://programnas.com/control/template/php/api/library/register/?API=\(user.API_AUTH)&app_lang=\(langStr!)&name=\(name)&email=\(email)&username=\(username)&password=\(password)&confirm_password=\(confirm_password)")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let urlstr = "tool=internet"
        request.httpBody = urlstr.data(using: .utf8)!
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async{
                if let response = response as? HTTPURLResponse {
                    let statusCode = response.statusCode
                    if statusCode >= 200 && statusCode <= 299{
                        let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                        if let data_user = json?["user"] as? [String: Any] {
                            self.message = data_user["error"] as? String ?? ""
                            self.success = data_user["success"] as? Bool ?? false
                            let id = data_user["id"] as? Int ?? 0
                            let name = data_user["name"] as? String ?? ""
                            let username = data_user["username"] as? String ?? ""
                            let image = data_user["image"] as? String ?? ""
                            let support_code = data_user["support_code"] as? String ?? ""
                            self.isHidden = true
                            if self.success {
                                self.message = langStr == "en" ? "Account created successfully." : "هەژمارەکە بە سەرکەوتوویی دروستکرا."
                                user.SetUserId(user_id: id)
                                user.SetName(name: name)
                                user.SetUsername(username: username)
                                user.SetImage(image: image)
                                user.SetLoggedIn(login: true)
                                user.SetLoggedIn(login: true)
                                user.SetSupportCode(support_code: support_code)
                            }else{
                                self.isHidden = true
                            }
                        }
                    }
                }
            }
        }.resume()
    }
}

struct SignUpView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme
    @StateObject var userSignUp = UserSignUp()
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirm_password: String = ""
    
    var body: some View {
        if !self.userSignUp.success{
            NavigationView {
                VStack{
                    Text("signup_for").fontWeight(.bold).padding(20)
                    VStack(alignment: .leading){
                        if userSignUp.message != "" {
                            Text(userSignUp.message).font(.headline).frame(maxWidth: .infinity).padding(8).foregroundColor(Color.white).background(userSignUp.success ? Color.green : Color("error_color")).cornerRadius(8)
                        }
                    }
                    VStack{
                        TextField("name", text: $name).padding(12).border(Color("primary_text_button"), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).cornerRadius(8).overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.5))
                        TextField("email", text: $email).padding(12).border(Color("primary_text_button"), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).cornerRadius(8).overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.5))
                        TextField("username", text: $username).padding(12).border(Color("primary_text_button"), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).cornerRadius(8).overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.5))
                        SecureField("password", text: $password).padding(12).border(Color("primary_text_button"), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).cornerRadius(8).overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.5))
                        SecureField("confirm_password", text: $confirm_password).padding(12).border(Color("primary_text_button"), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).cornerRadius(8).overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.5))
                    }.textFieldStyle(PlainTextFieldStyle())
                    
                    Button {
                        self.userSignUp.Create(name: name, email: email, username: username, password: password, confirm_password: confirm_password)
                    } label: {
                        Text("signup").fontWeight(.bold).frame(maxWidth: .infinity).padding(12).foregroundColor(/*@START_MENU_TOKEN@*/Color("splash_screen")/*@END_MENU_TOKEN@*/)
                        ProgressView().padding(self.userSignUp.isHidden ? .top : .trailing).progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .light ? Color.white : Color.black)).isHidden(userSignUp.isHidden)
                    }.buttonStyle(.plain).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("programnas_secondary_color")/*@END_MENU_TOKEN@*/).cornerRadius(8)
                    
                    NavigationLink {
                        WebViewView(url: "https://programnas.com/terms?ios_android=\(true)&app_lang=\(langStr == "ckb" ? "ku_central" : "en")")
                    } label: {
                        Text("byclickingsignup").padding(10).underline()
                    }.buttonStyle(.plain)
                    
                }.padding(.all)
            }.toolbarRole(.editor)
        }else{
            ContentView()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
