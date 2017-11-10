# QXNetwork
## A very easy use, high customizable http request tool based on URLSession. With leveled error handler, various of call back handlers and thread safe features.

### Basic request
```
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
```


### Form-Data
```
let request = QXNetwork.Request()
request.method = .POST
request.URLString = "http://httpbin.org/post"
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
```


### Form
```
let request = QXNetwork.Request()
request.method = .POST
request.URLString = "http://httpbin.org/post"

request.body = QXNetwork.Request.Body.form(keyValues: [
"userForm0": "123&456",
"userForm1": 1,
"userForm2": "中话"
])

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
```

### RAW text
```
let request = QXNetwork.Request()
request.method = .POST
request.URLString = "http://httpbin.org/post"

let data = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
let str = String(data: data, encoding: .utf8)!

request.body = QXNetwork.Request.Body.raw(text: str,
encoding: .utf8,
contentType: "text/json")

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
```

### BIN data
```
let request = QXNetwork.Request()
request.method = .POST
request.URLString = "http://httpbin.org/post"

let imageData0 = UIImageJPEGRepresentation(UIImage(named: "image0")!, 1)!
request.body = QXNetwork.Request.Body.binary(data: imageData0)

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
```


### Dictionary extension
```
let request = QXNetwork.Request()
request.method = .POST
request.URLString = "http://httpbin.org/post"

request.body = QXNetwork.Request.Body.dictionary(dic: [
"user_params2": "2",
"user_params3": 3
])

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
```


### Array extension
```
let request = QXNetwork.Request()
request.method = .POST
request.URLString = "http://httpbin.org/post"

request.body = QXNetwork.Request.Body.array(arr: [
"1", "B", 3.14
]).body

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
```

Other features for discover, Enjoy!

