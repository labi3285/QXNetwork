//
//  QXNetwork.Respond.swift
//  QXRequest
//
//  Created by labi3285 on 2017/11/8.
//  Copyright © 2017年 labi3285_lab. All rights reserved.
//

import Foundation

extension QXNetwork {
    
    /**
     *  QXRespond, defines of QXNetwork responds
     */
    public class Respond {
        
        /**
         *  the origin data output come from URLSession dataTask
         */
        public enum Origin {
            case succeed(data: Data?, response: URLResponse?, error: NSError?)
            case failed(error: QXNetwork.Error)
        }
        
        /**
         *  origin respond without handle, usually for debug
         */
        public func output(mainAsync: Bool, handler: @escaping (Respond.Origin) -> ()) {
            _URLSessionDataTaskResponseBridger = { data, response, nsError, error in
                QXNetwork.Respond.mainAsync(mainAsync) {
                    if let error = error {
                        handler(.failed(error: error))
                    } else {
                        handler(QXNetwork.Respond.Origin.succeed(data: data, response: response, error: nsError))
                    }
                }
            }
        }
        
        /*
         *  URLSession dataTask response bridger
         */
        var _URLSessionDataTaskResponseBridger: ((Data?, URLResponse?, NSError?, QXNetwork.Error?) -> ())?
        
    }
    
}

extension QXNetwork.Respond {
    
    /**
     *  the text format output
     */
    public enum Text {
        case succeed(text: String)
        case failed(error: QXNetwork.Error)
    }
    
    /**
     *  text output with coding
     */
    public func outputText(mainAsync: Bool, encoding: String.Encoding, handler: @escaping (QXNetwork.Respond.Text) -> ()) {
        func threadHandle(handler: @escaping (QXNetwork.Respond.Text) -> (), respond: QXNetwork.Respond.Text) {
            QXNetwork.Respond.mainAsync(mainAsync) {
                handler(respond)
            }
        }
        _URLSessionDataTaskResponseBridger = { [weak self] data, response, nsError, error in
            if let error = self?.detectError(response: response, nsError: nsError, error: error) {
                threadHandle(handler: handler, respond: .failed(error: error))
            } else if let data = data {
                if let text = String(data: data, encoding: encoding) {
                    threadHandle(handler: handler, respond: .succeed(text: text))
                } else {
                    threadHandle(handler: handler, respond: .failed(error: .encoding(isDecoding: true, detail: "QXNetwork.Error: can not decoding data to string. ctx:\(data)")))
                }
            } else {
                if let s = self {
                    threadHandle(handler: handler, respond: .failed(error: .unknown(detail: "QXNetwork.Error: data task without response, data nor error. ctx:\(s)")))
                }
            }
        }
    }
    
}

extension QXNetwork.Respond {
    
    /**
     *  the dictionary format output
     */
    public enum Dictionary {
        case succeed(dictionary: [String: Any])
        case failed(error: QXNetwork.Error)
    }
    
    
    /**
     *  dictionary output with parse
     */
    public func outputDictionary(mainAsync: Bool, handler: @escaping (QXNetwork.Respond.Dictionary) -> ()) {
        func threadHandle(handler: @escaping (QXNetwork.Respond.Dictionary) -> (), respond: QXNetwork.Respond.Dictionary) {
            QXNetwork.Respond.mainAsync(mainAsync) {
                handler(respond)
            }
        }
        _URLSessionDataTaskResponseBridger = { [weak self] data, response, nsError, error in
            if let error = self?.detectError(response: response, nsError: nsError, error: error) {
                threadHandle(handler: handler, respond: .failed(error: error))
            } else if let data = data {
                if let any = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                    if let dic = any as? [String: Any] {
                        threadHandle(handler: handler, respond: .succeed(dictionary: dic))
                    } else {
                        threadHandle(handler: handler, respond: .failed(error: .parse(detail: "QXNetwork.Error: json serialize result is not dictionary. ctx:\(any)")))
                    }
                } else {
                    threadHandle(handler: handler, respond: .failed(error: .parse(detail: "QXNetwork.Error: json serialize data to dictionary. ctx:\(data)")))
                }
            } else {
                if let s = self {
                    threadHandle(handler: handler, respond: .failed(error: .unknown(detail: "QXNetwork.Error: data task without response, data nor error. ctx:\(s)")))
                }
            }
        }
    }
    
}

extension QXNetwork.Respond {
    
    /**
     *  the array format output
     */
    public enum Array {
        case succeed(array: [Any])
        case failed(error: QXNetwork.Error)
    }
    


    /**
     *  array output with parse
     */
    public func outputArray(mainAsync: Bool, handler: @escaping (QXNetwork.Respond.Array) -> ()) {
        func threadHandle(handler: @escaping (QXNetwork.Respond.Array) -> (), respond: QXNetwork.Respond.Array) {
            QXNetwork.Respond.mainAsync(mainAsync) {
                handler(respond)
            }
        }
        _URLSessionDataTaskResponseBridger = { [weak self] data, response, nsError, error in
            if let error = self?.detectError(response: response, nsError: nsError, error: error) {
                threadHandle(handler: handler, respond: .failed(error: error))
            } else if let data = data {
                if let any = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                    if let arr = any as? [Any] {
                        threadHandle(handler: handler, respond: .succeed(array: arr))
                    } else {
                        threadHandle(handler: handler, respond: .failed(error: .parse(detail: "QXNetwork.Error: json serialize result is not array. ctx:\(any)")))
                    }
                } else {
                    threadHandle(handler: handler, respond: .failed(error: .parse(detail: "QXNetwork.Error: can not json serialize data to array. ctx:\(data)")))
                }
            } else {
                if let s = self {
                    threadHandle(handler: handler, respond: .failed(error: .unknown(detail: "QXNetwork.Error: data task without response, data nor error. ctx:\(s)")))
                }
            }
        }
    }
    
}


extension QXNetwork.Respond {
    
    /**
     *  detect Error base on response and error
     */
    func detectError(response: URLResponse?, nsError: NSError?, error: QXNetwork.Error?) -> QXNetwork.Error? {
        if let error = error {
            return error
        }
        if let error = nsError {
            return QXNetwork.Error.connect(error: error)
        } else if let response = response {
            if let response = response as? HTTPURLResponse {
                let code = response.statusCode
                if code >= 300 {
                    return QXNetwork.Error.http(code: code, response: response)
                }
            }
        }
        return nil
    }
    
    /**
     *  whether main async do work or not
     */
    static func mainAsync(_ mainAsync: Bool, _ work: @escaping @convention(block) () -> ()) {
        if mainAsync {
            if Thread.current.isMainThread {
                work()
            } else {
                DispatchQueue.main.async {
                    work()
                }
            }
        } else {
            work()
        }
    }
    
}

