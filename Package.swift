// swift-tools-version:5.5
import PackageDescription

let version = "1.0.0"
let vendorFrameworkshostingUrl = "https://github.com/SpotIM/openweb-ios-vendor-frameworks/releases/download/\(version)/"
let owSDK = "OpenWebSDK"
let owSDKWrapperTarget = "OpenWebSDKWrapperTarget"

let frameworksChecksumMapper = [
    "RxSwift": "e4b4b0b5673e218066cf191deb6ed7e9add990f457b97acb20c0787c4376e514",
    "RxCocoa": "65f7dc645cf6eef52384ff20bbbc27b2fac302055ed1bbffacf58b45dcff5d2f",
    "RxRelay": "b71d151141603d21f18cdc8a6417c6c58b9e5d9e60a3ee7d60e544cbc7061e99"
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
