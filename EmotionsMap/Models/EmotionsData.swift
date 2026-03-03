//
//  EmotionsData.swift
//  EmotionsMap
//
//  Created by Leo A.Molina on 23/02/26.
//

import Foundation
import SwiftData

struct EmotionsData {

    static let all: [(subEmotion: String, basicEmotion: BasicEmotion, specificEmotions: [(name: String, description: String)])] = [

        // MARK: - Joy (merged Joy + Love from Junto Wheel)
        ("Optimistic",   .joy, [
            ("Hopeful",       "Looking forward with confidence that things will improve."),
            ("Eager",         "Ready and energized to dive into what lies ahead.")
        ]),
        ("Enthusiastic", .joy, [
            ("Excited",       "A surge of positive energy about something upcoming."),
            ("Zealous",       "Intense dedication and enthusiasm for a goal or belief.")
        ]),
        ("Elation",      .joy, [
            ("Jubilant",      "Overflowing with joy, celebrating a wonderful outcome."),
            ("Euphoric",      "An intense, almost overwhelming sense of happiness.")
        ]),
        ("Proud",        .joy, [
            ("Illustrious",   "Feeling honored and recognized for something meaningful."),
            ("Triumphant",    "The pride of having overcome a challenge or won.")
        ]),
        ("Happy",        .joy, [
            ("Blissful",      "Complete happiness with no trace of worry."),
            ("Jovial",        "Light-hearted and cheerful, enjoying the present moment.")
        ]),
        ("Content",      .joy, [
            ("Amused",        "Finding genuine delight in something funny or playful."),
            ("Delighted",     "Pleasantly surprised by something that brings joy.")
        ]),
        ("Enthralled",   .joy, [
            ("Enchanted",     "Captivated by something magical or beautiful."),
            ("Rapturous",     "Overwhelmed by a deep sense of pleasure or beauty.")
        ]),
        ("Affectionate", .joy, [
            ("Romantic",      "A soft, warm feeling drawn toward closeness and love."),
            ("Fond",          "Gentle warmth and affection for someone or something.")
        ]),
        ("Longing",      .joy, [
            ("Sentimental",   "Tender feelings stirred by memories or moments past."),
            ("Attracted",     "Drawn toward someone with genuine interest and warmth.")
        ]),
        ("Desire",       .joy, [
            ("Passionate",    "Deep, intense feeling driving you toward what you love."),
            ("Infatuated",    "Consumed by admiration or longing for someone.")
        ]),
        ("Peaceful",     .joy, [
            ("Caring",        "A gentle, nurturing warmth toward another person."),
            ("Compassionate", "Feeling another's pain and genuinely wanting to help.")
        ]),
        ("Tenderness",   .joy, [
            ("Relieved",      "Tension has lifted after something difficult has passed."),
            ("Satisfied",     "A quiet sense that things turned out just right.")
        ]),

        // MARK: - Sadness (from Junto Wheel)
        ("Suffering",    .sadness, [
            ("Agony",         "A deep, intense emotional pain that feels unbearable."),
            ("Hurt",          "A sting from words or actions that pierced through you.")
        ]),
        ("Sad",          .sadness, [
            ("Depressed",     "A heavy, persistent low that drains energy and hope."),
            ("Sorrowful",     "A deep sadness, often tied to loss or longing.")
        ]),
        ("Disappointed", .sadness, [
            ("Dismayed",      "Shocked and saddened by an unexpected, unwanted outcome."),
            ("Displeased",    "Unhappy with how something turned out.")
        ]),
        ("Shameful",     .sadness, [
            ("Regretful",     "Wishing you had made a different choice."),
            ("Guilty",        "A sense that you've done something wrong or hurtful.")
        ]),
        ("Neglected",    .sadness, [
            ("Isolated",      "Feeling cut off from others, even in a crowd."),
            ("Lonely",        "Longing for connection that feels out of reach.")
        ]),
        ("Despair",      .sadness, [
            ("Grief",         "A profound loss that reshapes how you see the world."),
            ("Powerless",     "Unable to change or influence what's happening around you.")
        ]),

        // MARK: - Disgusted (from Plutchik Wheel)
        ("Repelled",     .disgusted, [
            ("Hesitant",      "Holding back, unsure whether you want to continue."),
            ("Horrified",     "Struck by something deeply disturbing or morally wrong.")
        ]),
        ("Awful",        .disgusted, [
            ("Detestable",    "Finding something completely repulsive and hard to tolerate."),
            ("Nauseated",     "A physical or emotional reaction of deep, unsettling disgust.")
        ]),
        ("Disapproving", .disgusted, [
            ("Revolted",      "Deeply disturbed by something that offends your values."),
            ("Appalled",      "Shocked and outraged by something morally unacceptable.")
        ]),
        ("Judgemental",  .disgusted, [
            ("Embarrassed",   "Self-conscious about something awkward or exposed."),
            ("Judgmental",    "Critically evaluating others through a harsh, unforgiving lens.")
        ]),
        ("Critical",     .disgusted, [
            ("Dismissive",    "Brushing something aside as unworthy of consideration."),
            ("Sceptical",     "Doubting or questioning the truth of what's being presented.")
        ]),

        // MARK: - Anger (from Junto Wheel)
        ("Rage",         .anger, [
            ("Hate",          "An intense, consuming aversion toward someone or something."),
            ("Hostile",       "Defensive and ready to fight; the world feels threatening.")
        ]),
        ("Exasperated",  .anger, [
            ("Agitated",      "Restless and on edge, struggling to find calm."),
            ("Frustrated",    "Blocked from what you want; your effort isn't paying off.")
        ]),
        ("Irritable",    .anger, [
            ("Annoyed",       "Mildly irritated by something persistent or repetitive."),
            ("Aggravated",    "Pushed beyond patience — more than just annoyed.")
        ]),
        ("Envy",         .anger, [
            ("Resentful",     "Holding onto old hurts that haven't been let go."),
            ("Jealous",       "Afraid of losing something important to someone else.")
        ]),
        ("Disgust",      .anger, [
            ("Contempt",      "Looking down on someone as beneath your standards."),
            ("Loathing",      "An extreme, visceral disgust that's hard to contain.")
        ]),

        // MARK: - Fear (from Junto Wheel)
        ("Horror",       .fear, [
            ("Dread",         "A heavy, anticipatory fear about something that's coming."),
            ("Mortified",     "Deeply shamed or humiliated beyond comfort.")
        ]),
        ("Nervous",      .fear, [
            ("Anxious",       "Uneasy about uncertainty, with your mind racing ahead."),
            ("Worried",       "Repeatedly turning over concerns about what might happen.")
        ]),
        ("Insecure",     .fear, [
            ("Inadequate",    "Feeling not good enough or unable to measure up."),
            ("Inferior",      "Believing others are more capable or worthy than you.")
        ]),
        ("Terror",       .fear, [
            ("Hysterical",    "Overwhelmed to the point where you feel out of control."),
            ("Panic",         "A sudden, intense rush of fear that's hard to manage.")
        ]),
        ("Scared",       .fear, [
            ("Helpless",      "No clear path forward; feeling stuck and unable to act."),
            ("Frightened",    "Startled or scared by something real or perceived.")
        ]),

        // MARK: - Surprise (from Junto Wheel)
        ("Stunned",      .surprise, [
            ("Shocked",       "Something completely unexpected has knocked you off balance."),
            ("Speechless",    "So surprised you can't find the words to respond.")
        ]),
        ("Confused",     .surprise, [
            ("Disillusioned", "What you believed turns out not to be true after all."),
            ("Perplexed",     "Confused and unable to make sense of what's happening.")
        ]),
        ("Amazed",       .surprise, [
            ("Astonished",    "Amazed by something far beyond what you expected."),
            ("Awe-struck",    "Overcome by the scale or beauty of something extraordinary.")
        ]),
        ("Overcome",     .surprise, [
            ("Astounded",     "Completely taken aback by the sheer unexpectedness."),
            ("Stimulated",    "Energized and activated by something new and engaging.")
        ]),
        ("Moved",        .surprise, [
            ("Touched",       "Moved in a soft, tender way by a kind act or moment."),
            ("Pleased",       "Happily surprised by something that exceeded your expectations.")
        ]),
    ]

    /// Call this once (e.g. on first launch) to seed the SwiftData store.
    @MainActor
    static func seed(into context: ModelContext) {
        // Avoid duplicate seeding
        let descriptor = FetchDescriptor<SubEmotion>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }

        for entry in all {
            let sub = SubEmotion(name: entry.subEmotion, basicEmotion: entry.basicEmotion)
            let specifics = entry.specificEmotions.map {
                SpecificEmotion(name: $0.name, basicEmotion: entry.basicEmotion, emotionDescription: $0.description)
            }
            sub.specificEmotions = specifics
            context.insert(sub)
            specifics.forEach { context.insert($0) }
        }
    }
}
