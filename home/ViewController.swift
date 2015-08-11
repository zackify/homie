//
//  ViewController.swift
//  home
//
//  Created by Zach Silveira on 8/1/15.
//  Copyright © 2015 Zach Silveira. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bridge: UITextField!
    
    @IBAction func bridge(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject(bridge.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), forKey: "bridgeIP")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bridge.text = NSUserDefaults.standardUserDefaults().objectForKey("bridgeIP") as? String

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

