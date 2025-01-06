// swift-tools-version:5.5
import PackageDescription

let version = "1.0.0"
let vendorFrameworkshostingUrl = "https://github.com/SpotIM/openweb-ios-vendor-frameworks/releases/download/\(version)/"
let owSDK = "OpenWebSDK"
let owSDKCommon = "OpenWebCommon"
let owSDKWrapperTarget = "OpenWebSDKWrapperTarget"

let frameworksChecksumMapper = [
    "RxSwift": "8dda0dd2c6ae8d86b8440c880f50e30c75950a7bff38fd83d7554c2d3abb758f",
    "RxCocoa": "4546710b488e4d4c1b4d0b292eb5ca90893da1203b45fddbfb2ba7c139368dba",
    "RxRelay": "40175e1abb021a5f6d580acf78ec3e553ebd9ee15b4ebe0201310fa2d355b828"
]

func createProducts() -> [Product] {
    let products: [Product] = [.library(name: owSDK, targets: [owSDKWrapperTarget]),
                               .library(name: owSDKCommon, targets: [owSDKWrapperTarget]),
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

    // Adding OpenWebCommon xcframework
    let OpenWebCommonSDK: Target = .binaryTarget(
        name: owSDKCommon,
        path: "\(owSDKCommon).xcframework"
    )
    targets.append(OpenWebCommonSDK)

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
            .target(name: "OpenWebCommon", condition: .when(platforms: .some([.iOS]))),
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
