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
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["brunobaring@gmail.com"])
        mailComposerVC.setSubject("Happy lookn User")
        mailComposerVC.setMessageBody("Hi!\n\n I like this ideia. I would like more information about lookns, please. :)", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
}