// swift-tools-version:5.5
import PackageDescription

let version = "9.9.9"
let vendorFrameworkshostingUrl = "https://github.com/SpotIM/openweb-ios-vendor-frameworks/releases/download/\(version)/"
let owSDK = "OpenWebSDK"
let owSDKWrapperTarget = "OpenWebSDKWrapperTarget"

let frameworksChecksumMapper = [
    "RxSwift": "7a21214a4c4a83024f0b280354c32accc843b33deecdbb52631393f61884b16f",
    "RxCocoa": "e9bd11610fc63817405be80ac49de08685226ddce2ff77f032d96403f491a5b0",
    "RxRelay": "4f3b2ebcf8a09ae6c72b75e0d581b657598ce18aa8a5bbb43f22e71569e78eec"
]

func createProducts() -> [Product] {
    let products: [Product] = [.library(name: owSDK, targets: [owSDKWrapperTarget]),
                               .library(name: "RxSwift", targets: [owSDKWrapperTarget]),
                               .library(name: "RxCocoa", targets: [owSDKWrapperTarget]),
                               .library(name: "RxRelay", targets: [owSDKWrapperTarget])]

    return products
}

func createTargets() -> [Target] {
    var targets = [Target]()

    // Adding OpenWebSDK xcframework
    let OpenWebSDK: Target = .binaryTarget(
        name: owSDK,
        path: "\(owSDK).xcframework"
    )
    targets.append(OpenWebSDK)

    // Adding remote vendors xcframework(s)
    let remoteTargets = frameworksChecksumMapper.flatMap { framework, checksum -> [Target] in
        return [createRemoteTarget(framework: framework, checksum: checksum)]
    }
    targets.append(contentsOf: remoteTargets)

    // Adding a "wrapper" target which all xcframeworks are "dependencies" to this one
    let wrapperTarget: Target = .target(
        name: owSDKWrapperTarget,
        dependencies: [
            .target(name: "OpenWebSDK", condition: .when(platforms: .some([.iOS]))),
            .target(name: "RxSwift", condition: .when(platforms: .some([.iOS]))),
            .target(name: "RxCocoa", condition: .when(platforms: .some([.iOS]))),
            .target(name: "RxRelay", condition: .when(platforms: .some([.iOS])))
        ],
        path: owSDKWrapperTarget
    )
    targets.append(wrapperTarget)

    return targets
}

func createRemoteTarget(framework: String, checksum: String = "") -> Target {
    return Target.binaryTarget(name: "\(framework)",
                               url: "\(vendorFrameworkshostingUrl)\(framework).xcframework.zip",
                               checksum: checksum)
}

let products = createProducts()
let targets = createTargets()

let package = Package(
    name: owSDK,
    platforms: [
        .iOS(.v12)
    ],
    products: products,
    targets: targets
)
