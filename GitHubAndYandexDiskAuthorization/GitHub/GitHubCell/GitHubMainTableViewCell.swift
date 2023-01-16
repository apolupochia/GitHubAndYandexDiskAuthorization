

import UIKit

class GitHubMainTableViewCell: UITableViewCell {

    @IBOutlet var nameRepo: UILabel!
    @IBOutlet var authorRepository: UILabel!
    @IBOutlet var descriptionRepository: UILabel!
    @IBOutlet var countForksRepository: UILabel!
    @IBOutlet var countWatchesRepository: UILabel!
    
    @IBOutlet var imageViewCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
