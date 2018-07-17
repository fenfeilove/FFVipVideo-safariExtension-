//
//  SafariExtensionHandler.swift
//  SafariExtension
//
//  Created by francis zhuo on 2018/7/3.
//  Copyright © 2018 zoom. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        window.getActiveTab { (safariTab) in
            safariTab?.getActivePage(completionHandler: { (safariPage) in
                safariPage?.getPropertiesWithCompletionHandler({ (properties) in
                    NSLog("(\(String(describing: properties?.url)))")
                    if let url = properties?.url {
                        self.openVipVideo(url: url)
                    }
                })
            })
        }
    }
    
    func openVipVideo(url:URL, defaultSite:String = ""){
        var site:String! = defaultSite
        if site.isEmpty{
            let theSite = SafariExtensionViewController.shared.defalutSite
            if theSite != nil{
                site = theSite!
            }
        }
        let urlStr = site+url.absoluteString
        let theUrl:URL! = URL.init(string: urlStr)
        NSWorkspace.shared.open(theUrl)
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }
    
    override func validateContextMenuItem(withCommand command: String, in page: SFSafariPage, userInfo: [String : Any]? = nil, validationHandler: @escaping (Bool, String?) -> Void) {
        validationHandler(false, nil)
    }
    
    override func contextMenuItemSelected(withCommand command: String, in page: SFSafariPage, userInfo: [String : Any]? = nil) {
        NSLog("\(command)")
        if command.elementsEqual("onOpenVipVideo") {
            page.getPropertiesWithCompletionHandler({ (properties) in
                NSLog("(\(String(describing: properties?.url)))")
                if let url = properties?.url {
                    self.openVipVideo(url: url)
                }
            })
        }
    }
}
