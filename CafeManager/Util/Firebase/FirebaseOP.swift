//
//  FirebaseOP.swift
//  CafeManager
//
//  Created by Hishara Dilshan on 2021-04-28.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseOP {
    //Class instance
    static var instance = FirebaseOP()
    
    var dbRef: DatabaseReference!
    let networkChecker = NetworkMonitor.instance
    
    //Class Delegate
    var delegate: FirebaseActions?
    
    //Make Singleton
    fileprivate init() {}
    
    func checkConnection() -> Bool {
        if !networkChecker.isReachable {
            delegate?.onConnectionLost()
            return false
        }
        return true
    }
    
    private func getDBReference() -> DatabaseReference {
        guard dbRef != nil else {
            dbRef = Database.database().reference()
            return dbRef
        }
        return dbRef
    }
    
    // MARK: - User Based Operations
    
    fileprivate func checkExistingUser(email: String, completion: @escaping (Bool, String, DataSnapshot) -> Void) {
        if !checkConnection() {
            return
        }
        let email = email.replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "@", with: "_")
        self.getDBReference().child("users").child(email).observeSingleEvent(of: .value, with: {
            snapshot in
            if snapshot.hasChildren() {
                if let userData = snapshot.value as? [String: Any] {
                    if userData[UserKeys.type] as? String != "manager" {
                        completion(false, "User does not exists", snapshot)
                        return
                    }
                }
                completion(true, "User already exists.", snapshot)
            } else {
                completion(false, "User does not exists", snapshot)
            }
        })
    }
    
    fileprivate func setUpAuthenticationAccount(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        if !checkConnection() {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            result, error in
            if let error = error {
                NSLog(error.localizedDescription)
                NSLog("Creation of authentication account failed")
                completion(false, "Could not create user account")
            } else {
                completion(true, "Created authentication account")
                NSLog(result?.description ?? "")
            }
        })
    }
    
    fileprivate func createUserOnDB(user: User, completion: @escaping (Bool, String?, User?) -> Void) {
        if !checkConnection() {
            return
        }
        guard let userName = user.userName, let email = user.email, let phoneNo = user.phoneNo else {
            NSLog("Empty params found on user instance")
            completion(false, "Empty params found on user instance", user)
            return
        }
        
        let data = [
            UserKeys.userName : userName,
            UserKeys.email : email,
            UserKeys.phoneNo : phoneNo,
            UserKeys.type : "manager"
        ]
        
        self.getDBReference()
            .child("users")
            .child(email.replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "@", with: "_"))
            .setValue(data) {
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    completion(false, "Failed to create user", user)
                    NSLog(error.localizedDescription)
                } else {
                    completion(true, nil, user)
                }
            }
    }
    
    func registerUser(user: User) {
        if !checkConnection() {
            return
        }
        guard let email = user.email, let password = user.password else {
            NSLog("Empty params found on user instance")
            self.delegate?.isSignUpFailedWithError(error: FieldErrorCaptions.userRegistrationFailedError)
            return
        }
        
        self.checkExistingUser(email: email, completion: {
            userExistance, result, data in
            if userExistance {
                self.delegate?.isExisitingUser(error: FieldErrorCaptions.userAlreadyExistsError)
                return
            }
            
            self.setUpAuthenticationAccount(email: email, password: password, completion: {
                authOperation, result in
                
                if !authOperation {
                    self.delegate?.isSignUpFailedWithError(error: FieldErrorCaptions.userRegistrationFailedError)
                    return
                }
                
                self.createUserOnDB(user: user, completion: {
                    userCreation, result, user in
                    
                    if userCreation {
                        self.delegate?.isSignUpSuccessful(user: user)
                    } else {
                        self.delegate?.isSignUpFailedWithError(error: FieldErrorCaptions.userRegistrationFailedError)
                    }
                })
            })
        })
    }
    
    func signInUser(email: String, password: String) {
        if !checkConnection() {
            return
        }
        self.checkExistingUser(email: email, completion: {
            userExistance, result, data in
            
            if userExistance {
                
                Auth.auth().signIn(withEmail: email, password: password, completion: {
                    authResult, error in
                    
                    if let error = error {
                        self.delegate?.onUserSignInFailedWithError(error: error.localizedDescription)
                        NSLog(error.localizedDescription)
                    } else {
                        if let userData = data.value as? [String: Any] {
                            NSLog("Successful sign-in")
                            self.delegate?.onUserSignInSuccess(user: User(
                                                                _id: nil,
                                                                userName: userData[UserKeys.userName] as? String,
                                                                email: userData[UserKeys.email] as? String,
                                                                phoneNo: userData[UserKeys.phoneNo] as? String,
                                                                password: userData[UserKeys.password] as? String, imageRes: ""))
                        } else {
                            NSLog("Unable to serialize user data")
                            self.delegate?.onUserSignInFailedWithError(error: FieldErrorCaptions.userSignInFailedError)
                        }
                    }
                })
            } else {
                NSLog("User not registered")
                self.delegate?.onUserSignInFailedWithError(error: FieldErrorCaptions.userNotRegisteredError)
            }
        })
    }
    
    func sendResetPasswordRequest(email: String) {
        if !checkConnection() {
            return
        }
        self.checkExistingUser(email: email, completion: {
            userExistance, result, data in
            
            if !userExistance {
                self.delegate?.onResetPasswordEmailSentFailed(error: FieldErrorCaptions.userNotRegisteredError)
                return
            }
            
            Auth.auth().sendPasswordReset(withEmail: email, completion: {
                error in
                
                if let error = error {
                    NSLog(error.localizedDescription)
                    self.delegate?.onResetPasswordEmailSentFailed(error: FieldErrorCaptions.userResetPasswordFailed)
                    return
                }
                
                self.delegate?.onResetPasswordEmailSent()
            })
            
        })
    }
    
}
// MARK: - List of Protocol handlers

protocol FirebaseActions {
    
    func onConnectionLost()
    
    func isSignUpSuccessful(user: User?)
    func isExisitingUser(error: String)
    func isSignUpFailedWithError(error: Error)
    func isSignUpFailedWithError(error: String)
    
    func onUserDataUpdated(user: User?)
    func onUserUpdateFailed(error: String)
    
    func onPasswordChanged()
    func onPasswordChangeFailedWithError(error: String)
    
    func onUserNotRegistered(error: String)
    func onUserSignInSuccess(user: User?)
    func onUserSignInFailedWithError(error: Error)
    func onUserSignInFailedWithError(error: String)
    
    func onResetPasswordEmailSent()
    func onResetPasswordEmailSentFailed(error: String)
}

// MARK: - Protocol Extensions

extension FirebaseActions {
    func isSignUpSuccessful(user: User?){}
    func isExisitingUser(error: String){}
    func isSignUpFailedWithError(error: Error){}
    func isSignUpFailedWithError(error: String){}
    
    func onUserDataUpdated(user: User?) {}
    func onUserUpdateFailed(error: String) {}
    
    func onPasswordChanged() {}
    func onPasswordChangeFailedWithError(error: String) {}
    
    func onUserNotRegistered(error: String){}
    func onUserSignInSuccess(user: User?){}
    func onUserSignInFailedWithError(error: Error){}
    func onUserSignInFailedWithError(error: String){}
    
    func onResetPasswordEmailSent(){}
    func onResetPasswordEmailSentFailed(error: String){}
}
