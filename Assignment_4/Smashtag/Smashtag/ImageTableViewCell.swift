//
//  imageTableViewCell.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/6/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Public API    
    var imageUrl: NSURL? {
        didSet {updateUI()}
    }
    
    private func updateUI() {
        if let url = imageUrl {
            spinner?.startAnimating()
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                
                let contentsOfURL = NSData(contentsOfURL: url)
                
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageUrl {
                        if let imageData = contentsOfURL {
                            
                            self.tweetImage?.image = UIImage(data: imageData)
                        }
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }

}
