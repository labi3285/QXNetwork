//
//  GET_ViewController.swift
//  QXNetwork
//
//  Created by labi3285 on 2017/11/9.
//  Copyright © 2017年 labi3285_lab. All rights reserved.
//

import UIKit

class GET_VC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        retry()
    }
    
    override func loadData(done: ((String?, QXNetwork.Error?) -> ())?) -> QXNetwork.Request {
        
        let request = QXNetwork.Request()
        request.method = .GET
        request.URLString = "https://httpbin.org/get"
        request.headers = [
            "User_head0": "head 0",
            "User_head1": "head 1"
        ]
        request.URLParameters = [
            "user_params0": "0",
            "user_params1": "1"
        ]
        
        request
            .beginTask()
            .respond
            .outputText(mainAsync: true, encoding: .utf8) { (result) in
                switch result {
                case .succeed(text: let text):
                    done?(text, nil)
                case .failed(error: let err):
                    done?(nil, err)
                }
        }

        return request
        
    }

}
