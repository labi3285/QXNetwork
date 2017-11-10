//
//  Task.swift
//  QXRequest
//
//  Created by labi3285 on 2017/11/8.
//  Copyright © 2017年 labi3285_lab. All rights reserved.
//

import Foundation

extension QXNetwork {
    
    /**
     *  network task with result handlers for choose
     */
    public class Task {
        
        /**
         *  origin URLSessionDataTask made in QXNetwork, never change it in bussiness
         */
        public var task: URLSessionDataTask?
        
        /**
         *  origin request, never change it in bussiness
         */
        public var request: URLRequest?
        
        /*
         *  URLSession dataTask response bridgers
         */
        var _URLSessionDataTaskResponseBridger: ((Data?, URLResponse?, NSError?, QXNetwork.Error?) -> ())?
        
    }
    
}

extension QXNetwork.Task {
    
    /**
     *  origin data responder
     */
    public var respond: QXNetwork.Respond {
        let respond = QXNetwork.Respond()
        _URLSessionDataTaskResponseBridger = { data, response, nsError, error in
            respond._URLSessionDataTaskResponseBridger?(data, response, nsError, error)
        }
        return respond
    }
    
}

