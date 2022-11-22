
import Foundation

protocol FavouritesListViewModelToViewDelegate: BaseViewModelToViewDelegate {
}

final class FavouritesListViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    var filteredFavouriteBreedImages: [FavouriteBreedImage]?
    private var favouriteBreedImages: [FavouriteBreedImage]?
    private let breedsRepository: BreedsRepositoryProtocol?
    private var searchQuery = ""
    weak var delegate: FavouritesListViewModelToViewDelegate?

    // MARK: - Init
    
    init(breedsRepository: BreedsRepositoryProtocol) {
        self.breedsRepository = breedsRepository
    }
    
    // MARK: - Functions
    
    func fetchFavouriteBreedImages() {
        delegate?.showLoading(true)
        
        breedsRepository?.fetchFavouriteBreedImages(by: nil, completion: { [weak self] result in
            self?.delegate?.showLoading(false)
            
            switch result {
            case .success(let favouriteBreedImages):
                self?.favouriteBreedImages = favouriteBreedImages
                self?.filteredFavouriteBreedImages = favouriteBreedImages
                
                // if there's already a search query and user pulled to refresh
                self?.searchFavouriteBreedImages(searchQuery: self?.searchQuery ?? "")
            case .failure(let error):
                self?.delegate?.showError(error: error)
            }
        })
    }
    
    func searchFavouriteBreedImages(searchQuery: String) {
        self.searchQuery = searchQuery
        
        if searchQuery.isEmpty {
            filteredFavouriteBreedImages = favouriteBreedImages
        } else {
            filteredFavouriteBreedImages = favouriteBreedImages?.filter({
                $0.name.localizedCaseInsensitiveContains(searchQuery)
            })
        }
        
        self.delegate?.updateUI()
    }
}

