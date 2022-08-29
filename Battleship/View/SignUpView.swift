//
//  SignUpView.swift
//  Battleship
//
//  Created by Phuc Nguyen Phuoc Nhu on 25/08/2022.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var game: Game
    
    @State var username: String = ""
    @State var password: String = ""
    @State var isLoggedIn = false
    @State var errorMessage = ""
    
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
                    
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .opacity(errorMessage.isEmpty ? 0 : 1)
                    
                    NavigationLink(destination: MenuView(), isActive: $isLoggedIn) {
                        Button(action: {
                            if (isInputValid(username: username, pwd: password)) {
                                signUp(username: username, pwd: password)
                            }
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
                .onAppear {
                    if game.isNavigatedBack {
                        self.presentation.wrappedValue.dismiss()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    /*
     Authentication
    */
   func signUp(username: String, pwd: String) {
       db.collection("users").document(username).setData([
           "pwd": pwd,
           "score": 0
       ]) { err in
           if let err = err {
               print("Error signing up document: \(err)")
           } else {
               print("Document signing up successfully written!")
               game.username = username
               game.fetchStateFromFirestore()
               game.reset()
               game.prevZoneStates.removeAll()
               self.isLoggedIn = true
               
               // For when user logs out after signing up
               game.isNavigatedBack = true
               
               // Set is logged out
               game.isLoggedOut = false
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
            errorMessage = "Username and password cannot be empty."
        }
        
        return isValid
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
