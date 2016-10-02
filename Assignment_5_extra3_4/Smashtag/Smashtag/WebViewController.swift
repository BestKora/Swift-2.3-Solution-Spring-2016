//
//  WebViewController.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/6/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    private struct Constants {
        static let BackButtonImage = UIImage(named: "back")
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var webView: UIWebView! {
        didSet {
            if URL != nil {
                webView.delegate = self
                self.title = URL!.host
                webView.scalesPageToFit = true
                webView.loadRequest(NSURLRequest(URL: URL!))
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Public API
    var URL: NSURL?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: Constants.BackButtonImage,
                            style: UIBarButtonItemStyle.Plain,
                           target: self,
                    action: #selector(WebViewController.navigateToPreviousWebPageOrVC(_:)))
    }
    
    // MARK: - Users interaction
    @objc private func navigateToPreviousWebPageOrVC(sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func toRootViewController(sender: UIBarButtonItem) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - UIWebViewDelegate
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        spinner.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        spinner.stopAnimating()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        spinner.stopAnimating()
        print("проблемы с загрузкой web страницы!")
    }
}
