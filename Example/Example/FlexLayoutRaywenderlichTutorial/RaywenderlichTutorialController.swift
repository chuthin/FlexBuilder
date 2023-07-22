//
//  ReywnderlichTutorialController.swift
//  BuilderUI
//
//  Created by Chu Thin on 18/07/2023.
//

import Foundation
import FlexBuilder
struct ReywnderlichTutorialController : ControllerBuilder {
    @Variable var showSelected: Show? = nil
    var series = Series()
    func view() -> any BuilderViewController {
        return FViewController {
            FScrollView {
                FVStack {
                    FImage(named: series.image).aspectRatio(16/9).contentMode(.scaleAspectFill).clipsToBounds(true)
                    FVStack {
                        FHStack(space: 4){
                            FText(String(repeating: "★", count: series.showPopularity)).color(.red)
                            FText(series.showYear).color(.lightGray)
                            FText(series.showRating).color(.lightGray)
                            FText(series.showLength).color(.lightGray)
                        }
                        FSpacer()
                        FHStack{
                            FText(series.selectedShow).font(.boldSystemFont(ofSize: 16)).color(.lightGray).margin(.right,20)
                            FText($showSelected.asObservable().map{$0?.title}).font(.boldSystemFont(ofSize: 16)).color(.lightGray).fits()
                        }
                        FSpacer()
                        FText($showSelected.asObservable().map{$0?.detail}).numberOfLines(0).font(.systemFont(ofSize: 14)).color(.lightGray)
                        FSpacer(4)
                        FText("Cast: \(series.showCast)").numberOfLines(0).font(.systemFont(ofSize: 14)).color(.lightGray)
                        FSpacer()
                        FHStack {
                            FVStack{
                                FImage(named: "add").width(50).height(50)
                                FSpacer()
                                FText("My list").font(.systemFont(ofSize: 14)).color(.lightGray).alignment(.center)
                            }
                            FSpacer(width: 40)
                            FVStack{
                                FImage(named: "share").width(50).height(50)
                                FSpacer()
                                FText("Share").font(.systemFont(ofSize: 14)).color(.lightGray).alignment(.center)
                            }
                        }
                        FSpacer(8)
                        FVStack().height(4).width(68).backgroundColor(.red)
                        FSpacer(4)
                        FHStack {
                            FText("EPISODES").font(.boldSystemFont(ofSize: 14)).color(.lightGray)
                            FSpacer(width: 20)
                            FText("MORE LIKE THIS").font(.systemFont(ofSize: 14)).color(.lightGray)
                        }
                        FSpacer()
                        FForEach(series.shows) { show in
                            FVStack {
                                FHStack {
                                    FImage(named: show.image).aspectRatio(16/10).height(100).margin(.right,12)
                                    FVStack {
                                        FText(show.title).font(.systemFont(ofSize: 14)).color(.lightGray)
                                        FSpacer(4)
                                        FText(show.length).font(.systemFont(ofSize: 10)).color(.lightGray)
                                    }.fits().alignSelf(.center)
                                    FImage(named: "download").width(25).height(25).alignSelf(.center)
                                }
                                FSpacer()
                            }
                            .onTapGesture{ _ in
                                showSelected = show
                            }
                            
                        }
                    }
                    .padding(12)
                    
                }.backgroundColor(.black)
            }
        }
        .title("Reywnderlich Tutorial")
        .viewWillAppear { 
            showSelected = series.shows[0]
        }
    }
}
