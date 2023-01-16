

import UIKit

class YandexMainTableViewCell: UITableViewCell {

    @IBOutlet var labelCell: UILabel!
    @IBOutlet var imageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setInCell(text : String , image : UIImage?){
        labelCell.text = ""
        imageCell.image = image ?? UIImage(systemName: "pencil")
    }
}
