

import Foundation
import WebKit


protocol YandexLogoutControllerDelegate : AnyObject{
    func logout()
    func networkErrorLogout()
}


final class YandexLogoutController : UIViewController{
    
    weak var delegate : YandexLogoutControllerDelegate?
    private let webView = WKWebView()
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        setupViews()
        guard let request = ApiManagerForYandex().logOut(urlString: YandexInfo.logoutUrl.rawValue) else { return }
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

extension YandexLogoutController : WKNavigationDelegate{
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        if (navigationAction.navigationType == .linkActivated){
              decisionHandler(.cancel)
        }
        else {
            if let ur = navigationAction.request.url?.absoluteString{
                if ur == "https://ya.ru/"{
                    dismiss(animated: true, completion: nil)
                    delegate?.logout()
                }
            }
                decisionHandler(.allow)
        }
    }
    
    // error networking
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if(error.localizedDescription == "The Internet connection appears to be offline.") {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.networkErrorLogout()
        }
    }
}





