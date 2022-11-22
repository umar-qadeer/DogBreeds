
import Foundation

protocol BreedsListViewModelToViewDelegate: BaseViewModelToViewDelegate {
}

final class BreedsListViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    var breeds: [Breed]?
    private let breedsRepository: BreedsRepositoryProtocol?
    weak var delegate: BreedsListViewModelToViewDelegate?

    // MARK: - Initializers
    
    init(breedsRepository: BreedsRepositoryProtocol) {
        self.breedsRepository = breedsRepository
    }
    
    // MARK: - Functions
    
    func fetchBreeds() {
        delegate?.showLoading(true)
        
        breedsRepository?.fetchBreeds(completion: { [weak self] result in
            self?.delegate?.showLoading(false)
            
            switch result {
            case .success(let breeds):
                self?.breeds = breeds
                self?.delegate?.updateUI()
            case .failure(let error):
                self?.delegate?.showError(error: error)
            }
        })
    }
}

