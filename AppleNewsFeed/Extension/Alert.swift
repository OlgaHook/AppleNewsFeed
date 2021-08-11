//
//  alert.swift
//  AppleNewsFeed
//
//  Created by olga.krjuckova on 11/08/2021.
//

import UIKit

extension UIViewController{
    func basicAlert(title: String?, message: String?){
      //it should run in new thread, reload and present a popUp so we need ->
        DispatchQueue.main.async {
            //title and message are reusable->
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            //alert action -> just to dismiss.To present it we need to call it->self.present...
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
