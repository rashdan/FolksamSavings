// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Saving",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Saving",
            targets: ["Saving"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "FolksamCommon",
                     url: "https://rashdan@bitbucket.org/folksamfuturelab/folksamcommon.git", .upToNextMajor(from: "0.1.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Saving",
            dependencies: [.product(name: "FolksamCommon", package: "FolksamCommon")]),
        .testTarget(
            name: "SavingTests",
            dependencies: ["Saving"]),
    ]
)
