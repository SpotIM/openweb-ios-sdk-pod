// swift-tools-version:5.5
import PackageDescription

let version = "1.2.0"
let vendorFrameworkshostingUrl = "https://github.com/SpotIM/openweb-ios-vendor-frameworks/releases/download/\(version)/"
let owSDK = "OpenWebSDK"
let owSDKWrapperTarget = "OpenWebSDKWrapperTarget"

let frameworksChecksumMapper = [
    "RxSwift": "5828c5427354ca7384a9bf2faa9d574ba53d7d762e488dd7e6c5789a31c3f44b",
    "RxCocoa": "c81bb1633c519610489a27f48c1f5c19107149b10b2210da22f4cb14daca2ce8",
    "RxRelay": "ab6c4b1553b657a0ef48f1c84c56ce3abf6060e6f74442d90c34863e9714973f"
]

func createProducts() -> [Product] {
    let products: [Product] = [.library(name: owSDK, targets: [owSDKWrapperTarget])]

    return products
}

func createDependencies() -> [Package.Dependency] {
    return [
        .package(
            name: "OpenWebCommon",
            url: "https://github.com/SpotIM/openweb-ios-common-sdk-pod.git",
            .upToNextMinor(from: "1.0.0")
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
            .target(name: "RxRelay", condition: .when(platforms: .some([.iOS]))),
            .product(name: "OpenWebCommon", package: "OpenWebCommon")
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
let dependencies = createDependencies()
let targets = createTargets()

let package = Package(
    name: owSDK,
    platforms: [
        .iOS(.v13)
    ],
    products: products,
    dependencies: dependencies,
    targets: targets
)
