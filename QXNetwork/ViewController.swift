//
//  ViewController.swift
//  QXNetwork
//
//  Created by labi3285 on 2017/11/9.
//  Copyright © 2017年 labi3285_lab. All rights reserved.
//

import UIKit

class TestItem {
    let name: String
    let vcName: String
    init(_ name: String, _ vcName: String) {
        self.name = name
        self.vcName = vcName
    }
}

class ViewController: UITableViewController {

    lazy var items: [TestItem] = [
        TestItem("GET", "GET_VC"),
        TestItem("POST-表单", "POST_FORM_VC"),
        TestItem("POST-文件表单", "POST_FORMDATA_VC"),
        TestItem("POST-自定义", "POST_RAW_VC"),
        TestItem("POST-单文件", "POST_BIN_VC"),
        TestItem("POST(扩展)-字典", "POST_DIC_VC"),
        TestItem("POST(扩展)-数组", "POST_ARR_VC"),

    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.rowHeight = 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let _cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") {
            cell = _cell
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        }
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.vcName
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if let vcClass = NSClassFromString("QXNetwork." + item.vcName) as? UIViewController.Type {
            let vc = vcClass.init()
            vc.title = item.name
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

