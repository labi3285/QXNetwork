//
//  POST_FORMDATA_VC.swift
//  QXNetwork
//
//  Created by labi3285 on 2017/11/9.
//  Copyright © 2017年 labi3285_lab. All rights reserved.
//

import UIKit

class POST_FORMDATA_VC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retry()
    }
    
    override func loadData(done: ((String?, QXNetwork.Error?) -> ())?) -> QXNetwork.Request {
        
        let request = QXNetwork.Request()
        request.method = .POST
        request.URLString = "http://httpbin.org/post"
        request.headers = [
            "User_head0": "head 0",
            "User_head1": "head 1"
        ]
        request.URLParameters = [
            "user_params0": "0",
            "user_params1": "1"
        ]
        
        let imageData0 = UIImageJPEGRepresentation(UIImage(named: "image0")!, 1)!
        let imageData1 = UIImageJPEGRepresentation(UIImage(named: "image1")!, 1)!

        request.body = QXNetwork.Request.Body.formData(formDatas: [
            QXNetwork.Request.FormData(name: "userForm0", data: "hello form!"),
            QXNetwork.Request.FormData(name: "userForm1", data: "hello form!"),
            QXNetwork.Request.FormData(name: "image0", data: imageData0),
            QXNetwork.Request.FormData(name: "image1", data: imageData1),
        ], boundary: nil)
        
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

