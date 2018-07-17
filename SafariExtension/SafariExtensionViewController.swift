//
//  SafariExtensionViewController.swift
//  SafariExtension
//
//  Created by francis zhuo on 2018/7/3.
//  Copyright © 2018 zoom. All rights reserved.
//

import SafariServices

let kDefaultSite = "default size"

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared = SafariExtensionViewController()
    
    var platformList:NSArray?
    let vipListMgr:FFVipList = FFVipList()
    @IBOutlet weak var defaultSiteButton: NSPopUpButton!
    var defalutSite:String!{
        get{
            let value = UserDefaults.standard.object(forKey: kDefaultSite) as? String
            if value != nil{
                return value!
            }
            else{
                return ""
            }
            
        }
        set{
            UserDefaults.standard.set(newValue, forKey: kDefaultSite)
        }
    }
    
    override func viewDidAppear(){
        self.updateDefaultSite()
    }
    
    override func viewDidLoad() {
        self.updateDefaultSite()
    }
    
    func  updateDefaultSite() -> Void {
        let menu = self.getVipListMenu()
        self.defaultSiteButton.menu = menu
        for menuItem in menu.items{
            let model = menuItem.representedObject as? FFVipModel
            let urlStr = model?.vipURL
            if urlStr != nil{
                if urlStr!.elementsEqual(self.defalutSite){
                    self.defaultSiteButton.select(menuItem)
                    break;
                }
            }
        }
    }
    
    @IBAction func onDefaultSiteButtonClick(_ sender: NSPopUpButton) {
        let model = sender.selectedItem?.representedObject as? FFVipModel
        if model != nil{
            self.defalutSite = model!.vipURL
        }
    }
    func getVipListMenu() -> NSMenu {
        let menu = NSMenu()
        let urlList = vipListMgr.vipURLList
        if let list = urlList{
            for model in list{
                let menuItem = NSMenuItem()
                menuItem.title = model.vipName
                menuItem.representedObject = model
                menu.addItem(menuItem)
            }
        }
        return menu
    }
    
    @IBAction func onIQYclick(_ sender: Any) {
        let url = URL.init(string: "https://www.iqiyi.com");
        if let theURL = url {
            NSWorkspace.shared.open(theURL)
        }
    }
    @IBAction func onTXClick(_ sender: Any) {
        let url = URL.init(string: "https://v.qq.com");
        if let theURL = url {
            NSWorkspace.shared.open(theURL)
        }
    }
    @IBAction func onYKclick(_ sender: Any) {
        let url = URL.init(string: "https://www.youku.com");
        if let theURL = url {
            NSWorkspace.shared.open(theURL)
        }
    }
    
    @IBAction func onMoreClick(_ sender: NSButton) {
        let menu = NSMenu()
        let platforms = vipListMgr.platformlist
        if platforms != nil{
            for model in platforms!{
                let menuItem = NSMenuItem()
                menuItem.title = model.vipName
                menuItem.representedObject = model
                menuItem.target = self
                menuItem.action = #selector(onMenuAction(_:))
                menu.addItem(menuItem)
            }
        }
        menu.popUp(positioning: nil, at: NSMakePoint(0, 0), in: sender)
    }
    
    @objc func onMenuAction(_ sender: NSMenuItem){
        let model = sender.representedObject as? FFVipModel
        let urlStr = model?.vipURL
        if urlStr != nil{
            let url = URL.init(string: urlStr!);
            if url != nil {
                NSWorkspace.shared.open(url!)
            }
        }
    }
    @IBAction func onSwitchInterfaceClick(_ sender: NSButton) {
        let menu = NSMenu()
        let urlList = vipListMgr.vipURLList
        if let list = urlList{
            for model in list{
                let menuItem = NSMenuItem()
                menuItem.title = model.vipName
                menuItem.representedObject = model
                menuItem.target = self
                menuItem.action = #selector(onSwitchInterfaceAction(_:))
                menu.addItem(menuItem)
            }
        }
        menu.popUp(positioning: nil, at: NSMakePoint(0, 0), in: sender)
    }
    
    @objc func onSwitchInterfaceAction(_ sender: NSMenuItem){
        let model = sender.representedObject as? FFVipModel
        if let urlStr = model?.vipURL{
            SFSafariApplication.getActiveWindow(completionHandler: { (window) in
                window?.getActiveTab(completionHandler: { (safariTab) in
                    safariTab?.getActivePage(completionHandler: { (page) in
                        page?.getPropertiesWithCompletionHandler({ (properties) in
                            if let oldURL = properties?.url?.absoluteString{
                                self.onSwitchInterface(oldURL: oldURL, interface: urlStr)
                            }
                        })
                    })
                })
            })
        }
    }
    
    func onSwitchInterface(oldURL:String, interface:String){
        let tmpArray = oldURL.components(separatedBy: "url=")
        var tmpUrlStr:String! = oldURL
        if(tmpArray.count>1){
            tmpUrlStr = tmpUrlStr.replacingOccurrences(of: tmpArray[0]+"url=", with: interface)
        }
        else{
            tmpUrlStr = interface + oldURL
        }
        if let url = URL.init(string: tmpUrlStr){
            NSWorkspace.shared.open(url)
        }
    }
}

