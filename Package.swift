// swift-tools-version:5.5
import PackageDescription

let vendorFrameworkshostingUrl = "https://github.com/SpotIM/openweb-ios-vendor-frameworks/tree/light-rx/Vendor-Frameworks/"
let owSDK = "OpenWebSDK"
let owSDKWrapperTarget = "OpenWebSDKWrapperTarget"

let frameworksChecksumMapper = [
    "RxSwift": "e6fc04e99fa4f07dfaa2076c8b2dbfc439f416cbf3c2ba62263ef7900c2a505d",
    "RxCocoa": "bad9176adcd17b818c6d100fe5169b282519e62753496d3b1833327e72945140",
    "RxRelay": "4ad480a9daa70ef8294e3676951783d940bed948b588dc12ed9ca323fedb6fc7"
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

    let rxSwift: Target = .binaryTarget(
        name: "RxSwift",
        path: "RxSwift.xcframework"
    )
    targets.append(rxSwift)

    let rxCocoa: Target = .binaryTarget(
        name: "RxCocoa",
        path: "RxCocoa.xcframework"
    )
    targets.append(rxCocoa)

    let rxRelay: Target = .binaryTarget(
        name: "RxRelay",
        path: "RxRelay.xcframework"
    )
    targets.append(rxRelay)

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


//    // Adding remote vendors xcframework(s)
//    let remoteTargets = frameworksChecksumMapper.flatMap { framework, checksum -> [Target] in
//        return [createRemoteTarget(framework: framework, checksum: checksum)]
//    }
//    targets.append(contentsOf: remoteTargets)

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
