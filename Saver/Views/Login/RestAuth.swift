//
//  RestAuth.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 14.01.2023.
//

//import Foundation
//import Alamofire
//
//class RestAuth: RestCalls {
//    func login(login: String,
//               password: String,
//               name: String = "",
//               success: @escaping (AuthModel) -> (),
//               failure: ((String?, Error?)->())?) {
//        
//        let params = ["login": login,
//                      "password": password]
//        
//        self.call(model: AuthModel.self, path: RestSuffix.Auth.login().getURL(), method: .post, name: name, params: params, success: { (model) in
//            success(model)
//        }, error: { (error) in
//            if let failure = failure {
//                failure(error["error"] as? String ?? "Trouble", nil)
//            }
//            debugPrint(#function, error)
//        }) { (error) in
//            if let failure = failure {
//                failure(nil, error)
//            }
//            debugPrint(#function, error.localizedDescription)
//        }
//    }
//}
