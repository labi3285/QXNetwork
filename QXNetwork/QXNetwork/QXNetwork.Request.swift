//
//  QXNetwork.Request.swift
//  QXRequest
//
//  Created by labi3285 on 2017/11/8.
//  Copyright © 2017年 labi3285_lab. All rights reserved.
//

import Foundation

extension QXNetwork {
    
    /**
     *  defines of QXNetwork requests
     */
    public class Request {
        
        /**
         *  request methods types
         */
        public enum Method {
            case GET
            case POST
            case PUT
            case PATCH
            case DELETE
            case COPY
            case HEAD
            case OPTIONS
            case LINK
            case UNLINK
            case PURGE
            case LOCK
            case UNLOCK
            case PROPFIND
            case VIEW
        }
        
        /**
         *  FormData element
         */
        public class FormData {
            var name: String
            var data: Any
            var disposition: String?
            var fileName: String?
            var mimeType: String?
            var contentTransferEncoding: String?
            init(name: String, data: Any) {
                self.name = name
                self.data = data
            }
        }
        
        /**
         *  request body types
         */
        public enum Body {
            /// form data, support String/Int/Double... and Data values, utf8 encoding
            case formData(formDatas: [FormData], boundary: String?)
            /// key value, ignore if key or value is empty, utf8 encoding
            case form(keyValues: [String: Any])
            /// customise text
            case raw(text: String, encoding: String.Encoding, contentType: String?)
            /// single binary data
            case binary(data: Data)
            
            /// format http body failed came to this, not for use outside
            case error(error: QXNetwork.Error)
        }
        
        /**
         *  request url string, requried
         */
        public var URLString: String?
        
        /**
         *  request method, requried
         */
        public var method: Method = .GET
        
        /**
         *  request parameters append to url, optional
         */
        public var URLParameters: [String: String]?
        
        /**
         *  request headers, optional
         */
        public var headers: [String: String]?
        
        /**
         *  request body, optional
         */
        public var body: Body?
        
        /**
         *  timeout interval in secs
         */
        public var timeoutInterval: TimeInterval = 30
        
        /**
         *  cache policy, default is .reloadIgnoringCacheData
         */
        public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringCacheData
        
    }
    
}

extension QXNetwork.Request {
    
    /**
     *  convenice begin the request task
     */
    @discardableResult public func beginTask() -> QXNetwork.Task {
        return QXNetwork.shared.beginTask(with: self)
    }
    
}

extension QXNetwork.Request.Body {
    
    /**
     *  dictionary body extensions Body.raw, utf8/text/json
     */
    static func dictionary(dic: [String: Any]) -> QXNetwork.Request.Body? {
        if let data = try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted) {
            if let str = String(data: data, encoding: .utf8) {
                return QXNetwork.Request.Body.raw(text: str,
                                                  encoding: .utf8,
                                                  contentType: "text/json")
            } else {
                let err = QXNetwork.Error.encoding(isDecoding: true, detail: "QXNetwork.Error: can not decoding body dictionary data to raw text. ctx:\(data)")
                return QXNetwork.Request.Body.error(error: err)
            }
        } else {
            let err = QXNetwork.Error.encoding(isDecoding: true, detail: "QXNetwork.Error: can not json serialize body with dictionary: \(dic)")
            return QXNetwork.Request.Body.error(error: err)
        }
    }
    
    /**
     *  array body extensions Body.raw, utf8/text/json
     */
    static func array(arr: [Any]) -> QXNetwork.Request.Body? {
        if let data = try? JSONSerialization.data(withJSONObject: arr, options: .prettyPrinted) {
            if let str = String(data: data, encoding: .utf8) {
                return QXNetwork.Request.Body.raw(text: str,
                                                  encoding: .utf8,
                                                  contentType: "text/json")
            } else {
                let err = QXNetwork.Error.encoding(isDecoding: true, detail: "QXNetwork.Error: can not decoding body array data to raw text. ctx:\(data)")
                return QXNetwork.Request.Body.error(error: err)
            }
        } else {
            let err = QXNetwork.Error.encoding(isDecoding: true, detail: "QXNetwork.Error: can not json serialize body with array: \(arr)")
            return QXNetwork.Request.Body.error(error: err)
        }
    }
    
}

