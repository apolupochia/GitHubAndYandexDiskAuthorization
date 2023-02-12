

import UIKit
import WebKit

class GitHubViewController: UIViewController {

    private let tableView = UITableView()
    private var isFirst = true
    
 //   private let fileCellIdentifire = "FileTableViewCell"
    
    var repoDate : [RepoModel]?
    let webView = WKWebView()
    
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



    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Updating")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupViews()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        updateData()
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
        
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "GitHubMainTableViewCell", bundle: nil),
            forCellReuseIdentifier: GitInfo.fileCellIdentifireGitMain.rawValue
        )
        
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
        
        guard  let token = KeychainManagerForPerson().loadDataFromKeyChain(login: GitInfo.login.rawValue) else {
            DispatchQueue.main.async {
                let requestTokenViewController = GitHubAOuthViewController()
                //     requestTokenViewController.modalPresentationStyle = .fullScreen
                requestTokenViewController.delegate = self
                self.present(requestTokenViewController, animated: false, completion: nil)
            }
                return
            }
        
        ApiManagerForGit().loadDataAboutAllRepositories(urlString: GitInfo.reposUrl.rawValue, key: token) { informationAboutDownload in
            
            guard informationAboutDownload.dataError == false else {
                DispatchQueue.main.async {
                    self.present(AlertsError.alertError(title: "Error", message: "Connect to the network or update your app"), animated: true, completion: nil)
                }
                return
            }
            
            guard informationAboutDownload.error == false else {
                DispatchQueue.main.async {
                    self.present(AlertsError.alertError(title: "Error", message: "Update your app"), animated: true, completion: nil)
                }
                return
            }
            
            guard informationAboutDownload.networkError == false else {
                DispatchQueue.main.async {
                    self.present(AlertsError.alertError(title: "Network Error", message: "Connect to the network"), animated: true, completion: nil)
                }
                return
            }
            
            guard informationAboutDownload.keyError == false else {
                KeychainManagerForPerson().delete(login: GitInfo.login.rawValue)
                DispatchQueue.main.async {
                    self.updateData()
                }
                return()
            }
            
            guard let repoDate = informationAboutDownload.repoModel else {return}
            self.repoDate = repoDate
            
            
            
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                
                self.loginIfNeed.isHidden = true
                self.logoutButton.isHidden = false
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    @objc private func back(){
        dismiss(animated: true)
    }
    
    @objc private func logoutAccount(){
        let requestTokenViewController = GitHubLogoutViewController()
  //      requestTokenViewController.modalPresentationStyle = .fullScreen
        requestTokenViewController.delegate = self
        present(requestTokenViewController, animated: false, completion: nil)
    }
    
    @objc private func loginAccount(){
        updateData()
    }
    
   

}

extension GitHubViewController : GitHubAOuthViewControllerDelegate{
    func returnAndShow(){
        updateData()
    }
    func  networkErrorLoginIn(){
        self.present(AlertsError.alertError(title: "Network Error", message: "Connect to the network"), animated: true, completion: nil)
    }
}

extension GitHubViewController : GitHubAOuthLogoutControllerDelegate{
    func logout(){
        KeychainManager.delete(login: GitInfo.login.rawValue)
        loginIfNeed.isHidden = false
        logoutButton.isHidden = true
        
        
        self.repoDate = []
        self.tableView.reloadData()
    }
    
    func networkErrorLogout(){
        self.present(AlertsError.alertError(title: "Network Error", message: "Connect to the network"), animated: true, completion: nil)
    }
    

}


extension GitHubViewController : UITableViewDelegate{
    
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
            let login = repoDate?[indexPath.row].owner.login ?? ""
            let nameOfRepo = repoDate?[indexPath.row].name ?? ""
            
            let infoInRepositoryViewController = InfoInRepositoryViewController()
            infoInRepositoryViewController.ulrString = "https://api.github.com/repos/\(login)/\(nameOfRepo)/commits"
            infoInRepositoryViewController.repoName = repoDate?[indexPath.row].name ?? ""
            infoInRepositoryViewController.modalPresentationStyle = .overFullScreen
            present(infoInRepositoryViewController, animated: false, completion: nil)
    
        }
}

extension GitHubViewController : UITableViewDataSource{

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return repoDate?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GitInfo.fileCellIdentifireGitMain.rawValue) as! GitHubMainTableViewCell
        
        guard let items = repoDate else { return cell }
        
        let currentFile = items[indexPath.row]
        if   let url = URL(string: (currentFile.owner.avatar_url)){
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
                DispatchQueue.main.async {
                    cell.imageViewCell.image = UIImage(data: data)
                }
            }
            task.resume()
        }
        cell.nameRepo.text =  currentFile.name
        cell.authorRepository.text = currentFile.owner.login
        cell.countForksRepository.text =   "forks : \(currentFile.forks_count)"
        cell.countWatchesRepository.text = "watchers : \(currentFile.watchers)"
    
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    
    
    
}

