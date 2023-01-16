

import UIKit

class StartViewController: UIViewController {

    @IBOutlet var gitLogo: UIImageView!
    @IBOutlet var yandexLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTargetSettings()
    }
    
    func setupViews(){
        gitLogo.image = resizeImage(image: UIImage(named: "GitHubLogo")!)
        yandexLogo.image = resizeImage(image: UIImage(named: "YandexDiskLogo")!)
    }
    
    func setupTargetSettings(){
        let tapGitHub = UITapGestureRecognizer(target: self, action: #selector(StartViewController.tappedMeGitLogo))
        gitLogo.addGestureRecognizer(tapGitHub)
        gitLogo.isUserInteractionEnabled = true
        
        let tapYandexDisk = UITapGestureRecognizer(target: self, action: #selector(StartViewController.tappedMeYandexLogo))
        yandexLogo.addGestureRecognizer(tapYandexDisk)
        yandexLogo.isUserInteractionEnabled = true
    }
    
    @objc func tappedMeGitLogo(){
        let yandexViewController = GitHubViewController()
        yandexViewController.modalPresentationStyle = .overFullScreen
        present(yandexViewController, animated: false, completion: nil)
    }
    
    @objc func tappedMeYandexLogo(){
        let yandexViewController = YandexViewController()
        yandexViewController.modalPresentationStyle = .overFullScreen
        self.present(yandexViewController, animated: false, completion: nil)
    }
    

    
    func resizeImage(image: UIImage) -> UIImage? {

        var newSize: CGSize
        newSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        let rect = CGRect(origin: .zero, size: newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }   
}