extension QXNetwork.Request.Method {
    
    /**
     *  makeup method string
     */
    public func makeupString() -> String {
        switch self {
        case .GET:  return "GET"
        case .POST:  return "POST"
        case .PUT: return "PUT"
        case .PATCH: return "PATCH"
        case .DELETE: return "DELETE"
        case .COPY: return "COPY"
        case .HEAD: return "HEAD"
        case .OPTIONS: return "OPTIONS"
        case .LINK: return "LINK"
        case .UNLINK: return "UNLINK"
        case .PURGE: return "PURGE"
        case .LOCK: return "LOCK"
        case .UNLOCK: return "UNLOCK"
        case .PROPFIND: return "PROPFIND"
        case .VIEW: return "VIEW"
        }
    }
    
}

extension QXNetwork.Request.Body {

    /**
     *  makeup contentType and dataBody
     */
    public func makeupContentTypeAndDataBody() -> (contentType: String?, body: Data?, error: QXNetwork.Error?) {
        switch self {
        case .formData(formDatas: let formDatas, boundary: let boundary):
            let boundary = boundary ?? String(format: "QXNetwork.boundary.%08x%08x", arc4random(), arc4random())
            let unitBoundaryData = ("\r\n--" + boundary + "\r\n").data(using: .utf8, allowLossyConversion: false)!
            let endBoundaryData = ("\r\n--" + boundary + "--").data(using: .utf8, allowLossyConversion: false)!
            let contentType = "multipart/form-data; boundary=" + boundary
            let mData = NSMutableData()
            for formData in formDatas {
                mData.append(unitBoundaryData)
                let data = formData.makeupData()
                if let error = data.error {
                    return (nil, nil, error)
                } else {
                    if let data = data.data {
                        mData.append(data)
                    }
                }
            }
            mData.append(endBoundaryData)
            return (contentType, mData as Data, nil)
        case .form(keyValues: let keyValues):
            let contentType = "application/x-www-form-urlencoded"
            var components = [String]()
            for (key, value) in keyValues {
                assert(key.count > 0, "key should not be none")
                let value = "\(value)".replacingOccurrences(of: "&", with: "%26")
                components.append("\(key)=\(value)")
            }
            let text = components.joined(separator: "&")
            let data = text.data(using: .utf8)
            return (contentType, data, nil)
        case .raw(text: let text, encoding: let encoding, contentType: let contentType):
            let contentType = contentType
            let data = text.data(using: encoding)
            return (contentType, data, nil)
        case .binary(data: let data):
            let contentType = "application/octet-stream"
            let data = data
            return (contentType, data, nil)
        case .error(error: let error):
            return (nil, nil, error)
        }
    }
    
}

extension QXNetwork.Request {
    
    /**
     * makeup URL
     */
    public func makeupURL() -> (url: URL?, error: QXNetwork.Error?) {
        if let urlStr = URLString {
            if let params = URLParameters {
                if var components = URLComponents(string: urlStr + "?") {
                    var items: [URLQueryItem] = []
                    for (key, value) in params {
                        let item = URLQueryItem(name: key, value: value)
                        items.append(item)
                    }
                    components.queryItems = items
                    if let _url = components.url {
                        return (_url, nil)
                    } else {
                        return (nil, QXNetwork.Error.request(detail: "QXNetwork.Error: URLComponents cannot makeup URL. ctx:\(components)"))
                    }
                } else {
                    return (nil, QXNetwork.Error.request(detail: "QXNetwork.Error: URLString cannot makeup URLComponents. ctx:\(params)"))
                }
            } else {
                if let _url = URL(string: urlStr) {
                    return (_url, nil)
                } else {
                    return (nil, QXNetwork.Error.request(detail: "QXNetwork.Error: URLString cannot makeup URL. ctx:\(urlStr)"))
                }
            }
        } else {
            return (nil, QXNetwork.Error.request(detail: "QXNetwork.Error: URLString is nil. ctx:\(self)"))
        }
    }
    
