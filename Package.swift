// swift-tools-version:5.5
import PackageDescription

let vendorFrameworkshostingUrl = "https://github.com/SpotIM/openweb-ios-vendor-frameworks/tree/light-rx/Vendor-Frameworks/"
let owPrefix = ""
let owSDK = "OpenWebSDK"
let owSDKWrapperTarget = "OpenWebSDKWrapperTarget"

let frameworksChecksumMapper = [
    "\(owPrefix)RxSwift": "e6fc04e99fa4f07dfaa2076c8b2dbfc439f416cbf3c2ba62263ef7900c2a505d",
    "\(owPrefix)RxCocoa": "bad9176adcd17b818c6d100fe5169b282519e62753496d3b1833327e72945140",
    "\(owPrefix)RxRelay": "4ad480a9daa70ef8294e3676951783d940bed948b588dc12ed9ca323fedb6fc7"
//    "OneSignalUser": "6595a504ba8334b650444281cf354cecbabdf6ce2d6e7f34cf4dce9a999fe804"
]

func createProducts() -> [Product] {
    let products: [Product] = [.library(name: owSDK, targets: [owSDKWrapperTarget]),
                               .library(name: "\(owPrefix)RxSwift", targets: [owSDKWrapperTarget]),
                               .library(name: "\(owPrefix)RxCocoa", targets: [owSDKWrapperTarget]),
                               .library(name: "\(owPrefix)RxRelay", targets: [owSDKWrapperTarget])]
//                                .library(name: "OneSignalUser", targets: [owSDKWrapperTarget])]

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
            .target(name: "OpenWebSDK", condition: .when(platforms: .some([.iOS])))
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
    var url = "\(vendorFrameworkshostingUrl)\(framework).xcframework.zip"
    if framework == "OneSignalUser" {
        url = "https://github.com/OneSignal/OneSignal-iOS-SDK/releases/download/5.2.2/OneSignalUser.xcframework.zip"
    }
    return Target.binaryTarget(name: "\(framework)",
                               url: url,
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
