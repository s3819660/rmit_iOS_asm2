//
//  LogInView.swift
//  Battleship
//
//  Created by Phuc Nguyen Phuoc Nhu on 25/08/2022.
//

import SwiftUI

struct LogInView: View {
    @EnvironmentObject var game: Game
    
    @State var username: String = "nhu"
    @State var password: String = "1234"
    @State var errorMessage = ""
    @State var isSignUpLinkActive = false
    @State var isLoggedIn = false
    
    var body: some View {
            
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    Color("LogInBackgroundColor")
                    
                    VStack {
                        Text("Welcome back, commander!")
                             .font(.largeTitle)
                         Spacer()
                        
                        VStack {
                            TextField("Username", text: $username)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color("InputBackgroundColor"))

                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color("InputBackgroundColor"))
//                                    .padding(.bottom, 10)
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .opacity(errorMessage.isEmpty ? 0 : 1)
                                .frame(height: 30)
                                .frame(maxWidth: .infinity, alignment: .leading)
//                                    .padding(.bottom, 16)

                        }
                        .frame(maxWidth: geo.size.width > 700 ? 500 : 350)
                        .onChange(of: self.username, perform: { (value) in
                            self.errorMessage = ""
                        })
                        .onChange(of: self.password, perform: { (value) in
                            self.errorMessage = ""
                        })
                        
                        VStack {
                            NavigationLink(destination: MenuView(), isActive: $isLoggedIn) {
                                Button(action: {
                                    if (isInputValid(username: username, pwd: password)) {
                                        logIn(username: username, pwd: password)
                                    }
                                    
                                }) {
                                    HStack {
                                        Spacer()
                                        Text("Log In").foregroundColor(Color.white).bold()
                                        Spacer()
                                    }
                                }
        //                        .accentColor(Color.white)
                                .padding()
                                .background(Color("AccentColor"))
//                                    .padding(Edge.Set.bottom, 20)
                            }
                            
                            NavigationLink(destination: SignUpView(), isActive: $isSignUpLinkActive) {
                                Button(action: {
                                    self.isSignUpLinkActive = true
                                }) {
                                    HStack {
                                        Spacer()
                                        Text("Sign Up").foregroundColor(Color("AccentColor")).bold()
                                        Spacer()
                                    }
                                }
        //                        .accentColor(Color("AccentColor"))
                                .padding()
                                .background(Color.clear)
                                .border(Color("AccentColor"), width: 3)
                                .padding(Edge.Set.bottom, 20)
                            }
                        }
                        .frame(maxWidth: geo.size.width > 700 ? 500 : 350)
                    }
                    .padding(.top, 100)
                    .padding(.bottom, 60)
                    .padding(.horizontal, 20)
                }
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    /*
     Authentication
     */
    func logIn(username: String, pwd: String) {
        let docRef = db.collection("users").document(username)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let fetchedPwd = document.get("pwd") as? String else {
                    print("Cannot parse Pwd from document")
                    errorMessage = "Invalid password! Please enter again."
                    return
                }
                if fetchedPwd == pwd {
                    game.username = username
                    game.fetchStateFromFirestore()
                    game.reset()
                    self.isLoggedIn = true
                    
                    // Set is logged out
                    game.isLoggedOut = false
                } else {
                    errorMessage = "Invalid password! Please enter again."
                    return
                }
            } else {
                print("User does not exist")
                errorMessage = "Username does not exist!"
                return
            }
        }
    }
    
    /*
     Validate input
     */
    func isInputValid(username: String, pwd: String) -> Bool {
        var isValid = true
        if (username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            errorMessage = "Input cannot be empty!"
            isValid = false
        }
        
        return isValid
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
