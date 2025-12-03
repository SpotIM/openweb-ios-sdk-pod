// swift-tools-version:5.5
import PackageDescription

let version = "1.2.0"
let owSDK = "OpenWebSDK"
let owSDKWrapperTarget = "OpenWebSDKWrapperTarget"

func createProducts() -> [Product] {
    let products: [Product] = [.library(name: owSDK, targets: [owSDKWrapperTarget])]

    return products
}

func createDependencies() -> [Package.Dependency] {
    return [
        .package(
            name: "OpenWebCommon",
            url: "https://github.com/SpotIM/openweb-ios-common-sdk-pod.git",
            .upToNextMinor(from: "1.1.0")
        )
    ]
}

func createTargets() -> [Target] {
    var targets = [Target]()

    // Adding OpenWebSDK xcframework
    let OpenWebSDK: Target = .binaryTarget(
        name: owSDK,
        path: "\(owSDK).xcframework"
    )
    targets.append(OpenWebSDK)

    // Adding a "wrapper" target which all xcframeworks are "dependencies" to this one
    let wrapperTarget: Target = .target(
        name: owSDKWrapperTarget,
        dependencies: [
            .target(name: "OpenWebSDK", condition: .when(platforms: .some([.iOS]))),
            .product(name: "OpenWebCommon", package: "OpenWebCommon")
        ],
        path: owSDKWrapperTarget,
        resources: [.copy("ow.dat")]
    )
    targets.append(wrapperTarget)

    return targets
}

let products = createProducts()
let dependencies = createDependencies()
let targets = createTargets()

let package = Package(
    name: owSDK,
    platforms: [
        .iOS(.v15)
    ],
    products: products,
    dependencies: dependencies,
    targets: targets
)
