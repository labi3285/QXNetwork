//
//  swift
//  QXRequest
//
//  Created by labi3285 on 2017/11/7.
//  Copyright © 2017年 labi3285_lab. All rights reserved.
//

import Foundation

/**
 *  QXNetwork, foundation of QXNetwork
 */
public class QXNetwork: NSObject {
    
    /*
     *  shared instance
     */
    public static let shared = QXNetwork()
    
    /*
     *  init
     */
    public override init() {
        super.init()
    }
    
    /**
     *  begin a new request task
     */
    @discardableResult public func beginTask(with request: Request) -> Task {
        let task = QXNetwork.Task()
        let request = request.makeupRequest()
        task.request = request.request

        if let error = request.error {
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                task._URLSessionDataTaskResponseBridger?(nil, nil, nil, error)
            })
        } else {
            if let request = request.request {
                let _task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    task._URLSessionDataTaskResponseBridger?(data, response, error as NSError?, nil)
                })
                _task.resume()
                task.task = _task
            }
        }
        
        return task
    }
    
}