    /**
     * makeup URLRequest
     */
    public func makeupRequest() -> (request: URLRequest?, error: QXNetwork.Error?) {
        let url = makeupURL()
        if let error = url.error {
            return (nil, error)
        } else {
            let url = url.url!
            var request = URLRequest(url: url)
            request.httpMethod = method.makeupString()
            let contentTypeAndDataBody = body?.makeupContentTypeAndDataBody()
            var httpHeaders: [String: String] = [:]
            if let headers = headers {
                for (key, value) in headers {
                    httpHeaders.updateValue(value, forKey: key)
                }
            }
            if let contentType = contentTypeAndDataBody?.contentType {
                httpHeaders.updateValue(contentType, forKey: "Content-Type")
            }
            request.allHTTPHeaderFields = httpHeaders
            request.httpBody = contentTypeAndDataBody?.body
            request.cachePolicy = cachePolicy
            request.timeoutInterval = timeoutInterval
            return (request, nil)
        }
    }
    
}

extension QXNetwork.Request.FormData {
    
    /**
     * makeup http body string
     */
    public func makeupData() -> (data: Data?, error: QXNetwork.Error?) {
        var params: String = ""
        var disposition = self.disposition ?? "form-data"
        disposition += "; name=\"\(name)\""
        if let fileName = fileName {
            disposition += "; filename=\"\(fileName)\""
        }
        params += "Content-Disposition: " + disposition + "\r\n"
        
        if let contentTransferEncoding = contentTransferEncoding {
            params += "Content-Transfer-Encoding:" + contentTransferEncoding + "\r\n"
        }
        if let data = data as? Data {
            if let mimeType = mimeType {
                params += "Content-Type:" + mimeType + "\r\n"
            }
            params += "\r\n"
            let mData = NSMutableData()
            if let data = params.data(using: .utf8, allowLossyConversion: false) {
                mData.append(data)
            } else {
                return (nil, QXNetwork.Error.encoding(isDecoding: false, detail: "QXNetwork.Error: can not encoding params in utf8. ctx:\(params)"))
            }
            mData.append(data)
            return (mData as Data, nil)
        } else {
            params += "Content-Type:text/plain\r\n"
            params += "\r\n"
            params += "\(data)"
            if let data = params.data(using: .utf8, allowLossyConversion: false) {
                return (data, nil)
            } else {
                return (nil, QXNetwork.Error.encoding(isDecoding: false, detail: "QXNetwork.Error: can not encoding params in utf8. ctx:\(params)"))
            }
        }
    }
    
}


extension QXNetwork.Request: CustomStringConvertible {
    
    public var description: String {
        var text = "QXNetwork.Request"
        let url = makeupURL()
        if let url = url.url {
            text += ".\(method.makeupString()):\(url)\n"
            let contentTypeAndDataBody = body?.makeupContentTypeAndDataBody()
            var httpHeaders: [String: String] = [:]
            if let headers = headers {
                for (key, value) in headers {
                    httpHeaders.updateValue(value, forKey: key)
                }
            }
            if let contentType = contentTypeAndDataBody?.contentType {
                httpHeaders.updateValue(contentType, forKey: "Content-Type")
            }
            if httpHeaders.count > 0 {
                text += "HEADERS:\(httpHeaders)\n"
            }
            if let data = contentTypeAndDataBody?.body {
                if let str = String(data: data, encoding: .utf8) {
                    text += "BODY:\n\(str)\n"
                } else {
                    text += "BODY:\n\(data)\n"
                }
            }
            switch cachePolicy {
            case .useProtocolCachePolicy:
                text += "CACHEPOLICY:useProtocolCachePolicy\n"
            case .reloadIgnoringLocalCacheData:
                text += "CACHEPOLICY:reloadIgnoringLocalCacheData\n"
            case .reloadIgnoringLocalAndRemoteCacheData:
                text += "CACHEPOLICY:reloadIgnoringLocalCacheData\n"
            case .returnCacheDataElseLoad:
                text += "CACHEPOLICY:returnCacheDataElseLoad\n"
            case .returnCacheDataDontLoad:
                text += "CACHEPOLICY:returnCacheDataElseLoad\n"
            case .reloadRevalidatingCacheData:
                text += "CACHEPOLICY:returnCacheDataDontLoad\n"
            }
            text += "TIMEOUT:\(timeoutInterval)secs"
        } else {
            text += "INVALIDURL:\(URLString ?? "")"
        }
        return text
    }
    
}
