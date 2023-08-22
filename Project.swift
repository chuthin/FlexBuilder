import ProjectDescription
import ProjectDescriptionHelpers
let project = Project(
    name: "FlexBuilder",
    targets: [
        Target(
            name: "FlexBuilder",
            platform: .iOS,
            product: .framework,
            bundleId: "com.flexbuilder",
            deploymentTarget: .iOS(targetVersion: "11.0", devices: .iphone),
            infoPlist: .default,
            sources: .paths([.relativeToManifest("Sources/**")]),
            dependencies: [
                .external(name: "PinLayout"),
                .external(name: "FlexLayout"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ]
        ),
    ]
)
