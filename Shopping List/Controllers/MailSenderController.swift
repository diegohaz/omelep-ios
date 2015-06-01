//
//  MailSenderController.swift
//  Shopping List
//
//  Created by Bruno Baring on 5/30/15.
//  Copyright (c) 2015 Matheus Falcão. All rights reserved.
//

import MessageUI

class MailSender: NSObject, MFMailComposeViewControllerDelegate {
    
    override init() {
        super.init()
    }
    
    var productNames: [Product] = []
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["\(DAOLocal.sharedInstance.readUser().email)"])
        mailComposerVC.setSubject("Spesa")
        
        var productNameDisplay = ""
        for var i = 0 ; i < productNames.count ; i++ {
            productNameDisplay += "\n\(i+1) - \(productNames[i].name) \(productNames[i].cubage), \(productNames[i].brand)"
        }
        
        mailComposerVC.setMessageBody("Spesa Products\n\n \(productNameDisplay)", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Tem q cadastrar o email com o Mail.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
}