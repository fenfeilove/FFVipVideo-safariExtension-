//
//  FFVipList.swift
//  SafariExtension
//
//  Created by francis zhuo on 2018/7/16.
//  Copyright © 2018 zoom. All rights reserved.
//

import Cocoa

class FFVipModel: NSObject{
    var vipURL:String = ""
    var vipName:String = ""
}


class FFVipList: NSObject {
    
    static let shared = FFVipList()
    
    var platformlist:Array<FFVipModel>?
    var vipURLList:Array<FFVipModel>?
    
    override init() {
        super.init()
        self.fetch()
    }
    
    func fetch() -> Void {
        let url = URL.init(string: "https://iodefog.github.io/text/viplist.json")
        let jsonString = try? String.init(contentsOf: url!)
        guard (jsonString != nil) else {
            return
        }
//        print(jsonString!)
        
        let data = jsonString!.data(using: String.Encoding.utf8)
        guard (data != nil) else {
            return
        }
//        print(data!)
        
        let dict = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Array<Dictionary<String,String>>>
//        print(dict)
        
        self.platformlist = self.transformJsonToModel(array: dict["platformlist"]!)
//        print(self.platformlist)
        
        self.vipURLList = self.transformJsonToModel(array: dict["list"]!)
//        print(self.vipURLList)
    }

    func transformJsonToModel(array:Array<Dictionary<String, String>>)->Array<FFVipModel>{
        var models = Array<FFVipModel>.init()
        for dict in array {
            let model = FFVipModel.init()
            model.vipURL = dict["url"]!
            model.vipName = dict["name"]!
            models.append(model)
        }
        return models
    }
}
