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
    @State var isUsernameTaken = false
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    Color("LogInBackgroundColor")
                    
                    VStack {
                        Text("Welcome on board!")
                             .font(.largeTitle)
                         Spacer()
                        
                        VStack {
                            TextField("Username", text: $username)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color("InputBackgroundColor"))
                                .border(Color("SecondaryColor"), width: 3)

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
                        
                        NavigationLink(destination: MenuView(), isActive: $isLoggedIn) {
                            Button(action: {
                                if (isInputValid(username: username, pwd: password) && !isUsernameTaken) {
                                    signUp(username: username, pwd: password)
                                }
                            }) {
                                HStack {
                                    Spacer()
                                    Text("Sign Up").foregroundColor(Color.white).bold()
                                    Spacer()
                                }
                            }
                            .padding()
                            .background(Color("AccentColor"))
                        }
                    }
                    .padding(.top, 100)
                    .padding(.bottom, 60)
                    .padding(.horizontal, 20)
                    .frame(maxWidth: geo.size.width > 700 ? 500 : 350)
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
        if (username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            isValid = false
            errorMessage = "Input cannot be empty!"
            return false
        }
        
//        let docRef = db.collection("users").document(username)
//         docRef.getDocument { (document, error) in
//             if let document = document, document.exists {
//                 // let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                 // print("Document data: \(dataDescription)")
//                 errorMessage = "Username already exists. Signing in."
//                 isUsernameTaken = true
//             } else {
//                 isUsernameTaken = false
//             }
//         }
        
        let docRef = db.collection("users").document(username)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let fetchedPwd = document.get("pwd") as? String else {
                    print("Cannot parse Pwd from document")
                    errorMessage = "Username already exists. Invalid password."
                    isUsernameTaken = true
                    return
                }
                if fetchedPwd == password {
                    errorMessage = "Username already exists. Signing in."
                    return
                } else {
                    errorMessage = "Username already exists. Invalid password."
                    isUsernameTaken = true
                }
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
