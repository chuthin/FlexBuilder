//
//  Show.swift
//  BuilderUI
//
//  Created by Chu Thin on 18/07/2023.
//

import Foundation
struct Series {
    let image = "sherlock"
    let showPopularity = 5
    let showYear = "2010"
    let showRating = "TV-14"
    let showLength = "3 Series"
    let selectedShow = "S3:E3"
    let showCast = "Benedict Cumberbatch, Martin Freeman, Una Stubbs"
    let showCreators = "Mark Gatiss, Steven Moffat"
    
    let shows: [Show] = [
        Show(title: "The Empty Hearse", length: "1h 26m", detail: "Two years after Shelock's \"death\". Watson has moved on. But when Long is threatened by a terrorrist attack, Sherlock decides it's time to return.", image: "sherlock"),
        Show(title: "The Sign of Three", length: "1h 26m", detail: "While mortal danger stalks Watson's wedding reception, Sherlock faces his biggest challenge of all: delivering a best man's speech!", image: "sherlock"),
        Show(title: "The Abominable Bride", length: "1h 29m", detail: "In this special set in 1895, Holmes and Watson investigate a vengeful apparition in a wedding dress, reportedly the ghost of a suicide victim. Holmes and Watson investigate a vengeful apparition in a wedding dress, reportedly the ghost of a suicide victim.", image: "sherlock"),
        Show(title: "His Last Vowe", length: "1h 29m", detail: "A case of stoeln letters leads Sherlock Holmes to engage in a long conflict with the powerful Chales Augustus Magnussen, the Napolean of blackmail.", image: "sherlock")
    ]
}

struct Show {
    let title: String
    let length: String
    let detail: String
    let image: String
    let showPopularity = 5
}

