//
//  BaseViewController.swift
//  uguta
//
//  Created by CO7VF2D1G1HW on 4/29/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var waitController: UIAlertController?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background_color"))
        self.view.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1568627451, blue: 0.1803921569, alpha: 1)
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.1568627451, blue: 0.1803921569, alpha: 1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // self.navigationController?.navigationBar.topItem?.title = " "
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.title = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showIndicatorDialog() {
        waitController = nil
        waitController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert)
        let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        waitController?.view.addSubview(spinnerIndicator)
        self.present(waitController!, animated: false, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
            self.dismissIndicatorDialog()
        }
    }
    func dismissIndicatorDialog() {
        waitController?.dismiss(animated: true, completion: nil);
        waitController = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.dismissIndicatorDialog()
        //self.navigationController?.navigationBar.backItem?.title = ""
    }
    func bactToRoot()  {
        self.dismiss(animated: true, completion: {});
        self.navigationController?.popViewController(animated: true);
    }
    func back() {
        self.navigationController?.popViewController(animated: true)
        
    }
}

