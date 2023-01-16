//
//  RestCalls.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 14.01.2023.
//

//import Foundation
//import Alamofire
//
//class RestCalls {
//
//    // MARK: -
//    // MARK: session
//
//    static let sessionManager:  Session = {
//        return Alamofire.Session.default
//    }()
//
//    static var isDebugPrint: Bool = true
//
//    //MARK: -
//    //MARK: model
//
//    func call <Model> (model type: Model.Type,
//                       path: String,
//                       method: RestMethod,
//                       loader: Bool = true,
//                       encoding: ParameterEncoding = JSONEncoding.default,
//                       name: String,
//                       params: [String:Any]? = nil,
//                       headers: [String:String] = [:],
//                       success:@escaping (Model)->(),
//                       error: @escaping ([String : Any])->(),
//                       failure:@escaping (Error)->()) where Model: Codable {
//
//        let request = RestCalls.sessionManager.request(path,
//                                                       method: RestMethod.toAlamofile(method),
//                                                       parameters: params,
//                                                       encoding: encoding,
//                                                       headers: HTTPHeaders(headers)).validate().responseDecodable { (response: DataResponse<Model, AFError>) in
//
//                                                        /// print
//                                                        self.printResponse(response: response, params: params)
//                                                        /// parsing
//                                                        self.parseResponse(response: response, success: { (result) in
//                                                            success(result)
//                                                        }, successError: { errorModel in
//                                                            error(errorModel)
//                                                        }, failure: { error in
//                                                            failure(error)
//                                                        })
//        }
//        request.task?.taskDescription = name
//    }
//}
//
//
////MARK: - print
//extension RestCalls {
//
//    func printResponse <T: Codable> (response: DataResponse<T, AFError>, params: [String: Any]?) {
//        printRequest(request: response.request,
//                     data: response.data,
//                     params: params)
//    }
//
//    func printRequest(request: URLRequest?, data: Data?, params: [String: Any]?) {
//
//        if !RestCalls.isDebugPrint { return }
//
//        debugPrint("=====================REQUEST=============================")
//        debugPrint("send to server:", request?.httpMethod ?? "", request?.url?.absoluteString ?? "<url is nil>")
//        debugPrint("headers:", request?.allHTTPHeaderFields ?? "<headers is empty>")
//        debugPrint("body:", params ?? "<body is empty>")
//        if let data = data,
//           let json = try? JSONSerialization.jsonObject(with: data, options : .allowFragments) {
//            debugPrint("data:", json )
//        } else {
//            debugPrint("data:", "<data is empty>" )
//        }
//        debugPrint("==========================================================")
//    }
//}
//
////MARK: - print
//extension RestCalls {
//
//    func parseResponse <Model:Codable> (response: DataResponse<Model, AFError>,
//                                        success:@escaping (Model)->(),
//                                        successError: @escaping ([String : Any])->(),
//                                        failure:@escaping (Error)->()) {
//
//        switch response.result {
//        case .success (let item):
//            success(item)
//        case .failure(let errorResponce):
//            if let data = response.data {
//                do {
//                    if let baseError = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
//                        successError(baseError)
//                    } else {
//                        failure(errorResponce)
//                    }
//                } catch {
//                    failure(error)
//                }
//            } else {
//                failure(errorResponce)
//            }
//        }
//    }
//}
