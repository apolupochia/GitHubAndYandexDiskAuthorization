

import UIKit
import WebKit

class YandexViewController: UIViewController {
    
  //  private let fileCellIdentifire = "FileTableViewCell"

    private let tableView = UITableView()
    private var isFirst = true
    
    var filesData : DiskResponse?

    private lazy var backButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        
        button.setTitle("back", for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoutButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        
        button.setTitle("logout", for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(logoutAccount), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginIfNeed : UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        
        button.setTitle("login", for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(loginAccount), for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirst{
            updateData()
        }
        isFirst = false
        
    }

    private func setupViews(){
        
        view.addSubview(backButton)
        backButton.isHidden = false
        
        view.addSubview(logoutButton)
        logoutButton.isHidden = true
        
        view.addSubview(loginIfNeed)
        loginIfNeed.isHidden = false
        
        view.backgroundColor = .white
        
        tableView.register(UINib(nibName: "YandexMainTableViewCell", bundle: nil), forCellReuseIdentifier: YandexInfo.fileCellIdentifireYandexMain.rawValue)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * (9 / 100)),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * (5 / 100) ),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width * (5 / 100)),
            backButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIScreen.main.bounds.width * (73 / 100)),
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height * (92 / 100))
        ])
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * (5 / 100)),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width * (73 / 100) ),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIScreen.main.bounds.width * (5 / 100) ),
            logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height * (92 / 100))
        ])
        
        loginIfNeed.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginIfNeed)
        NSLayoutConstraint.activate([
            loginIfNeed.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * (48 / 100) ),
            loginIfNeed.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIScreen.main.bounds.width * (30 / 100)),
            loginIfNeed.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIScreen.main.bounds.width * (30 / 100)),
            loginIfNeed.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -UIScreen.main.bounds.height * (48 / 100))
        ])
        
    

    }
    
    private func updateData(){
        guard  let token = KeychainManagerForPerson.loadDataFromKeyChain(service: YandexInfo.login.rawValue) else {

            let requestTokenViewController = YandexAOuthViewController()
        //    requestTokenViewController.modalPresentationStyle = .fullScreen
            requestTokenViewController.delegate = self
            self.present(requestTokenViewController, animated: false, completion: nil)
            return
            
        }
       
        ApiManagerForYandex.loadDataAboutYandexDisk(key: token) { (files, networkError) in
            
            guard networkError == false else {
                DispatchQueue.main.async {
                    self.present(AlertsError.alertError(), animated: true, completion: nil)
                }
                return
            }
            guard let files = files else {
                self.updateData()
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                
                self?.loginIfNeed.isHidden = true
                self?.logoutButton.isHidden = false
                self?.backButton.isHidden = false
                
                self?.filesData = files
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func back(){
        dismiss(animated: true)
    }
    
    @objc private func logoutAccount(){
        let requestTokenViewController = YandexLogoutController()
  //      requestTokenViewController.modalPresentationStyle = .fullScreen
        requestTokenViewController.delegate = self
        present(requestTokenViewController, animated: false, completion: nil)
    }
    
    @objc private func loginAccount(){
        updateData()
    }
}






extension YandexViewController : YandexAOuthViewControllerDelegate{
    func returnAndShow(){
        updateData()
    }
    func networkErrorLoginIn(){
        self.present(AlertsError.alertError(), animated: true, completion: nil)
    }
}

extension YandexViewController : YandexLogoutControllerDelegate{
    func logout(){
        KeychainManagerForPerson.delete(service: YandexInfo.login.rawValue)
        loginIfNeed.isHidden = false
        logoutButton.isHidden = true
        
        self.filesData = nil
        self.tableView.reloadData()
    }
    
    func networkErrorLogout(){
        self.present(AlertsError.alertError(), animated: true, completion: nil)
        
    }
}


extension YandexViewController : UITableViewDelegate{
    
}

extension YandexViewController : UITableViewDataSource{

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filesData?.items.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: YandexInfo.fileCellIdentifireYandexMain.rawValue) as! YandexMainTableViewCell
        guard let items = filesData?.items, items.count > indexPath.row else { return cell }
        guard let items = filesData?.items else { return cell }
        let currentFile = items[indexPath.row]
        
        cell.labelCell.text = currentFile?.name
        
        guard let urlString = currentFile?.preview else {
            cell.imageCell.image = UIImage(systemName: "network")
            return cell
        }
        ApiManagerForYandex.downloadingImagesFromUrl(urlString: urlString) { data in
            guard let data = data else {
                cell.imageCell.image = UIImage(systemName: "network")
                return
            }
            DispatchQueue.main.async {
                cell.imageCell.image = UIImage(data: data)
            }
        }

        
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
