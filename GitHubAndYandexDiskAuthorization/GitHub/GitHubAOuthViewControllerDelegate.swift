

import Foundation
import WebKit

protocol GitHubAOuthViewControllerDelegate : AnyObject{

    func returnAndShow()
    func networkErrorLoginIn()
}


final class GitHubAOuthViewController : UIViewController{
    
    weak var delegate : GitHubAOuthViewControllerDelegate?
    private let webView = WKWebView()
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        setupViews()
        guard let request = ApiManagerForGit().requestForGit(urlString: GitInfo.authorize_url.rawValue) else { return }
        webView.load(request)
        webView.navigationDelegate = self
    }
    
    
    //MARK: Privet
    private func setupViews(){
        view.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 1),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -1),
            webView.topAnchor.constraint(equalTo: view.topAnchor,constant: 1),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -1)
        ])
    }
}


extension GitHubAOuthViewController : WKNavigationDelegate{
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {

        if (navigationAction.navigationType == .linkActivated){
            decisionHandler(.cancel)
        }
        else {
            if let url = navigationAction.request.url{
                
                ApiManagerForGit().takeTokenAndSave(url: url, login: GitInfo.login.rawValue) { param in
                    if param{
                        self.delegate?.returnAndShow()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                    
//                ApiManagerForGit.loadTokenFromUrl(url: url) { param in
//                    if param{
//                        self.delegate?.returnAndShow()
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                }
                    
        }
        decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if(error.localizedDescription == "The Internet connection appears to be offline.") {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.networkErrorLoginIn()
        }
    }
}




