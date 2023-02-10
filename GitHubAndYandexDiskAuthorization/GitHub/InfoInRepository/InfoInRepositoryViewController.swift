

import Foundation
import UIKit

class InfoInRepositoryViewController: UIViewController {

    private let tableView = UITableView()
    
    var ulrString = ""
    var repoName = ""
    var commitsData : [CommitsModel]?
    
    private lazy var backButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("back", for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
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
        
        updateData()
    }

  

    private func setupViews(){
        
        view.addSubview(backButton)
        
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: "GitHubInfoInRepositoryCell", bundle: nil),
            forCellReuseIdentifier: GitInfo.fileCellIdentifireGitInfInRepo.rawValue
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
    }
    
    func updateData(){
        
        ApiManagerForGit().takeCommitsFromAri(urlString: ulrString) { informationAboutDownload  in
            
            guard informationAboutDownload.dataError == false else {
                DispatchQueue.main.async {
                    self.present(AlertsError.alertError(title: "Error", message: "Connect to the network or update your app"), animated: true, completion: nil)
                }
                return
            }
            
            
            guard informationAboutDownload.networkError == false else {
                DispatchQueue.main.async {
                    self.present(AlertsError.alertError(title: "Network Error", message: "Connect to the network"), animated: true, completion: nil)
                }
                return
            }
            
            guard informationAboutDownload.decodeError == false else {
                self.present(AlertsError.alertError(title: "Decode Error", message: "Restart the App"), animated: true, completion: nil)
                return()
            }
            
            
            
            
            DispatchQueue.main.async {
                self.commitsData = informationAboutDownload.commitsModel
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

    @objc private func back(){
        dismiss(animated: true)
    }
}



extension InfoInRepositoryViewController : UITableViewDataSource, UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         commitsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: GitInfo.fileCellIdentifireGitInfInRepo.rawValue) as! GitHubInfoInRepositoryCell
        guard let items = commitsData else { return cell }
        let currentFile = items[indexPath.row]
        
        cell.hashRepository.text = "hash(first 4 symbols) : \(String(currentFile.sha.prefix(4)))"
        cell.smallCommitMassage.text = "small commit massage : \(currentFile.commit.message)"
        cell.commitAutor.text = currentFile.commit.author.name
        cell.commitDate.text = currentFile.commit.author.date

        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
}
