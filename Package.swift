// swift-tools-version:5.5
import PackageDescription

let version = "1.1.0"
let vendorFrameworkshostingUrl = "https://github.com/SpotIM/openweb-ios-vendor-frameworks/releases/download/\(version)/"
let owSDK = "OpenWebSDK"
let owSDKWrapperTarget = "OpenWebSDKWrapperTarget"

let frameworksChecksumMapper = [
    "RxSwift": "189525e6d5f585a5f6a1f7c9e7b0c96eea3b978f787ab6fa44193e0ede66dbf3",
    "RxCocoa": "0af7ef734e5430b5022b4d3a6f1d13550c97a14f3ea16c91bac61500935c93aa",
    "RxRelay": "10b7f4192e30043e25638952764609d785a29abe628df5e1074fdc02264f9617"
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
        .iOS(.v12)
    ],
    products: products,
    dependencies: dependencies,
    targets: targets
)
