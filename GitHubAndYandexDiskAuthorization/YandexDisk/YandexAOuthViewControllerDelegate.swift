

import Foundation
import WebKit

protocol YandexAOuthViewControllerDelegate : AnyObject{
    func returnAndShow()
    func networkErrorLoginIn()
    
}


final class YandexAOuthViewController : UIViewController{
    
    weak var delegate : YandexAOuthViewControllerDelegate?
    private let webView = WKWebView()
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
      //  WKWebView.clean()  // clean cash and cooki
        setupViews()
        guard let request = ApiManagerForYandex().requestForYandex(urlString: YandexInfo.authorize_url.rawValue) else { return }
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

extension YandexAOuthViewController : WKNavigationDelegate{
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        if (navigationAction.navigationType == .linkActivated){
            decisionHandler(.cancel)
        }
        else {
            if let url = navigationAction.request.url{
                let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
                guard let components = URLComponents(string: targetString) else { return }
                let token = components.queryItems?.first(where: {$0.name == "access_token"})?.value

                if let token = token {
                    KeychainManagerForPerson.saveDataToKeyChain(service: YandexInfo.login.rawValue, password: token)
                    delegate?.returnAndShow()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            decisionHandler(.allow)
        }
    }
    
    // error networking
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if(error.localizedDescription == "The Internet connection appears to be offline.") {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.networkErrorLoginIn()
        }
    }
}




