import XCTest
@testable import Apeos

private class HeroesServicingMock: HeroesServicing {
    // MARK: - ListCharacters
    private(set) var listCharactersFromCallsCount = 0
    private(set) var listCharactersFromReceivedInvocations: [(numberOfPages: Int?, completion: (Result<MarvelResponse, Error>) -> Void)] = []
    var listCharactersFromClosure: ((Int?, @escaping (Result<MarvelResponse, Error>) -> Void) -> Void)?

    func listCharacters(from numberOfPages: Int?, _ completion: @escaping (Result<MarvelResponse, Error>) -> Void) {
        listCharactersFromCallsCount += 1
        listCharactersFromReceivedInvocations.append((numberOfPages: numberOfPages, completion: completion))
        listCharactersFromClosure?(numberOfPages, completion)
    }

    // MARK: - SaveCharacter
    private(set) var saveCharacterCallsCount = 0
    private(set) var saveCharacterReceivedInvocations: [Character] = []
    var saveCharacterClosure: ((Character) -> Void)?

    func saveCharacter(_ character: Character) {
        saveCharacterCallsCount += 1
        saveCharacterReceivedInvocations.append(character)
        saveCharacterClosure?(character)
    }

    // MARK: - CheckIfFavorite
    private(set) var checkIfFavoriteFromCallsCount = 0
    private(set) var checkIfFavoriteFromReceivedInvocations: [Character] = []
    var checkIfFavoriteFromReturnValue: Character?
    var checkIfFavoriteFromClosure: ((Character) -> Character?)?

    func checkIfFavorite(from character: Character) -> Character? {
        checkIfFavoriteFromCallsCount += 1
        checkIfFavoriteFromReceivedInvocations.append(character)
        return checkIfFavoriteFromClosure.map({ $0(character) }) ?? checkIfFavoriteFromReturnValue
    }

    // MARK: - DeleteCharacter
    private(set) var deleteCharacterCallsCount = 0
    private(set) var deleteCharacterReceivedInvocations: [Character] = []
    var deleteCharacterClosure: ((Character) -> Void)?

    func deleteCharacter(_ character: Character) {
        deleteCharacterCallsCount += 1
        deleteCharacterReceivedInvocations.append(character)
        deleteCharacterClosure?(character)
    }
}

private class HeroesPresentingSpy: HeroesPresenting {
    var viewController: HeroesDisplaying?

    // MARK: - ConfigureCharacters
    private(set) var configureCharactersFromCallsCount = 0
    private(set) var configureCharactersFromReceivedInvocations: [[Character]] = []

    func configureCharacters(from characters: [Character]) {
        configureCharactersFromCallsCount += 1
        configureCharactersFromReceivedInvocations.append(characters)
    }

    // MARK: - UpdateCharacters
    private(set) var updateCharactersFromCallsCount = 0
    private(set) var updateCharactersFromReceivedInvocations: [[Character]] = []

    func updateCharacters(from characters: [Character]) {
        updateCharactersFromCallsCount += 1
        updateCharactersFromReceivedInvocations.append(characters)
    }

    // MARK: - StartFooterLoading
    private(set) var startFooterLoadingCallsCount = 0

    func startFooterLoading() {
        startFooterLoadingCallsCount += 1
    }

    // MARK: - StopFooterLoading
    private(set) var stopFooterLoadingCallsCount = 0

    func stopFooterLoading() {
        stopFooterLoadingCallsCount += 1
    }

    // MARK: - ShowError
    private(set) var showErrorCallsCount = 0

    func showError() {
        showErrorCallsCount += 1
    }

    // MARK: - ShowEmptyState
    private(set) var showEmptyStateCallsCount = 0

    func showEmptyState() {
        showEmptyStateCallsCount += 1
    }

    // MARK: - ShowFooterError
    private(set) var showFooterErrorCallsCount = 0

    func showFooterError() {
        showFooterErrorCallsCount += 1
    }
}

final class HeroesInteractorTests: XCTestCase {
    private let serviceMock = HeroesServicingMock()
    private let presenterSpy = HeroesPresentingSpy()
    
    private lazy var sut: HeroesInteractor = {
        return HeroesInteractor(service: serviceMock, presenter: presenterSpy)
    }()
    
    func testLoadData_WhenSuccessFromServiceAndReturnAnArray_ShouldListCharacterConfigured() {
        serviceMock.listCharactersFromClosure = { _, completion in
            completion(
                .success(
                    MarvelResponse(
                        data: MarvelData(
                            offset: 0,
                            limit: 20,
                            total: 1000,
                            count: 20,
                            results: [
                                Character(
                                    id: 1,
                                    name: "Sample Name",
                                    description: "Sample Description",
                                    thumbnail: Thumbnail(path: "PATH_FILE", fileExtension: "jpg")
                                )
                            ]
                        )
                    )
                )
            )
        }
        
        sut.loadData()
        
        XCTAssertEqual(presenterSpy.configureCharactersFromCallsCount, 1)
        XCTAssertEqual(presenterSpy.configureCharactersFromReceivedInvocations.first?.count, 1)
    }
    
    func testLoadData_WhenSuccessFromServiceAndReturnEmptyArray_ShouldShowEmptyState() {
        serviceMock.listCharactersFromClosure = { _, completion in
            completion(
                .success(
                    MarvelResponse(
                        data: MarvelData(
                            offset: 0,
                            limit: 20,
                            total: 1000,
                            count: 20,
                            results: []
                        )
                    )
                )
            )
        }
        
        sut.loadData()
        
        XCTAssertEqual(presenterSpy.showEmptyStateCallsCount, 1)
    }
    
