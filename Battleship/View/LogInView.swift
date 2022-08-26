//
//  LogInView.swift
//  Battleship
//
//  Created by Phuc Nguyen Phuoc Nhu on 25/08/2022.
//

import SwiftUI

struct LogInView: View {
    @EnvironmentObject var game: Game
    
    @State var username: String = ""
    @State var password: String = ""
    @State var isSignUpLinkActive = false
    @State var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                
                VStack {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .padding()
                        .background(.gray.opacity(0.2))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(.gray.opacity(0.2))
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                    
                    NavigationLink(destination: MenuView(), isActive: $isLoggedIn) {
                        Button(action: {
                            if (isInputValid(username: username, pwd: password)) {
                                logIn(username: username, pwd: password)
                            }
                            
                        }) {
                            HStack {
                                Spacer()
                                Text("Login").foregroundColor(Color.white).bold()
                                Spacer()
                            }
                        }
                        .accentColor(Color.black)
                        .padding()
                        .background(Color(UIColor.darkGray))
                        .cornerRadius(4.0)
                        .padding(Edge.Set.vertical, 20)
                    }
                    
                    NavigationLink(destination: SignUpView(), isActive: $isSignUpLinkActive) {
                        Button(action: {
                            self.isSignUpLinkActive = true
                        }) {
                            HStack {
                                Spacer()
                                Text("Sign Up").foregroundColor(Color.white).bold()
                                Spacer()
                            }
                        }
                        .accentColor(Color.black)
                        .padding()
                        .background(Color(UIColor.darkGray))
                        .cornerRadius(4.0)
                        .padding(Edge.Set.vertical, 20)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
                    return
                }
                if fetchedPwd == pwd {
                    game.username = username
                    game.fetchStateFromFirestore()
                    game.reset()
                    self.isLoggedIn = true
                }
            } else {
                print("User does not exist")
            }
        }
    }
    
    /*
     Validate input
     */
    func isInputValid(username: String, pwd: String) -> Bool {
        var isValid = true
        if (username.isEmpty || password.isEmpty) {
            isValid = false
        }
        
        return isValid
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
