
import UIKit

final class FavouriteTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
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
    
    private lazy var breedNameLabelContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private lazy var breedNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1
        return label
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
    
    // MARK: - Private Functions
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setupConstraints() {
        contentView.addSubview(containerView)
        containerView.addSubview(breedImageView)
        containerView.addSubview(breedNameLabelContainerView)
        breedNameLabelContainerView.addSubview(breedNameLabel)
        
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
            breedNameLabelContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            breedNameLabelContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            breedNameLabelContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            breedNameLabelContainerView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            breedNameLabel.leadingAnchor.constraint(equalTo: breedNameLabelContainerView.leadingAnchor, constant: 16),
            breedNameLabel.trailingAnchor.constraint(equalTo: breedNameLabelContainerView.trailingAnchor, constant: -16),
            breedNameLabel.centerYAnchor.constraint(equalTo: breedNameLabelContainerView.centerYAnchor)
        ])
    }

    // MARK: - Configure
    
    func configure(favouriteBreedImage: FavouriteBreedImage) {
        self.breedNameLabel.text = favouriteBreedImage.name
        
        self.breedImageView.image = UIImage(named: "placeholder")
        ImageDownloadService.getImage(urlString: favouriteBreedImage.url) { [weak self] image, url in
            self?.breedImageView.image = image ?? UIImage(named: "placeholder")
        }
    }
}