    func testLoadData_WhenFailureFromService_ShouldShowError() {
        serviceMock.listCharactersFromClosure = { _, completion in
            completion(.failure(NSError(domain: "", code: 1, userInfo: nil)))
        }
        
        sut.loadData()
        
        XCTAssertEqual(presenterSpy.showErrorCallsCount, 1)
    }
    
    func testReloadData_WhenIsSearchTrue_ShouldNotCallConfigureCharacters() {
        sut.beginSearchEditing()
        sut.reloadData()
        
        XCTAssertEqual(presenterSpy.configureCharactersFromCallsCount, 0)
    }
    
    func testReloadData_WhenIsSearchFalse_ShouldCallConfigureCharacters() {
        sut.reloadData()
        
        XCTAssertEqual(presenterSpy.configureCharactersFromCallsCount, 1)
    }
    
    func testLoadMoreData_WhenSuccessFromService_ShouldCallUpdateCharacters() {
        serviceMock.listCharactersFromClosure = { _, completion in
            completion(
                .success(
                    MarvelResponse(
                        data: MarvelData(
                            offset: 0,
                            limit: 20,
                            total: 1000,
                            count: 20,
                            results: [
                                Character(
                                    id: 1,
                                    name: "Sample Name",
                                    description: "Sample Description",
                                    thumbnail: Thumbnail(path: "PATH_FILE", fileExtension: "jpg")
                                )
                            ]
                        )
                    )
                )
            )
        }
        
        sut.loadMoreData()
        
        XCTAssertEqual(presenterSpy.startFooterLoadingCallsCount, 1)
        XCTAssertEqual(presenterSpy.stopFooterLoadingCallsCount, 1)
        XCTAssertEqual(presenterSpy.updateCharactersFromCallsCount, 1)
        XCTAssertEqual(presenterSpy.updateCharactersFromReceivedInvocations.first?.count, 1)
    }
    
    func testLoadMoreData_WhenFailureFromService_ShouldCallShowFooterError() {
        serviceMock.listCharactersFromClosure = { _, completion in
            completion(.failure(NSError(domain: "", code: 1, userInfo: nil)))
        }
        
        sut.loadMoreData()
        
        XCTAssertEqual(presenterSpy.startFooterLoadingCallsCount, 1)
        XCTAssertEqual(presenterSpy.stopFooterLoadingCallsCount, 1)
        XCTAssertEqual(presenterSpy.showFooterErrorCallsCount, 1)
    }
    
    func testInitializeCharacters_ShouldCallConfigureCharacters() {
        serviceMock.listCharactersFromClosure = { _, completion in
            completion(
                .success(
                    MarvelResponse(
                        data: MarvelData(
                            offset: 0,
                            limit: 20,
                            total: 1000,
                            count: 20,
                            results: [
                                Character(
                                    id: 1,
                                    name: "Sample Name",
                                    description: "Sample Description",
                                    thumbnail: Thumbnail(path: "PATH_FILE", fileExtension: "jpg")
                                )
                            ]
                        )
                    )
                )
            )
        }
        
        sut.loadMoreData()
        sut.initializeCharacters()
        
        XCTAssertEqual(presenterSpy.configureCharactersFromCallsCount, 1)
        XCTAssertEqual(presenterSpy.configureCharactersFromReceivedInvocations.first?.count, 1)
    }
    
    func testFilterContentForSearch_WhenTextNotEmpty_ShouldCallConfigureCharactersFiltered() {
        serviceMock.listCharactersFromClosure = { _, completion in
            completion(
                .success(
                    MarvelResponse(
                        data: MarvelData(
                            offset: 0,
                            limit: 20,
                            total: 1000,
                            count: 20,
                            results: [
                                Character(
                                    id: 1,
                                    name: "Sample Name",
                                    description: "Sample Description",
                                    thumbnail: Thumbnail(path: "PATH_FILE", fileExtension: "jpg")
                                ),
                                Character(
                                    id: 1,
                                    name: "OOOOOOOO",
                                    description: "Sample Description",
                                    thumbnail: Thumbnail(path: "PATH_FILE", fileExtension: "jpg")
                                )
                            ]
                        )
                    )
                )
            )
        }
        
        sut.loadData()
        sut.filterContentForSearch(from: "na")
        
        XCTAssertEqual(presenterSpy.configureCharactersFromCallsCount, 2)
        XCTAssertEqual(presenterSpy.configureCharactersFromReceivedInvocations.last?.count, 1)
    }
    
    func testFavoriteOrUnfavorite_WhenCheckFavoriteIsTrue_ShouldCallSaveCharacter() {
        let character = Character(
            id: 1,
            name: "Sample Name",
            description: "Sample Description",
            thumbnail: Thumbnail(path: "PATH_FILE", fileExtension: "jpg")
        )
        
        serviceMock.checkIfFavoriteFromClosure = { character -> Character? in
            return character
        }
        
        sut.favoriteOrUnfavorite(from: character)
        
        XCTAssertEqual(serviceMock.checkIfFavoriteFromCallsCount, 1)
        XCTAssertEqual(serviceMock.deleteCharacterCallsCount, 1)
    }
    
    func testFavoriteOrUnfavorite_WhenCheckFavoriteIsFalse_ShouldCallDeleteCharacter() {
        let character = Character(
            id: 1,
            name: "Sample Name",
            description: "Sample Description",
            thumbnail: Thumbnail(path: "PATH_FILE", fileExtension: "jpg")
        )
        
        serviceMock.checkIfFavoriteFromClosure = { character -> Character? in
            return nil
        }
        
        sut.favoriteOrUnfavorite(from: character)
        
        XCTAssertEqual(serviceMock.checkIfFavoriteFromCallsCount, 1)
        XCTAssertEqual(serviceMock.saveCharacterCallsCount, 1)
    }
}
