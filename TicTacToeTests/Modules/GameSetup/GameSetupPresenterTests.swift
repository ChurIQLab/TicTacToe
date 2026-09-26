//
//  GameSetupPresenterTests.swift
//  TicTacToeTests
//
//  Created by Churkin Vitaly on 25.09.2026.
//

import Foundation
import Testing
@testable import TicTacToe

struct GameSetupPresenterTests {

    @Test(arguments: [
        (GameMode.computer, String(localized: .computerTitle)),
        (GameMode.twoPlayers, String(localized: .twoPlayersTitle))
    ])
    func viewDidLoadSetsModeTitle(mode: GameMode, title: String) {
        let view = GameSetupViewSpy()
        let presenter = GameSetupPresenter(mode: mode, router: RouterSpy(), settings: SettingsServiceFake())
        presenter.view = view

        presenter.viewDidLoad()

        #expect(view.events.first == .setTitle(title))
    }

    @Test func twoPlayersSetupShowsNameFieldsAndFigures() {
        let view = GameSetupViewSpy()
        let settings = SettingsServiceFake(twoPlayersFigures: [.first: .star, .second: .heart])
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: RouterSpy(), settings: settings)
        presenter.view = view

        presenter.viewDidLoad()

        #expect(view.events.last == .showPlayers([
            PlayerSetupViewModel(
                nameField: NameFieldViewModel(
                    side: .first,
                    label: String(localized: .firstPlayerName),
                    placeholder: String(localized: .firstPlayerName),
                    text: "",
                    maxLength: GameConfiguration.maxNameLength
                ),
                figurePicker: FigurePickerViewModel(side: .first, selected: .star, taken: .heart)
            ),
            PlayerSetupViewModel(
                nameField: NameFieldViewModel(
                    side: .second,
                    label: String(localized: .secondPlayerName),
                    placeholder: String(localized: .secondPlayerName),
                    text: "",
                    maxLength: GameConfiguration.maxNameLength
                ),
                figurePicker: FigurePickerViewModel(side: .second, selected: .heart, taken: .star)
            )
        ], hint: String(localized: .twoPlayersSetupHint)))
    }

    @Test func computerSetupShowsDifficultyAndPlayerFigures() {
        let view = GameSetupViewSpy()
        let settings = SettingsServiceFake(computerModeFigure: .circle, computerDifficulty: .hard)
        let presenter = GameSetupPresenter(mode: .computer, router: RouterSpy(), settings: settings)
        presenter.view = view

        presenter.viewDidLoad()

        #expect(view.events.last == .showComputerSetup(ComputerSetupViewModel(
            difficultyLabel: String(localized: .difficultyLabel),
            difficulty: DifficultyPickerViewModel(
                titles: [
                    String(localized: .easyDifficulty),
                    String(localized: .mediumDifficulty),
                    String(localized: .hardDifficulty)
                ],
                selectedIndex: 2,
                hint: String(localized: .hardDifficultyHint)
            ),
            figureLabel: String(localized: .yourFigureLabel),
            figurePicker: FigurePickerViewModel(side: .first, selected: .circle, taken: nil),
            figureHint: String(localized: .computerFigureHint)
        )))
    }

    @Test(arguments: [
        (0, String(localized: .easyDifficultyHint)),
        (2, String(localized: .hardDifficultyHint))
    ])
    func selectedDifficultyUpdatesPicker(index: Int, hint: String) {
        let view = GameSetupViewSpy()
        let presenter = GameSetupPresenter(mode: .computer, router: RouterSpy(), settings: SettingsServiceFake())
        presenter.view = view

        presenter.didSelectDifficulty(at: index)

        guard case .updateDifficultyPicker(let picker) = view.events.last else {
            Issue.record("Difficulty picker is not updated")
            return
        }
        #expect(picker.selectedIndex == index)
        #expect(picker.hint == hint)
    }

    @Test(arguments: [1, -1, 3])
    func currentOrUnknownDifficultyIsIgnored(index: Int) {
        let view = GameSetupViewSpy()
        let presenter = GameSetupPresenter(mode: .computer, router: RouterSpy(), settings: SettingsServiceFake())
        presenter.view = view

        presenter.didSelectDifficulty(at: index)

        #expect(view.events.isEmpty)
    }

    @Test func twoPlayersSetupIgnoresDifficulty() {
        let view = GameSetupViewSpy()
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: RouterSpy(), settings: SettingsServiceFake())
        presenter.view = view

        presenter.didSelectDifficulty(at: 2)

        #expect(view.events.isEmpty)
    }

    @Test func tapOnPlayPassesAndSavesDifficulty() {
        let router = RouterSpy()
        let settings = SettingsServiceFake()
        let presenter = GameSetupPresenter(mode: .computer, router: router, settings: settings)

        presenter.didSelectDifficulty(at: 0)
        presenter.didTapPlay()

        #expect(router.events == [.showGame(GameConfiguration(mode: .computer, difficulty: .easy))])
        #expect(settings.computerDifficulty == .easy)
    }

    @Test func savedDifficultyGoesToGame() {
        let router = RouterSpy()
        let settings = SettingsServiceFake(computerDifficulty: .hard)
        let presenter = GameSetupPresenter(mode: .computer, router: router, settings: settings)

        presenter.didTapPlay()

        #expect(router.events == [.showGame(GameConfiguration(mode: .computer, difficulty: .hard))])
    }

    @Test func leavingWithoutPlayKeepsSavedDifficulty() {
        let settings = SettingsServiceFake(computerDifficulty: .hard)
        let presenter = GameSetupPresenter(mode: .computer, router: RouterSpy(), settings: settings)

        presenter.didSelectDifficulty(at: 0)

        #expect(settings.computerDifficulty == .hard)
    }

    @Test func tapOnPlayPassesEnteredNames() {
        let router = RouterSpy()
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: router, settings: SettingsServiceFake())

        presenter.didChangeName("Ан", for: .first)
        presenter.didChangeName("Аня ", for: .first)
        presenter.didChangeName("Макс", for: .second)
        presenter.didTapPlay()

        #expect(router.events == [.showGame(GameConfiguration(
            mode: .twoPlayers,
            names: [.first: "Аня", .second: "Макс"]
        ))])
    }

    @Test func clearedNameFallsBackToDefault() {
        let router = RouterSpy()
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: router, settings: SettingsServiceFake())

        presenter.didChangeName("Аня", for: .first)
        presenter.didChangeName("", for: .first)
        presenter.didTapPlay()

        #expect(router.events == [.showGame(GameConfiguration(mode: .twoPlayers))])
    }

    @Test(arguments: GameMode.allCases)
    func tapOnPlayShowsGameOfMode(mode: GameMode) {
        let router = RouterSpy()
        let presenter = GameSetupPresenter(mode: mode, router: router, settings: SettingsServiceFake())

        presenter.didTapPlay()

        #expect(router.events == [.showGame(GameConfiguration(mode: mode))])
    }

    @Test func twoPlayersGameGetsSavedFigures() {
        let router = RouterSpy()
        let settings = SettingsServiceFake(twoPlayersFigures: [.first: .star, .second: .heart])
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: router, settings: settings)

        presenter.didTapPlay()

        #expect(router.events == [.showGame(GameConfiguration(
            mode: .twoPlayers,
            figures: [.first: .star, .second: .heart]
        ))])
    }

    @Test(arguments: [
        (Figure.star, Figure.circle),
        (Figure.circle, Figure.cross)
    ])
    func computerGameGetsSavedPlayerFigureAndAnotherForComputer(player: Figure, computer: Figure) {
        let router = RouterSpy()
        let settings = SettingsServiceFake(
            twoPlayersFigures: [.first: .heart, .second: .hexagon],
            computerModeFigure: player
        )
        let presenter = GameSetupPresenter(mode: .computer, router: router, settings: settings)

        presenter.didTapPlay()

        #expect(router.events == [.showGame(GameConfiguration(
            mode: .computer,
            figures: [.first: player, .second: computer]
        ))])
    }

    @Test func selectedFigureUpdatesBothPickers() {
        let view = GameSetupViewSpy()
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: RouterSpy(), settings: SettingsServiceFake())
        presenter.view = view

        presenter.didSelectFigure(.star, for: .second)

        #expect(view.events == [.updateFigurePickers([
            FigurePickerViewModel(side: .first, selected: .cross, taken: .star),
            FigurePickerViewModel(side: .second, selected: .star, taken: .cross)
        ])])
    }

    @Test func opponentFigureCannotBeSelected() {
        let view = GameSetupViewSpy()
        let router = RouterSpy()
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: router, settings: SettingsServiceFake())
        presenter.view = view

        presenter.didSelectFigure(.circle, for: .first)
        presenter.didTapPlay()

        #expect(view.events.isEmpty)
        #expect(router.events == [.showGame(GameConfiguration(mode: .twoPlayers))])
    }

    @Test func computerSideCannotBeSelected() {
        let view = GameSetupViewSpy()
        let presenter = GameSetupPresenter(mode: .computer, router: RouterSpy(), settings: SettingsServiceFake())
        presenter.view = view

        presenter.didSelectFigure(.star, for: .second)

        #expect(view.events.isEmpty)
    }

    @Test func playerCanTakeCircleAgainstComputer() {
        let view = GameSetupViewSpy()
        let router = RouterSpy()
        let presenter = GameSetupPresenter(mode: .computer, router: router, settings: SettingsServiceFake())
        presenter.view = view

        presenter.didSelectFigure(.circle, for: .first)
        presenter.didTapPlay()

        #expect(view.events == [.updateFigurePickers([
            FigurePickerViewModel(side: .first, selected: .circle, taken: nil)
        ])])
        #expect(router.events == [.showGame(GameConfiguration(
            mode: .computer,
            figures: [.first: .circle, .second: .cross]
        ))])
    }

    @Test func tapOnPlaySavesTwoPlayersFigures() {
        let settings = SettingsServiceFake()
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: RouterSpy(), settings: settings)

        presenter.didSelectFigure(.star, for: .first)
        presenter.didSelectFigure(.heart, for: .second)
        presenter.didTapPlay()

        #expect(settings.twoPlayersFigures == [.first: .star, .second: .heart])
        #expect(settings.computerModeFigure == .cross)
    }

    @Test func tapOnPlaySavesComputerModeFigure() {
        let settings = SettingsServiceFake()
        let presenter = GameSetupPresenter(mode: .computer, router: RouterSpy(), settings: settings)

        presenter.didSelectFigure(.hexagon, for: .first)
        presenter.didTapPlay()

        #expect(settings.computerModeFigure == .hexagon)
        #expect(settings.twoPlayersFigures == [.first: .cross, .second: .circle])
    }

    @Test func leavingWithoutPlayKeepsSavedFigures() {
        let settings = SettingsServiceFake()
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: RouterSpy(), settings: settings)

        presenter.didSelectFigure(.star, for: .first)

        #expect(settings.twoPlayersFigures == [.first: .cross, .second: .circle])
    }

    @Test func savedNamesFillFieldsAndGoToGame() {
        let view = GameSetupViewSpy()
        let router = RouterSpy()
        let settings = SettingsServiceFake(twoPlayersNames: [.first: "Аня"])
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: router, settings: settings)
        presenter.view = view

        presenter.viewDidLoad()
        presenter.didTapPlay()

        guard case .showPlayers(let players, _) = view.events.last else {
            Issue.record("Players are not shown")
            return
        }
        #expect(players.map(\.nameField.text) == ["Аня", ""])
        #expect(router.events == [.showGame(GameConfiguration(mode: .twoPlayers, names: [.first: "Аня"]))])
    }

    @Test func tapOnPlaySavesTrimmedNames() {
        let settings = SettingsServiceFake(twoPlayersNames: [.first: "Аня", .second: "Макс"])
        let presenter = GameSetupPresenter(mode: .twoPlayers, router: RouterSpy(), settings: settings)

        presenter.didChangeName("  Вера ", for: .first)
        presenter.didChangeName(" ", for: .second)
        presenter.didTapPlay()

        #expect(settings.twoPlayersNames == [.first: "Вера"])
    }

    @Test func computerGameDoesNotChangeSavedNames() {
        let router = RouterSpy()
        let settings = SettingsServiceFake(twoPlayersNames: [.first: "Аня"])
        let presenter = GameSetupPresenter(mode: .computer, router: router, settings: settings)

        presenter.didTapPlay()

        #expect(settings.twoPlayersNames == [.first: "Аня"])
        #expect(router.events == [.showGame(GameConfiguration(mode: .computer))])
    }
}

// MARK: - GameSetupViewSpy

private final class GameSetupViewSpy: GameSetupViewProtocol {

    // MARK: - Properties

    private(set) var events: [Event] = []

    // MARK: - GameSetupViewProtocol

    func setTitle(_ title: String) {
        events.append(.setTitle(title))
    }

    func showPlayers(_ players: [PlayerSetupViewModel], hint: String) {
        events.append(.showPlayers(players, hint: hint))
    }

    func showComputerSetup(_ setup: ComputerSetupViewModel) {
        events.append(.showComputerSetup(setup))
    }

    func updateFigurePickers(_ pickers: [FigurePickerViewModel]) {
        events.append(.updateFigurePickers(pickers))
    }

    func updateDifficultyPicker(_ picker: DifficultyPickerViewModel) {
        events.append(.updateDifficultyPicker(picker))
    }
}

// MARK: - Event

extension GameSetupViewSpy {
    nonisolated enum Event: Equatable {
        case setTitle(String)
        case showPlayers([PlayerSetupViewModel], hint: String)
        case showComputerSetup(ComputerSetupViewModel)
        case updateFigurePickers([FigurePickerViewModel])
        case updateDifficultyPicker(DifficultyPickerViewModel)
    }
}
