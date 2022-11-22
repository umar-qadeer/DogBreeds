
import UIKit

protocol BreedDetailTableViewCellDelegate: AnyObject {
    func didTapFavouriteButton(at indexPath: IndexPath)
}

final class BreedDetailTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: BreedDetailTableViewCellDelegate?
    private var indexPath: IndexPath?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.5
        return view
    }()

    private lazy var breedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "unfavourite"), for: .normal)
        button.setImage(UIImage(named: "favourite"), for: .selected)
        button.accessibilityIdentifier = AccessibilityIdentifier.favouriteButtonIdentifier
        return button
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func didTapFavouriteButton() {
        if let indexPath = self.indexPath {
            delegate?.didTapFavouriteButton(at: indexPath)
        }
    }
    
    // MARK: - Private Functions
    
    private func setupViews() {
        self.accessibilityIdentifier = AccessibilityIdentifier.breedDetailCellIdentifier
        
        backgroundColor = .clear
        selectionStyle = .none
        
        favouriteButton.addTarget(self, action: #selector(didTapFavouriteButton), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        contentView.addSubview(containerView)
        containerView.addSubview(breedImageView)
        containerView.addSubview(favouriteButton)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])

        NSLayoutConstraint.activate([
            breedImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            breedImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            breedImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            breedImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            favouriteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            favouriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            favouriteButton.widthAnchor.constraint(equalToConstant: 50),
            favouriteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Configure
    
    func configure(breedDetail: BreedDetail, indexPath: IndexPath, delegate: BreedDetailTableViewCellDelegate) {
        self.delegate = delegate
        self.indexPath = indexPath
        favouriteButton.isSelected = breedDetail.isFavourite
        
        self.breedImageView.image = UIImage(named: "placeholder")
        ImageDownloadService.getImage(urlString: breedDetail.imageUrl) { [weak self] image, url in
            self?.breedImageView.image = image ?? UIImage(named: "placeholder")
        }
    }
}
