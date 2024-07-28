// swift-tools-version:5.5
import PackageDescription

let vendorFrameworkshostingUrl = "https://github.com/SpotIM/openweb-ios-vendor-frameworks/tree/light-rx/Vendor-Frameworks/"
let owPrefix = ""
let owSDK = "OpenWebSDK"
let owSDKWrapperTarget = "OpenWebSDK" //OpenWebSDKWrapperTarget"

let frameworksChecksumMapper = [
    "\(owPrefix)RxSwift": "bede6697b9989995dfca5da7b93f28441fc8c6f823d982dd0bdcd87b2bbbf2ab",
    "\(owPrefix)RxCocoa": "715d27739955338e55369fbcd755946506c6a5e8ed349ad9c937d29d670f5d95",
    "\(owPrefix)RxRelay": "ff8e9c10cf8197ba52156346ed4f290a626aa3f2a707e5023a08b0f8eff165ff"
]

func createProducts() -> [Product] {
    let products: [Product] = [.library(name: owSDK, targets: ["OpenWebSDK"]),
                               .library(name: "\(owPrefix)RxSwift", targets: [owSDKWrapperTarget]),
                               .library(name: "\(owPrefix)RxCocoa", targets: [owSDKWrapperTarget]),
                               .library(name: "\(owPrefix)RxRelay", targets: [owSDKWrapperTarget])]

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

    return targets
}

func createRemoteTarget(framework: String, checksum: String = "") -> Target {
    var url: String = "\(vendorFrameworkshostingUrl)\(framework).xcframework.zip"

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
