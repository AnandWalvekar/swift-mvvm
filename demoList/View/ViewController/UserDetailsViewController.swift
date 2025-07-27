
import UIKit
import AVKit

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var repositoryTableView: UITableView!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var avatarImage: UIImageView!
    let cellNib = String(describing: RepoTableViewCell.self)
    private(set) var viewModel: UserDetailsVM!
    private(set) var userDM: UserDM!
    
    init(_ viewModel: UserDetailsVM, userDM: UserDM) {
        self.viewModel = viewModel
        self.userDM = userDM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    override func loadView() {
        super.loadView()
        
        let nibName = String(describing: Self.self)
        let bundle = Bundle(for: Self.self)

        if let nibView = bundle.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView {
            self.view = nibView // ✅ Assign the view without duplication
        } else {
            fatalError("Failed to load \(nibName).xib")
        }

        repositoryTableView.delegate = self
        repositoryTableView.dataSource = self
        repositoryTableView.register(UINib(nibName: cellNib, bundle: nil), forCellReuseIdentifier: cellNib)
    }
    
    // Setup observation to reload UI when data is available
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func updateUI() {
            withObservationTracking {
                _ = self.viewModel.repositories
                _ = self.viewModel.userDetailsDM
                _ = self.viewModel.avatarImage
            } onChange: { [weak self] in
                DispatchQueue.main.async {
                    // Re register for chanegs again
                    updateUI()
                }
                
                DispatchQueue.main.async {
                    self?.avatarImage.image = self?.viewModel.avatarImage
                    self?.repositoryTableView.reloadData()
                    self?.followers.text = "\(self?.viewModel.userDetailsDM?.followersCount ?? 0)"
                    self?.following.text = "\(self?.viewModel.userDetailsDM?.followingCount ?? 0)"
                }
            }
        }
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // populate data in hand
        self.userNameLabel.text = self.userDM.name
        
        //customise the look
        let parentView = self.userNameLabel.superview
        parentView?.layer.cornerRadius = 8
        parentView?.layer.shadowColor = UIColor.lightGray.cgColor
        parentView?.layer.shadowOpacity = 1
        parentView?.layer.shadowOffset = CGSize.zero
        parentView?.layer.shadowRadius = 5
        
        // fire request for more data
        viewModel.fetchUserDetails()
    }
}

extension UserDetailsViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellNib, for: indexPath) as! RepoTableViewCell
        cell.update(repositoryDM: self.viewModel.repositories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = self.viewModel.repositories[indexPath.row]
        guard let url = URL(string: repo.cloneUrl) else {
          return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
