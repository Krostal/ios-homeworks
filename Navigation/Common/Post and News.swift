
import UIKit

struct News {
    let title: String
    
}

struct Post {
    var author: String
    var description: String
    var image: String
    var likes: Int
    var views: Int
}

extension Post {
    static func make() -> [Post] {
        [
            Post(
                author: "marvel.official",
                description: "After stealing a mysterious orb in the far reaches of outer space, Peter Quill from Earth is now the main target of a manhunt led by the villain known as Ronan the Accuser. To help fight Ronan and his team and save the galaxy from his power, Quill creates a team of space heroes known as the \"Guardians of the Galaxy\" to save the galaxy",
                image: "GuardiansOfTheGalaxy_1",
                likes: 185,
                views: 250
            ),
            Post(
                author: "Entertainment Tonight",
                description: "Groot actor Vin Diesel has spoken about the heartwarming moment, describing the scene as \"very cool\". \"You know, just... on that front, it was very cool because it meant that the audience is now able to understand the vernacular, the language of this Flora colossus,\" he told Entertainment Tonight",
                image: "VinDieselGroot",
                likes: 2024,
                views: 3580
            ),
            Post(
                author: "IMAX World",
                description: "After saving Xandar from Ronan's wrath, the Guardians are now recognized as heroes. Now the team must help their leader, Star Lord, uncover the truth behind his true heritage. Along the way, old foes turn to allies and betrayal is blooming. And the Guardians find they are up against a devastating new menace who is out to rule the galaxy",
                image: "GuardiansOfTheGalaxy_2",
                likes: 6364,
                views: 1193),
            Post(
                author: "Walt Disney Studios Motion Pictures_official",
                description: "Still reeling from the loss of Gamora, Peter Quill rallies his team to defend the universe and one of their own - a mission that could mean the end of the Guardians if not successful.",
                image: "GuardiansOfTheGalaxy_3",
                likes: 400910,
                views: 1034018
            )
        ]
    }
}

