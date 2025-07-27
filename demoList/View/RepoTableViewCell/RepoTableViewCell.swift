

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var labelRepoName: UILabel!
    @IBOutlet weak var labelDeveLanguage: UILabel!
    @IBOutlet weak var labelStars: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(repositoryDM: RepositoryDM) {
        labelRepoName.text = repositoryDM.name
        labelDeveLanguage.text = repositoryDM.language
    }
    
}
