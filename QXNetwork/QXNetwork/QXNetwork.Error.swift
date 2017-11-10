//
//  QXNetwork.Error.swift
//  QXRequest
//
//  Created by labi3285 on 2017/11/8.
//  Copyright © 2017年 labi3285_lab. All rights reserved.
//

import Foundation

extension QXNetwork {
    
    /**
     *  error for output
     */
    public enum Error {
        /* error request */
        case request(detail: String)
        /* error connection */
        case connect(error: NSError)
        /* response error */
        case http(code: Int, response: URLResponse)
        /* error encoding or decoding string */
        case encoding(isDecoding: Bool, detail: String)
        /* error parse json */
        case parse(detail: String)
        /* error unknown */
        case unknown(detail: String)
    }
    
}

extension QXNetwork.Error: CustomStringConvertible {
    public var description: String {
        return "QXNetwork.Error:\(self.message)"
    }
}

extension QXNetwork.Error {
    
    /**
     *  error friendly tip for show
     */
    var message: String {
        switch self {
        case .request(detail: _):
            return "网址无效"
        case .connect(error: let err):
            return "网络错误(\(err.code))"
        case .http(code: let code, response: _):
            return "请求错误(\(code))"
        case .encoding(isDecoding: _, detail: _):
            return "编码错误"
        case .parse(detail: _):
            return "解析错误"
        case .unknown(detail: _):
            return "未知错误"
        }
    }
    
    /**
     *  error detail for debug
     */
    var debugMessage: String {
        switch self {
        case .request(detail: let detail):
            return "请求无效(\(detail))"
        case .connect(error: let err):
            return "网络错误(\(err.code))\(err.localizedDescription)\(err.domain)"
        case .http(code: let code, response: _):
            if let idx = QXNetwork.Error.httpStatusCodes.index(where: { $0.code == code }) {
                let err = QXNetwork.Error.httpStatusCodes[idx]
                return "请求错误(\(code))" + err.message + "/n" + err.detail
            } else {
                return "请求错误(\(code))未知错误"
            }
        case .encoding(isDecoding: let isDecoding, detail: let detail):
            return isDecoding ? "解码错误(\(detail))": "编码错误(\(detail))"
        case .parse(detail: let detail):
            return "解析错误(\(detail))"
        case .unknown(detail: let detail):
            return "未知错误(\(detail))"
        }
    }
    
    /**
     *  the http standard status code
     */
    static let httpStatusCodes: [(code: Int, message: String, detail: String)] = [
        (100, "继续", "请求者应当继续提出请求。 服务器返回此代码表示已收到请求的第一部分，正在等待其余部分。"),
        (101, "切换协议", "请求者已要求服务器切换协议，服务器已确认并准备切换。"),
        (200, "成功", "服务器已成功处理了请求。 通常，这表示服务器提供了请求的网页。"),
        (201, "已创建", "请求成功并且服务器创建了新的资源。"),
        (202, "已接受", "服务器已接受请求，但尚未处理。"),
        (203, "非授权信息", "服务器已成功处理了请求，但返回的信息可能来自另一来源。"),
        (204, "无内容", "服务器成功处理了请求，但没有返回任何内容。"),
        (205, "重置内容", "服务器成功处理了请求，但没有返回任何内容。"),
        (206, "部分内容", "服务器成功处理了部分 GET 请求。"),
        (400, "错误请求", "服务器不理解请求的语法。"),
        (401, "未授权", "请求要求身份验证。 对于需要登录的网页，服务器可能返回此响应。"),
        (403, "禁止", "服务器拒绝请求。"),
        (404, "未找到", "服务器找不到请求的网页。"),
        (405, "方法禁用", "禁用请求中指定的方法。"),
        (406, "不接受", "无法使用请求的内容特性响应请求的网页。"),
        (407, "需要代理授权", "此状态代码与 401（未授权）类似，但指定请求者应当授权使用代理。"),
        (408, "请求超时", "服务器等候请求时发生超时。"),
        (409, "冲突", "服务器在完成请求时发生冲突。 服务器必须在响应中包含有关冲突的信息。"),
        (410, "已删除", "如果请求的资源已永久删除，服务器就会返回此响应。"),
        (411, "需要有效长度", "服务器不接受不含有效内容长度标头字段的请求。"),
        (412, "未满足前提条件", "服务器未满足请求者在请求中设置的其中一个前提条件。"),
        (413, "请求实体过大", "服务器无法处理请求，因为请求实体过大，超出服务器的处理能力。"),
        (414, "请求的URI过长", "请求的URI（通常为网址）过长，服务器无法处理。"),
        (415, "不支持的媒体类型", "请求的格式不受请求页面的支持。"),
        (416, "请求范围不符合要求", "如果页面无法提供请求的范围，则服务器会返回此状态代码。"),
        (417, "未满足期望值", "服务器未满足”期望”请求标头字段的要求。"),
        (500, "服务器内部错误", "服务器遇到错误，无法完成请求。"),
        (501, "尚未实施", "服务器不具备完成请求的功能。 例如，服务器无法识别请求方法时可能会返回此代码。"),
        (502, "错误网关", "服务器作为网关或代理，从上游服务器收到无效响应。"),
        (503, "服务不可用", "服务器目前无法使用（由于超载或停机维护）。 通常，这只是暂时状态。"),
        (504, "网关超时", "服务器作为网关或代理，但是没有及时从上游服务器收到请求。"),
        (505, "HTTP版本不受支持", "服务器不支持请求中所用的HTTP协议版本。")
    ]
    
}





