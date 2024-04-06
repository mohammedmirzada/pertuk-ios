//
//  InfoView.swift
//  Pertuk
//
//  Created by Mohammed D Mirzada on 04/05/2023.
//

import SwiftUI
import URLImage

var user = User()

class UserLogin: ObservableObject {
    var isLoggedIn = false {
        willSet {
            objectWillChange.send()
        }
    }
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
    var deleted = false {
        willSet {
            objectWillChange.send()
        }
    }
    var deleted_error_message = "" {
        willSet {
            objectWillChange.send()
        }
    }
    init() {
        if(user.IsLoggedIn()){
            self.isLoggedIn = true
        }else{
            self.isLoggedIn = false
        }
    }
    func LogIn(username: String, password: String) {
        self.isHidden = false
        let url = URL(string: "https://programnas.com/control/template/php/api/library/login/?API=\(user.API_AUTH)&app_lang=\(langStr!)&username=\(username)&password=\(password)")
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
                                self.message = langStr == "en" ? "Logged in successfully." : "چوونەژوورەوەکە سەرکەوتووبوو."
                                user.SetUserId(user_id: id)
                                user.SetName(name: name)
                                user.SetUsername(username: username)
                                user.SetImage(image: image)
                                user.SetLoggedIn(login: true)
                                user.SetSupportCode(support_code: support_code)
                                Timer.scheduledTimer(timeInterval: 1,target: self,selector: #selector(self.SendMessage),userInfo: nil, repeats: false)
                            }else{
                                self.isHidden = true
                            }
                        }
                    }
                }
            }
        }.resume()
    }
    func DeleteAccount() {
        let url = URL(string: "https://programnas.com/control/template/php/api/library/delete/?API=\(user.API_AUTH)&app_lang=\(langStr!)&user_id=\(user.GetUserId())&support_code=\(user.GetSupportCode())")
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
                        if let deleting = json?["deleting"] as? [String: Any] {
                            self.deleted = deleting["deleted"] as? Bool ?? false
                            self.deleted_error_message = deleting["message"] as? String ?? ""
                        }
                        if self.deleted {
                            self.isLoggedIn = false
                            user.SetLoggedIn(login: false)
                            user.SetUserId(user_id: 0)
                            user.SetName(name: "")
                            user.SetUsername(username: "")
                            user.SetImage(image: "")
                            user.SetSupportCode(support_code: "")
                        }
                    }
                }
            }
        }.resume()
    }
    @objc private func SendMessage(){
        self.isLoggedIn = true
    }
    func LogOut() {
        self.isLoggedIn = false
        user.SetLoggedIn(login: false)
    }
}


struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.openURL) var openURL
    @StateObject var userLogin = UserLogin()
    @State private var isShowingView: Bool = false
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAccount = false
    @State private var confirmationText = ""
    @State private var showingContactSupport = false
                
    var body: some View {
        if userLogin.isLoggedIn {
            VStack{
                VStack{
                    Button {
                        openURL(URL(string: "https://programnas.com/\(user.GetUsername())")!)
                    } label: {
                        URLImage(URL(string: user.GetImage())!) {
                            EmptyView()
                        } inProgress: { progress in
                            ProgressView()
                        } failure: { error, retry in
                            VStack {
                                Text(error.localizedDescription)
                                Button("retry", action: retry)
                            }
                        } content: { image in
                            image.resizable().aspectRatio(contentMode: .fit).cornerRadius(20).frame(maxWidth: 32.0, maxHeight: 32.0)
                        }.padding()
                        Text(user.GetName()).fontWeight(.bold).multilineTextAlignment(.leading).frame(maxWidth: .infinity).foregroundColor(Color("category_text_button"))
                    }.buttonStyle(.plain).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("category_background_color")/*@END_MENU_TOKEN@*/).cornerRadius(8)
                    NavigationLink {
                        UserReadBooksView()
                    } label: {
                        HStack{
                            Image(systemName: "checkmark.circle.fill").symbolRenderingMode(.hierarchical)
                                .font(.system(size: 26)).foregroundColor(colorScheme == .dark ? Color.white : Color.black).padding()
                            Text("my_read_books").fontWeight(.bold).multilineTextAlignment(.leading).frame(maxWidth: .infinity).foregroundColor(Color("category_text_button")).padding()
                        }.background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("category_background_color")/*@END_MENU_TOKEN@*/).cornerRadius(8)
                    }.cornerRadius(8)
                    NavigationLink {
                        UserFavouriteBooksView()
                    } label: {
                        HStack{
                            Image(systemName: "heart.fill").symbolRenderingMode(.hierarchical)
                                .font(.system(size: 26)).foregroundColor(colorScheme == .dark ? Color.white : Color.black).padding()
                            Text("my_read_favourite").fontWeight(.bold).multilineTextAlignment(.leading).frame(maxWidth: .infinity).foregroundColor(Color("category_text_button")).padding()
                        }.background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("category_background_color")/*@END_MENU_TOKEN@*/).cornerRadius(8)
                    }.cornerRadius(8)
                    Button {
                        showingLogoutAlert = true
                    } label: {
                        Text("log_out").fontWeight(.bold).frame(maxWidth: .infinity).padding(12).foregroundColor(Color(hue: 1.0, saturation: 0.633, brightness: 0.723))
                    }.buttonStyle(.plain).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.659, brightness: 0.956, opacity: 0.303)/*@END_MENU_TOKEN@*/).cornerRadius(8).alert(isPresented: $showingLogoutAlert) {
                        Alert(
                            title: Text("are_u_sure"),
                            primaryButton: .destructive(Text("yes")) {
                                userLogin.LogOut()
                            },
                            secondaryButton: .cancel(Text("no"))
                        )
                    }
                    Button {
                        showingDeleteAccount = true
                    } label: {
                        Text("delete_account").fontWeight(.bold).frame(maxWidth: .infinity).padding(12).foregroundColor(Color(hue: 1.0, saturation: 0.633, brightness: 0.723))
                    }.buttonStyle(.plain).cornerRadius(8).alert("areusuredeleteaccount", isPresented: $showingDeleteAccount) {
                        TextField("tepdelete", text: $confirmationText)
                        Button("confirmdeleteaccount", role: .destructive) {
                            if confirmationText == "Delete"{
                                userLogin.DeleteAccount()
                            }else{
                                showingContactSupport = true
                            }
                        }
                        Button("cancel", role: .cancel) {}
                    } message: {
                        Text("ifsoplease")
                    }
                    if !userLogin.deleted{
                        if userLogin.deleted_error_message != ""{
                            Text(userLogin.deleted_error_message).fixedSize().frame(maxWidth: .infinity).padding(4).foregroundColor(Color(hue: 1.0, saturation: 0.633, brightness: 0.723))
                        }
                    }
                }
                VStack{
                    VStack{
                        Text("to_change_language").font(.system(size: 14)).padding(/*@START_MENU_TOKEN@*/.top, 50.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("link_text_color"))
                        Button {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }
                        } label: {
                            Text("Settings > Pertuk > PREFERRED LANGUAGE").font(.system(size: 14)).padding(2.0).foregroundColor(Color("link_text_color")).underline()
                        }
                        Spacer()
                        HStack(alignment: .center){
                            NavigationLink {
                                WebViewView(url: "https://programnas.com/library/copyright?ios_android=\(true)&app_lang=\(langStr == "ckb" ? "ku_central" : "en")")
                            } label: {
                                Text("copyright").font(.system(size: 14)).padding(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("link_text_color")).underline()
                            }
                            
                            NavigationLink {
                                WebViewView(url: "https://programnas.com/questions/?ios_android=\(true)&app_lang=\(langStr == "ckb" ? "ku_central" : "en")")
                            } label: {
                                Text("community").font(.system(size: 14)).padding(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("link_text_color")).underline()
                            }
                            
                            NavigationLink {
                                WebViewView(url: "https://programnas.com/support/?ios_android=\(true)&app_lang=\(langStr == "ckb" ? "ku_central" : "en")")
                            } label: {
                                Text("support").font(.system(size: 14)).padding(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("link_text_color")).underline()
                            }
                            
                            NavigationLink {
                                WebViewView(url: "https://programnas.com/library/privacy/?ios_android=\(true)&app_lang=\(langStr == "ckb" ? "ku_central" : "en")")
                            } label: {
                                Text("privacy").font(.system(size: 14)).padding(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("link_text_color")).underline()
                            }
                        }.padding(.top, 20)
                        Text("© \(String(Calendar.current.component(.year, from: Date()))) \(langStr == "en" ? "Programnas Library" : "کتێبخانەی پرۆگرامناس")").font(.system(size: 14)).padding(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("link_text_color"))
                    }
                }
            }.padding(12).alert("theconf_werong", isPresented: $showingContactSupport) {
                Button("ok", role: .cancel) {}
            } message: {
                Text("pleasetypeagain")
            }
        }else{
            VStack{
                Spacer()
                VStack(alignment: .leading){
                    Text("over").font(.system(size: 23)).multilineTextAlignment(.leading)
                    Text("over_two").font(.system(size: 18)).padding(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/)
                    if userLogin.message != "" {
                        Text(userLogin.message).font(.headline).frame(maxWidth: .infinity).padding(8).foregroundColor(Color.white).background(userLogin.success ? Color.green : Color("error_color")).cornerRadius(8)
                    }
                }
                VStack{
                    VStack{
                        TextField("username_or_email", text: $username).padding(12).border(Color("primary_text_button"), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).cornerRadius(8).overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.5))
                        SecureField("password", text: $password).padding(12).border(Color("primary_text_button"), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/).cornerRadius(8).overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.5))
                    }.textFieldStyle(PlainTextFieldStyle())
                    Button {
                        self.userLogin.LogIn(username: username, password: password)
                    } label: {
                        Text("login").fontWeight(.bold).frame(maxWidth: .infinity).padding(12).foregroundColor(/*@START_MENU_TOKEN@*/Color("splash_screen")/*@END_MENU_TOKEN@*/)
                        ProgressView().padding(userLogin.isHidden ? .top : .trailing).progressViewStyle(CircularProgressViewStyle(tint: colorScheme == .light ? Color.white : Color.black)).isHidden(userLogin.isHidden)
                    }.buttonStyle(.plain).background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("programnas_secondary_color")/*@END_MENU_TOKEN@*/).cornerRadius(8)
                    
                }
                NavigationLink {
                    SignUpView()
                } label: {
                    Text("signup").font(.system(size: 18)).padding(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("programnas_secondary_color")).underline()
                }.padding(.top, 10.0)
                
                Text("to_change_language").font(.system(size: 14)).padding(/*@START_MENU_TOKEN@*/.top, 50.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("link_text_color"))
                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                } label: {
                    Text("Settings > Pertuk > PREFERRED LANGUAGE").font(.system(size: 14)).padding(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("link_text_color")).underline()
                }
                Spacer()
                HStack(alignment: .center){
                    NavigationLink {
                        WebViewView(url: "https://programnas.com/library/copyright?ios_android=\(true)&app_lang=\(langStr == "ckb" ? "ku_central" : "en")")
                    } label: {
                        Text("copyright").font(.system(size: 14)).padding(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("link_text_color")).underline()
                    }
                    
                    NavigationLink {
                        WebViewView(url: "https://programnas.com/questions/?ios_android=\(true)&app_lang=\(langStr == "ckb" ? "ku_central" : "en")")
                    } label: {
                        Text("community").font(.system(size: 14)).padding(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("link_text_color")).underline()
                    }
                    
                    NavigationLink {
                        WebViewView(url: "https://programnas.com/support/?ios_android=\(true)&app_lang=\(langStr == "ckb" ? "ku_central" : "en")")
                    } label: {
                        Text("support").font(.system(size: 14)).padding(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("link_text_color")).underline()
                    }
                    
                    NavigationLink {
                        WebViewView(url: "https://programnas.com/library/privacy/?ios_android=\(true)&app_lang=\(langStr == "ckb" ? "ku_central" : "en")")
                    } label: {
                        Text("privacy").font(.system(size: 14)).padding(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("link_text_color")).underline()
                    }
                }
                
                Text("© \(String(Calendar.current.component(.year, from: Date()))) \(langStr == "en" ? "Programnas Library" : "کتێبخانەی پرۆگرامناس")").font(.system(size: 14)).padding(/*@START_MENU_TOKEN@*/2.0/*@END_MENU_TOKEN@*/).foregroundColor(Color("link_text_color"))
                Spacer()
                
            }.padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
