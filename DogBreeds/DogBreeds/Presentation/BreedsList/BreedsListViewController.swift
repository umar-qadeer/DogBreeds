
import UIKit

protocol BreedsListViewControllerCoordinationDelegate: AnyObject {
    func showBreedDetail(breed: Breed)
    func showFavourites()
}

final class BreedsListViewController: UIViewController, BreedsListViewModelToViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    private weak var coordinator: BreedsListViewControllerCoordinationDelegate?
    private var viewModel: BreedsListViewModel
    
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
        tableView.registerCell(class: BreedTableViewCell.self)
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
    
    init(_ coordinator: BreedsListViewControllerCoordinationDelegate, viewModel: BreedsListViewModel) {
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
        
        viewModel.fetchBreeds()
    }
    
    // MARK: - Private Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        view.isOpaque = true
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        self.title = Strings.Titles.breeds
        
        let favoriteBarButtonItem = UIBarButtonItem(image: UIImage(named: "heart"), style: .plain, target: self, action: #selector(didTapFavoriteButton))
        navigationItem.rightBarButtonItem = favoriteBarButtonItem
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        let layoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
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
        viewModel.fetchBreeds()
    }
    
    @objc private func didTapFavoriteButton() {
        coordinator?.showFavourites()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.breeds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let breed = viewModel.breeds?[indexPath.row] else {
            return UITableViewCell()
        }
        
        let cell: BreedTableViewCell = tableView.dequeReusableCell(for: indexPath)
        cell.configure(breed: breed)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let breed = viewModel.breeds?[indexPath.row] else {
            return
        }
        
        coordinator?.showBreedDetail(breed: breed)
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
}

