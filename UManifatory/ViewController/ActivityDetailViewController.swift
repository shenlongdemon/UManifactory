//
//  ActivityDetailViewController.swift
//  UManifatory
//
//  Created by CO7VF2D1G1HW on 8/28/18.
//  Copyright © 2018 CO7VF2D1G1HW. All rights reserved.
//

import UIKit
import ImageSlideshow
import SafariServices
class ActivityDetailViewController: BaseViewController {
    var activity: Activity!
    
    @IBOutlet weak var imgPDF: UIImageView!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbWorkerName: UILabel!
    @IBOutlet weak var imageSlide: ImageSlideshow!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = self.activity.title
        if let files = self.activity.files{
            if files.count > 0 {
                self.imgPDF.image = #imageLiteral(resourceName: "downlaod_pdf")
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage(tapGestureRecognizer:)))
                self.imgPDF.isUserInteractionEnabled = true
                self.imgPDF.addGestureRecognizer(tapGestureRecognizer)
            }
        }
        self.lbWorkerName.text = "\(self.activity.worker.firstName) \(self.activity.worker.lastName)"
        
        self.lbDate.text = Util.getDate(milisecond: self.activity.time, format: "yyyy-MM-dd")
        self.lbTime.text = Util.getDate(milisecond: self.activity.time, format: "HH:mm a")
        self.tvDescription.text = self.activity.description
        // Do any additional setup after loading the view.
        var images : [InputSource] = []
        for (_, imageName) in activity.images.enumerated() {
            let urlString = "\(WebApi.HOST)/uploads/\(imageName)"
            let a = AlamofireSource(urlString: urlString)
            images.append(a!)
        }
         imageSlide.setImageInputs(images)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func pickImage(tapGestureRecognizer: UITapGestureRecognizer){
        if self.activity.files?.count == 1 {
            let link = "\(WebApi.HOST)/uploads/\(self.activity.files![0])"
            let svc = SFSafariViewController(url: URL(string: link)!)
            self.present(svc, animated: true, completion: nil)
        }
        else {
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func initItem(item: Activity){
        self.activity = item
    }

}
