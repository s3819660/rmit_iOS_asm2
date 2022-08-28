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
                    Text("Welcome on board!")
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
                                signUp(username: username, pwd: password)
                                game.isLoggedOut = false
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
                        .background(Color("AccentColor"))
                        // .cornerRadius(4.0)
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
               errorMessage = "Cannot sign up due to connection error!"
           } else {
               print("Document signing up successfully written!")
               game.username = username
               game.fetchStateFromFirestore()
               game.reset()
               game.prevZoneStates.removeAll()
               self.isLoggedIn = true
               
               // For when user logs out after signing up
               game.isNavigatedBack = true
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

        let docRef = db.collection("users").document(username)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                // print("Document data: \(dataDescription)")
                
                isValid = false
                errorMessage = "Username already exists!"
            }
        }
        
        return isValid
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
