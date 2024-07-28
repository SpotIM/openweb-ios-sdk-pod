// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "OpenWebSDK",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "OpenWebSDK", targets: ["OpenWebSDKWrapperTarget"])
    ],
    dependencies: [
        // Here we define our package's external dependencies
        // and from where they can be fetched:
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            .upToNextMinor(from: "6.7.0")
        )
    ],
    targets: [
        .binaryTarget(
            name: "OpenWebSDK",
            path: "OpenWebSDK.xcframework"
        ),
        .target(
            name: "OpenWebSDKWrapperTarget",
            dependencies: [
                .target(name: "OpenWebSDK", condition: .when(platforms: .some([.iOS]))),
                "RxSwift",
                .product(name: "RxCocoa", package: "RxSwift"),
            ],
            path: "OpenWebSDKWrapperTarget"
        )
    ]
)
