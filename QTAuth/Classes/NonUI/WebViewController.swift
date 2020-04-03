//
//  WebViewController.swift
//  QTAuth
//
//  Created by sunilreddy on 07/01/20.
//

import UIKit
import WebKit
class WebViewController: AuthBaseViewController {
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    override func loadView() {
        self.view = webView
       }
    var urlString: String?
    let webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityIndicator)
        activityIndicator.fillSuperview()
        if let urlString = urlString {
            webView.load(urlString)
        }
        webView.navigationDelegate = self
        // Do any additional setup after loading the view.
    }
}
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
          print("Strat to load")
      }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
          print("finish to load")
      }
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
              print(error.localizedDescription)
        
    }
}
extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
