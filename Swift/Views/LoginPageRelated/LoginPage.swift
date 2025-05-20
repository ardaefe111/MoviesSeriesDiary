//
//  LoginPage.swift
//  MovieSeriesDiary
//
//  Created by Emir Gökalp on 1.05.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginPage: View {
    @State var logging = false
    @State var registering = false
    @State var navigate = false
    @ObservedObject var vM: BindingPageViewModel
    @State var username = ""
    @State var email = ""
    @State var password1 = ""
    @State var password2 = ""
    var firstPage = true
    
    init(firstPage: Bool = true, vM: BindingPageViewModel = BindingPageViewModel()) {
        self.firstPage = firstPage
        self.vM = vM
    }
    
    var isEmailValid: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }

    // Login validation
    var loginValid: Bool {
        isEmailValid && password1.count >= 6
    }

    var isUsernameValid: Bool {
        let regex = "^(?!\\d+$)[a-zA-Z0-9_]{3,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: username)
    }

     
    // Register validation
    var registerValid: Bool {
        isEmailValid &&
        password1 == password2 &&
        password1.count >= 6 &&
        isUsernameValid
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                    VStack {
                        Text("Movie/Series\nDiary")
                            .font(.system(size: 30, weight: .bold))
                        
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 50)
                
                Spacer()
                
                if logging {
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    logging = false
                                }
                            } label: {
                                Image(systemName: "xmark")
                            }
                            .padding()
                        }
                        
                        VStack(spacing: 15) {
                            TextField("Email", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.bottom)
                                .autocapitalization(.none)
                            
                            SecureField("Password", text: $password1)
                                .textContentType(.password)
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        
                        
                        Button {
                            login()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Log in")
                                Spacer()
                            }
                            .padding(10)
                            .background(.accent)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .font(.headline)
                            .opacity(loginValid ? 1 : 0.7)
                            
                        }
                        .disabled(!loginValid)
                        .padding(.top, 30)
                        
                        Spacer()
                        
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.34)
                    .background(.black.opacity(0.75))
                    .cornerRadius(20)
                    .foregroundStyle(.text)
                    .onDisappear() {
                        email = ""
                        password1 = ""
                    }
                    .animation(.easeInOut(duration: 0.3), value: loginValid)
                    
                } else if registering {
                    
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    registering = false
                                }
                            } label: {
                                Image(systemName: "xmark")
                            }
                            .padding()
                        }
                        
                        VStack(spacing: 15) {
                            TextField("Email", text: $email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.bottom)
                                .autocapitalization(.none)
                            
                            TextField("Unique Username", text: $username)
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.bottom)
                                .autocapitalization(.none)
                            
                            SecureField("Password", text: $password1)
                                .textContentType(.password)
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                                .padding(.bottom)
                            
                            SecureField("Password again", text: $password2)
                                .textContentType(.password)
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        
                        
                        Button {
                            register()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Register")
                                Spacer()
                            }
                            .padding(10)
                            .background(Color("secondAccentColor"))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .font(.headline)
                            .opacity(registerValid ? 1 : 0.7)
                            .padding(.bottom)
                            
                        }
                        .disabled(!registerValid)
                        .padding(.top, 20)
                        
                        Spacer()
                        
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.47)
                    .background(.black.opacity(0.75))
                    .cornerRadius(20)
                    .foregroundStyle(.text)
                    .onDisappear() {
                        username = ""
                        email = ""
                        password1 = ""
                        password2 = ""
                    }
                    .animation(.easeInOut(duration: 0.3), value: registerValid)
                    
                } else {
                    Text("Track everything you watch.\nStay organized, stay inspired.")
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .foregroundStyle(.text.opacity(0.75))
                }
                Spacer()
                
                if !logging && !registering {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            logging = true
                        }
                    } label: {
                        Text("Log in")
                            .font(.headline)
                            .padding(10)
                            .padding(.horizontal, 70)
                            .background(.accent)
                            .cornerRadius(10)
                    }
                    .padding(.vertical, 10)
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            registering = true
                        }
                    } label: {
                        Text("Register")
                            .font(.headline)
                            .padding(10)
                            .padding(.horizontal, 70)
                            .background(Color("secondAccentColor"))
                            .cornerRadius(10)
                    }
                    .padding(.vertical, 10)
                    
                    if firstPage {
                        
                        HStack {
                            Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                            Text("or")
                                .foregroundColor(.gray)
                            Rectangle().frame(height: 1).foregroundColor(.gray.opacity(0.3))
                        }
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                        
                        Button {
                            navigate = true
                        } label: {
                            Text("Continue without an account")
                        }
                        .padding(.vertical, 10)
                        .padding(.bottom)
                    }
                }
            }
            .foregroundStyle(.text)
            .background(
                ZStack {
                    if firstPage {
                        NavigationLink(
                            destination: BindingPage(vM: vM).navigationBarBackButtonHidden(),
                            isActive: $navigate,
                            label: {
                                EmptyView()
                            }
                        )
                        .onAppear {
                            vM.fetchEverything()
                            if vM.user != nil {
                                navigate = true
                            }
                           // login()
                        }
                    }
                    
                    Image("backgroundImage")
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 20)  
                        .opacity(0.3)
                    Color.back.opacity(0.3)
                }
                    .ignoresSafeArea()
            )
        }
        .tint(Color("textColor"))
    } 
    
    func login() {
//        var emaill = "emirhangok@icloud.com"
  //      var password = "123123"
        Auth.auth().signIn(withEmail: email, password: password1) { result, error in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")

            } else {
                print("Login successful! UID: \(result?.user.uid ?? "unknown")")
                
                vM.fetchUserData(email: email) { _ in
                    navigate = true
                }
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password1) { result, error in
            if let error = error {
                print("Registration error: \(error.localizedDescription)")
                // Optionally show alert or error to user
            } else {
                var data: [String:Any] = [
                    "email": email.lowercased()
                ]
                Firestore.firestore().collection("users").document(username.lowercased()).setData(data)
                
                var user = User(id: username, email: email, watchLaterIds: [], alreadyWatchedIds: [], ratings: [], comments: [])
                
                vM.user = user

                DispatchQueue.main.async {
                    navigate = true
                }
                
            }
        }
    }
}

#Preview {
    LoginPage()
}
