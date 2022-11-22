
import Foundation

protocol BreedDetailViewModelToViewDelegate: BaseViewModelToViewDelegate {
}

final class BreedDetailViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    let breed: Breed
    var breedDetails: [BreedDetail]?
    private let breedsRepository: BreedsRepositoryProtocol?
    weak var delegate: BreedDetailViewModelToViewDelegate?

    // MARK: - Init
    
    init(breed: Breed, breedsRepository: BreedsRepositoryProtocol) {
        self.breed = breed
        self.breedsRepository = breedsRepository
    }
    
    // MARK: - Functions
    
    func fetchBreedImages() {
        delegate?.showLoading(true)
        
        breedsRepository?.fetchBreedImages(by: breed.name, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let breedDetail):
                self.breedDetails = breedDetail
                
                // fetch favourite breed images
                self.breedsRepository?.fetchFavouriteBreedImages(by: self.breed.name, completion: { [weak self] favouriteBreedImagesResult in
                    self?.delegate?.showLoading(false)
                    
                    switch favouriteBreedImagesResult {
                    case .success(let favouriteBreedImages):
                        
                        // map favourite breed images on breedDetails model
                        for favouriteBreedImage in favouriteBreedImages ?? [] {
                            
                            if let index = self?.breedDetails?.firstIndex(where: { $0.imageUrl == favouriteBreedImage.url }) {
                                self?.breedDetails?[index].isFavourite = true
                            }
                        }
                        
                        self?.delegate?.updateUI()
                    case .failure(let error):
                        self?.delegate?.showError(error: error)
                    }
                })
            case .failure(let error):
                self.delegate?.showLoading(false)
                self.delegate?.showError(error: error)
            }
        })
    }
    
    func handleFavouriteButtonTap(at index: Int) {
        guard let breedDetail = breedDetails?[index] else { return }
        let favouriteBreedImage = FavouriteBreedImage(name: breed.name, url: breedDetail.imageUrl)
        
        // favourite or unfavourite breed image
        breedsRepository?.markFavouriteBreedImage(isFavourite: breedDetail.isFavourite, favouriteBreedImage: favouriteBreedImage, completion: { [weak self] error in
            
            if let error = error {
                self?.delegate?.showError(error: error)
            } else {
                self?.breedDetails?[index].isFavourite.toggle()
                self?.delegate?.updateUI()
            }
        })
    }
}

