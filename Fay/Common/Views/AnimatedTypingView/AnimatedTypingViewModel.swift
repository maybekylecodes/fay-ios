//
//  AnimatedTypingViewModel.swift
//  Fay
//
//  Created by Kyle Jennings on 7/13/24.
//

import Foundation
import Combine

@MainActor
class AnimatedTypingViewModel: ObservableObject {

    private enum AnimationState {
        case typing
        case retracting
        case pausing
    }

    private let words = ["Weight Loss", "Eating Disorders", "Diabetes",
                         "Pregnancy", "Binge Eating", "Pediatrics",
                         "IBS", "Anorexia", "PCOS", "Bulimia",
                         "ARFID", "Food Allergies", "Crohn's Disease",
                         "Celiac", "You"]

    // View
    @Published var displayText = String()
    @Published var underlineText = false

    // Animation Properties
    @Published private var currentWordIndex = 0
    private var currentCharIndex: String.Index?
    private var animationState: AnimationState = .typing

    // Animation Constants
    private let pauseDuration = 0.5
    private let typingDuration = 0.1

    // Combine
    private var timer: AnyCancellable?
    private var cancelables = Set<AnyCancellable>()

    init() {
        setup()
    }

    deinit {
        // Ensure we don't keep this in memory once deallocated
        timer?.cancel()
        timer = nil
    }

    private func setup() {
        setupSubscribers()
    }
}

// MARK: - Subscriber Setup
extension AnimatedTypingViewModel {
    private func setupSubscribers() {
        setupCurrentWordIndexSubscriber()
    }

    private func setupCurrentWordIndexSubscriber() {
        $currentWordIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.setUnderlineWith(index: index)
            }.store(in: &cancelables)
    }
}

// MARK: - Utility Functions
extension AnimatedTypingViewModel {
    private func setUnderlineWith(index: Int) {
        guard words.indices.contains(index) else {
            return
        }
        // To make it more impactful, we want to underline the word You
        underlineText = words[index].lowercased() == "you"
    }
}

// MARK: - Animation Functions
extension AnimatedTypingViewModel {
    func startAnimation() {
        stopAnimation()
        resetAnimation()
        timer = Timer.publish(every: typingDuration, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateAnimation()
            }
    }

    func stopAnimation() {
        timer?.cancel()
        timer = nil
    }

    private func resetAnimation() {
        displayText = String()
        currentWordIndex = 0
        currentCharIndex = words[currentWordIndex].startIndex
        animationState = .typing
    }

    private func updateAnimation() {
        switch animationState {
        case .typing:
            typeNextCharacter()

        case .retracting:
            retractNextCharacter()

        case .pausing:
            break
        }
    }

    private func typeNextCharacter() {
        guard let currentCharIndex = currentCharIndex,
              currentCharIndex < words[currentWordIndex].endIndex else {
            startRetracting()
            return
        }

        displayText.append(words[currentWordIndex][currentCharIndex])
        self.currentCharIndex = words[currentWordIndex].index(after: currentCharIndex)
    }

    private func retractNextCharacter() {
        guard !displayText.isEmpty else {
            moveToNextWord()
            return
        }

        displayText.removeLast()
    }

    private func startRetracting() {
        animationState = .pausing
        DispatchQueue.main.asyncAfter(deadline: .now() + pauseDuration) { [weak self] in
            self?.animationState = .retracting
        }
    }

    private func moveToNextWord() {
        currentWordIndex = (currentWordIndex + 1) % words.count // Loops easily
        startTyping()
    }

    private func startTyping() {
        animationState = .pausing
        DispatchQueue.main.asyncAfter(deadline: .now() + pauseDuration) { [weak self] in
            guard let self = self else { return }
            self.displayText = String()
            self.currentCharIndex = self.words[self.currentWordIndex].startIndex
            self.animationState = .typing
        }
    }
}
