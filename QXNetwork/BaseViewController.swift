//
//  BaseViewController.swift
//  QXNetwork
//
//  Created by labi3285 on 2017/11/9.
//  Copyright © 2017年 labi3285_lab. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var retryItem: UIBarButtonItem = {
        let one = UIBarButtonItem(title: "重试", style: .plain, target: self, action: #selector(retry))
        return one
    }()
    
    private var lastAttri = NSMutableAttributedString()
    @objc func retry() {
        let loading = NSAttributedString(string: ">>>>>>>>>>>>>>>>>>>>>>>>>>>\n请求中...\n", attributes: [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            ])
        func failed(err: QXNetwork.Error) -> NSAttributedString {
            return NSAttributedString(string: "\n\(err.message)\n", attributes: [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12),
                NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                ])
        }
        func theRequest(request: QXNetwork.Request) -> NSAttributedString {
            let prefix = NSAttributedString(string: "\n请求体:\n", attributes: [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12),
                NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
                ])
            let mAttri = NSMutableAttributedString()
            mAttri.append(prefix)
            mAttri.append(NSAttributedString(string: request.description + "\n", attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
                NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                ]))
            return mAttri
        }
        func succeed(text: String) -> NSAttributedString {
            let prefix = NSAttributedString(string: "\n请求成功:\n", attributes: [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12),
                NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
                ])
            let mAttri = NSMutableAttributedString()
            mAttri.append(prefix)
            mAttri.append(NSAttributedString(string: text + "\n", attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
                NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                ]))
            return mAttri
        }
        lastAttri.append(loading)
        textView.attributedText = lastAttri
        navigationItem.rightBarButtonItem = nil
        let request = loadData { [weak self] (text, err) in
            self?.navigationItem.rightBarButtonItem = self?.retryItem
            if let text = text {
                self?.lastAttri.append(succeed(text: text))
                self?.textView.attributedText = self?.lastAttri
            } else {
                let err = err ?? QXNetwork.Error.unknown(detail: "Error 没有内容的时候也没有错误，理论上不应该！")
                self?.lastAttri.append(failed(err: err))
                self?.textView.attributedText = self?.lastAttri
            }
        }
        lastAttri.append(theRequest(request: request))
        textView.attributedText = lastAttri
    }
    
    func loadData(done: ((_ succeed: String?, _ failed: QXNetwork.Error?) -> ())?) -> QXNetwork.Request {
        fatalError("需要子类实现方法")
    }
    
    private lazy var textView: UITextView = {
        let one = UITextView()
        one.isEditable = false
        return one
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(textView)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        textView.frame = view.bounds
    }

}
