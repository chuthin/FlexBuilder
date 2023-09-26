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
            sources: .paths([.relativeToManifest("Sources/FlexBuilder/**")]),
            dependencies: [
                .external(name: "PinLayout"),
                .external(name: "FlexLayout"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ],
            settings: .settings(
                base: ["BUILD_LIBRARY_FOR_DISTRIBUTION":"YES"], // DISTRIBUTION
                debug: [ "OTHER_LDFLAGS": "$(inherited) -Xlinker -interposable"] // injectionIII
            )

        ),
    ]
)
