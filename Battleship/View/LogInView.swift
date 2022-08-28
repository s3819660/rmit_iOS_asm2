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
    @State var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                
                VStack {
                    Text("Welcome back, commander!")
                        .font(.largeTitle)
                    Spacer()
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .padding()
                        .background(.white)
                        // .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        .border(Color("SecondaryColor"))
                    SecureField("Password", text: $password)
                        .padding()
                        .background(.white)
                        // .cornerRadius(5.0)
                        .padding(.bottom, 20)
                        .border(Color("SecondaryColor"))
                    Text(errorMessage)
                        .foregroundColor(Color("ErrorMessageColor"))
                        .opacity(errorMessage.isEmpty ? 0 : 1)
                    
                    NavigationLink(destination: MenuView(), isActive: $isLoggedIn) {
                        Button(action: {
                            if (isInputValid(username: username, pwd: password)) {
                                logIn(username: username, pwd: password)
                                game.isLoggedOut = false
                            }
                            
                        }) {
                            HStack {
                                Spacer()
                                Text("Log In").foregroundColor(Color.white).bold()
                                Spacer()
                            }
                        }
                        .accentColor(Color.white)
                        .padding()
                        .background(Color("AccentColor"))
                        // .cornerRadius(4.0)
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 25).stroke(Color("AccentColor"), lineWidth: 2)
                        )
                        .accentColor(Color.white)
                        .padding()
                        .background(Color.clear)
                        .cornerRadius(25)
                        .padding(Edge.Set.vertical, 20)
                        .border(Color("AccentColor"), width: 4)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .padding()
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
                    errorMessage = "Invalid password! Please enter again."
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
                errorMessage = "Username does not exist!"
            }
        }
    }
    
    /*
     Validate input
     */
    func isInputValid(username: String, pwd: String) -> Bool {
        var isValid = true
        if (username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            isValid = false
            errorMessage = "Username and password cannot be empty!"
        }
        
        return isValid
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
