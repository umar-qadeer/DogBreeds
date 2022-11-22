
import UIKit

protocol FavouritesListViewControllerCoordinationDelegate: AnyObject {
}

final class FavouritesListViewController: UIViewController, FavouritesListViewModelToViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - Properties
    
    private weak var coordinator: FavouritesListViewControllerCoordinationDelegate?
    private var viewModel: FavouritesListViewModel
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = Strings.Placeholder.searchBreedName
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isOpaque = true
        tableView.clipsToBounds = true
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.registerCell(class: FavouriteTableViewCell.self)
        return tableView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .lightGray
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Strings.List.pullToRefresh)
        return refreshControl
    }()
    
    // MARK: - Initializers
    
    init(_ coordinator: FavouritesListViewControllerCoordinationDelegate, viewModel: FavouritesListViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        setupConstraints()
        
        viewModel.fetchFavouriteBreedImages()
    }
    
    // MARK: - Private Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        view.isOpaque = true
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        self.title = Strings.Titles.favourites
    }
    
    private func setupConstraints() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        let layoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor)
        ])
    }
    
    // MARK: - Selectors
    
    @objc private func didPullToRefresh() {
        viewModel.fetchFavouriteBreedImages()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredFavouriteBreedImages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let favouriteBreedImage = viewModel.filteredFavouriteBreedImages?[indexPath.row] else {
            return UITableViewCell()
        }
        
        let cell: FavouriteTableViewCell = tableView.dequeReusableCell(for: indexPath)
        cell.configure(favouriteBreedImage: favouriteBreedImage)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    // MARK: - BreedsListViewModelToViewDelegate
    
    func updateUI() {
        self.refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func showError(error: Error) {
        self.refreshControl.endRefreshing()
        AlertBuilder.failureAlertWithMessage(message: error.localizedDescription)
    }
    
    func showLoading(_ loading: Bool) {
        loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchFavouriteBreedImages(searchQuery: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
