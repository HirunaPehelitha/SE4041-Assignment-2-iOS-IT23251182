//
//  SampleBooks.swift
//  BookNest
//
//  Short original stories so the library is not empty on first launch.
//

import Foundation
import SwiftData

enum SampleBooks {
    static let all: [(title: String, author: String, hue: Double, text: String)] = [
        ("The Kite Over Galle Fort", "BookNest Stories", 0.58, kiteStory),
        ("The Elephant Who Loved Rain", "BookNest Stories", 0.33, elephantStory),
        ("Grandmother's Kitchen", "BookNest Stories", 0.05, kitchenStory),
    ]

    /// Adds the sample books only if the library is empty.
    static func addIfLibraryIsEmpty(_ context: ModelContext) {
        let count = (try? context.fetchCount(FetchDescriptor<Book>())) ?? 0
        guard count == 0 else { return }

        for sample in all {
            context.insert(Book(title: sample.title, author: sample.author, text: sample.text, coverHue: sample.hue))
        }
        try? context.save()
    }

    // MARK: - For SwiftUI previews only

    static let previewContainer: ModelContainer = {
        let container = try! ModelContainer(for: Book.self, Bookmark.self,
                                            configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        addIfLibraryIsEmpty(container.mainContext)
        return container
    }()

    static var previewBook: Book {
        try! previewContainer.mainContext.fetch(FetchDescriptor<Book>()).first!
    }

    // MARK: - Story text

    static let kiteStory = """
    Every evening, when the sun turned the sea the colour of mango juice, Nimal climbed the old ramparts of Galle Fort with his kite under his arm. The kite was not beautiful. It was made from yesterday's newspaper, two sticks of bamboo and a tail of knotted ribbons his sister had found in a drawer. But it flew higher than any kite on the walls.

    The other children had bright plastic kites from the shop near the clock tower. They laughed at Nimal's newspaper kite. "It will tear," they said. "It will fall into the sea and the fish will read the news."

    Nimal only smiled. His grandfather had taught him that a kite does not fly because it is pretty. It flies because it is balanced, because its string is strong, and because the person holding it is patient.

    One windy afternoon the monsoon clouds rolled in early. The wind grew wild. One by one the shiny kites spun, dipped and crashed onto the rocks below. Their owners pulled in broken frames and tangled string.

    Nimal's kite shook and danced, but it did not fall. He let the string out slowly, then pulled it in, then let it out again, listening to the wind the way his grandfather had shown him. The newspaper kite climbed above the lighthouse, above the seagulls, until it was only a small grey square against the dark clouds.

    The other children gathered around him. "How do you do that?" a girl asked, holding the pieces of her red kite.

    Nimal handed her the string. "Feel it," he said. "The wind tells you what it wants. You just have to listen."

    That evening, on the old walls of the fort, nine children sat together folding newspaper and tying bamboo. Below them the sea kept reading the news, one wave at a time.
    """

    static let elephantStory = """
    In a forest near Minneriya there lived a young elephant named Kalu who loved the rain more than anything in the world. While the other elephants hid under the big trees when the clouds burst, Kalu ran into the open grass, lifted his trunk to the sky and trumpeted with joy.

    "You will catch a cold," said his aunt, who was very old and very wise.

    "Elephants do not catch colds," said Kalu, and he rolled in the mud until he was the colour of chocolate.

    But one year the rain did not come. The months went by and the sky stayed blue and empty. The grass turned yellow, then brown. The great tank where the herd drank every evening grew smaller and smaller until it was only a shining puddle in the middle of cracked earth.

    Kalu stopped playing. He stood at the edge of the forest each morning and stared at the sky, waiting.

    His aunt came and stood beside him. "Do you remember the old path?" she asked. "The one my mother showed me, many years ago? It goes over the hills to a river that never dries."

    Kalu did not know the path, but his aunt did. She was slow and her knees were stiff, so Kalu walked beside her and pushed the thorny branches out of her way. For three days the herd followed them, the babies walking in the shade of their mothers.

    On the fourth morning they heard it before they saw it: the sound of running water. The river was wide and cool and full of fish. The herd drank and splashed and sprayed each other until the sun went down.

    That night, for the first time in months, thunder rolled across the hills. Kalu looked up at his aunt. She was smiling. "Go on," she said. "Go and dance in it."

    And he did.
    """

    static let kitchenStory = """
    My grandmother's kitchen was the smallest room in the house, but it was where everything important happened. It smelled of curry leaves, coconut and wood smoke, and there was always something bubbling in a clay pot on the hearth.

    When I was seven, she let me help her for the first time. My job was to scrape the coconut. I sat on the low wooden stool with the metal blade at the front, held the half shell in both hands and turned it round and round. The white flakes fell like snow into the plate below. It took me a very long time, and half the coconut ended up on the floor, but my grandmother said it was the best coconut she had ever cooked with.

    She never used a recipe. When I asked her how much chilli to put in the pol sambol, she said, "Enough." When I asked how long to cook the dhal, she said, "Until it is ready." I thought she was teasing me. Now I understand she was teaching me to taste, to smell and to watch, instead of counting.

    On Sunday mornings the whole family came. Uncles, aunties, cousins I could not name. The kitchen filled with voices and the smell of milk rice. My grandmother moved between the pots like a conductor in front of an orchestra, tasting a little here, adding salt there.

    My grandmother is gone now, and the old house belongs to someone else. But every Sunday I scrape a coconut in my own small kitchen in the city. I add chilli until it is enough. I cook the dhal until it is ready. And for a few minutes, the room smells exactly like hers.
    """
}
