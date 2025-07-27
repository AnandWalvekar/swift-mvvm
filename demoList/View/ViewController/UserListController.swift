

import UIKit

class UserListController: UIViewController {
    private(set) var viewModel: UserListVM!
    @IBOutlet weak var searchbarCountry: UISearchBar!
    @IBOutlet weak var tableViewCountryList: UITableView!
    let cellNib = String(describing: UserTableViewCell.self)
    private(set) var searchText: String = ""
    private(set) var filteredCountryList : [UserDM] = []
    var onSelectUser: ((UserDM) -> UIViewController)?
    
    
    init(_ viewModel: UserListVM) {
        self.viewModel = viewModel
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
    }
        

    
    // MARK: - View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewCountryList.register(UINib(nibName: cellNib, bundle: nil), forCellReuseIdentifier: cellNib)
        tableViewCountryList.delegate = self
        tableViewCountryList.dataSource = self
        searchbarCountry.delegate = self
        searchbarCountry.placeholder = "Search by Country or Capital"
        searchbarCountry.setNeedsDisplay()
        fetchUserList()
    }

        
    func fetchUserList() {
        Task {
            await viewModel.fetchUsers()
            self.filteredCountryList = viewModel.filteredCounties(searchText: nil)
            DispatchQueue.main.async {
                self.tableViewCountryList.reloadData()
            }
        }        
    }
}

extension UserListController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellNib, for: indexPath) as! UserTableViewCell
        let country = filteredCountryList[indexPath.row]
//        cell.labelCountryCode.text = country.code
        cell.labelCountryName.text = country.name
//        cell.labelCountryCapital.text = country.capital
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let destinationViewController = onSelectUser?(filteredCountryList[indexPath.row]) else { return }
        
        //Kind of navigation decided by viewController. Destination viewController is desided by router
        self.navigationController?.pushViewController(destinationViewController, animated: true)
//        self.present(destinationViewController, animated: true)
    }
}

extension UserListController: UISearchBarDelegate {
    // MARK: - Searchbar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            print("its empty")
            filteredCountryList = viewModel.filteredCounties(searchText: "")
        } else {
            filteredCountryList = viewModel.filteredCounties(searchText: searchText)
        }
        tableViewCountryList.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredCountryList = viewModel.users
        tableViewCountryList.reloadData()
        searchBar.resignFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
