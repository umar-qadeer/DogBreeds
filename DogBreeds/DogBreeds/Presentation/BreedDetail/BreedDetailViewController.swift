
import UIKit

protocol BreedDetailViewControllerCoordinationDelegate: AnyObject {
}

final class BreedDetailViewController: UIViewController, BreedDetailViewModelToViewDelegate, UITableViewDataSource, UITableViewDelegate, BreedDetailTableViewCellDelegate {
    
    // MARK: - Properties
    
    private weak var coordinator: BreedDetailViewControllerCoordinationDelegate?
    private var viewModel: BreedDetailViewModel
    
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
        tableView.registerCell(class: BreedDetailTableViewCell.self)
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
    
    init(_ coordinator: BreedDetailViewControllerCoordinationDelegate, viewModel: BreedDetailViewModel) {
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
        
        viewModel.fetchBreedImages()
    }
    
    // MARK: - Private Functions
    
    private func setupUI() {
        view.backgroundColor = .white
        view.isOpaque = true
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        self.title = viewModel.breed.name
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
        viewModel.fetchBreedImages()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.breedDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let breedDetail = viewModel.breedDetails?[indexPath.row] else {
            return UITableViewCell()
        }
        
        let cell: BreedDetailTableViewCell = tableView.dequeReusableCell(for: indexPath)
        cell.configure(breedDetail: breedDetail, indexPath: indexPath, delegate: self)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    // MARK: - BreedDetailViewModelToViewDelegate
    
    func updateUI() {
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
    func showError(error: Error) {
        self.refreshControl.endRefreshing()
        AlertBuilder.failureAlertWithMessage(message: error.localizedDescription)
    }
    
    func showLoading(_ loading: Bool) {
        loading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    // MARK: - BreedDetailTableViewCellDelegate
    
    func didTapFavouriteButton(at indexPath: IndexPath) {
        viewModel.handleFavouriteButtonTap(at: indexPath.row)
    }
}

