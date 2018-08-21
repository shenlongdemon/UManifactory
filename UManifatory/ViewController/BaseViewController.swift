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
        self.view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = waitController{
            self.dismissIndicatorDialog()
            self.showIndicatorDialog()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showIndicatorDialog() {
        
        waitController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert)
        let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        waitController?.view.addSubview(spinnerIndicator)
        self.present(waitController!, animated: false, completion: nil)
    }
    func dismissIndicatorDialog() {
        waitController?.dismiss(animated: true, completion: nil);
        waitController = nil
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.dismissIndicatorDialog()
    }
    func bactToRoot()  {
        self.dismiss(animated: true, completion: {});
        self.navigationController?.popViewController(animated: true);
    }
    func back() {
        self.navigationController?.popViewController(animated: true)
        
    }
}

