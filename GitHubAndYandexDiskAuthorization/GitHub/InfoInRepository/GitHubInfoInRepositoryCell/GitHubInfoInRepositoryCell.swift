

import UIKit

class GitHubInfoInRepositoryCell: UITableViewCell {
    @IBOutlet var hashRepository: UILabel!
    @IBOutlet var smallCommitMassage: UILabel!
    @IBOutlet var commitAutor: UILabel!
    @IBOutlet var commitDate: UILabel!
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
