// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BGFX",
    products: [
        .library(name: "BGFX", targets: ["BGFX"]),
        .library(name: "bgfxC", targets: ["bgfxC"]),
    ],
    targets: [
        .target(name: "BGFX", dependencies: ["bgfxC"]),
        bgfxTarget,
    ],
    swiftLanguageVersions: [.v5],
    cLanguageStandard: .gnu99,
    cxxLanguageStandard: .cxx14
)

var bgfxTarget: Target {
    var sources: [String] {
        return [
            "bx/src/allocator.cpp",
            "bx/src/bounds.cpp",
            "bx/src/bx.cpp",
            "bx/src/commandline.cpp",
            "bx/src/crtnone.cpp",
            "bx/src/debug.cpp",
            "bx/src/dtoa.cpp",
            "bx/src/easing.cpp",
            "bx/src/file.cpp",
            "bx/src/filepath.cpp",
            "bx/src/hash.cpp",
            "bx/src/math.cpp",
            "bx/src/mutex.cpp",
            "bx/src/os.cpp",
            "bx/src/process.cpp",
            "bx/src/semaphore.cpp",
            "bx/src/settings.cpp",
            "bx/src/sort.cpp",
            "bx/src/string.cpp",
            "bx/src/thread.cpp",
            "bx/src/timer.cpp",
            "bx/src/url.cpp",
            
            "bimg/3rdparty/astc-encoder/source/astcenc_averages_and_directions.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_block_sizes.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_color_quantize.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_color_unquantize.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_compress_symbolic.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_compute_variance.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_decompress_symbolic.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_diagnostic_trace.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_entry.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_find_best_partitioning.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_ideal_endpoints_and_weights.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_image.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_integer_sequence.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_mathlib.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_mathlib_softfloat.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_partition_tables.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_percentile_tables.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_pick_best_endpoint_format.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_platform_isa_detection.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_quantization.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_symbolic_physical.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_weight_align.cpp",
            "bimg/3rdparty/astc-encoder/source/astcenc_weight_quant_xfer_tables.cpp",
            "bimg/3rdparty/tinyexr/deps/miniz/miniz.c",
            "bimg/src/image.cpp",
            "bimg/src/image_gnf.cpp",
            
            "bgfx/src/bgfx.cpp",
            "bgfx/src/debug_renderdoc.cpp",
            "bgfx/src/dxgi.cpp",
            "bgfx/src/glcontext_eagl.mm",
            "bgfx/src/glcontext_egl.cpp",
            "bgfx/src/glcontext_glx.cpp",
            "bgfx/src/glcontext_html5.cpp",
            "bgfx/src/glcontext_nsgl.mm",
            "bgfx/src/glcontext_wgl.cpp",
            "bgfx/src/nvapi.cpp",
            "bgfx/src/renderer_agc.cpp",
            "bgfx/src/renderer_d3d11.cpp",
            "bgfx/src/renderer_d3d12.cpp",
            "bgfx/src/renderer_d3d9.cpp",
            "bgfx/src/renderer_gl.cpp",
            "bgfx/src/renderer_gnm.cpp",
            "bgfx/src/renderer_mtl.mm",
            "bgfx/src/renderer_noop.cpp",
            "bgfx/src/renderer_nvn.cpp",
            "bgfx/src/renderer_vk.cpp",
            "bgfx/src/renderer_webgpu.cpp",
            "bgfx/src/shader.cpp",
            "bgfx/src/shader_dx9bc.cpp",
            "bgfx/src/shader_dxbc.cpp",
            "bgfx/src/shader_spirv.cpp",
            "bgfx/src/topology.cpp",
            "bgfx/src/vertexlayout.cpp",
        ]
    }
    
    var exclude: [String] {
        return []
    }
    
    let cxxSettings: [CXXSetting] = [
        .define("__STDC_LIMIT_MACROS"),
        .define("__STDC_FORMAT_MACROS"),
        .define("__STDC_CONSTANT_MACROS"),
        .define("_DEBUG", .when(configuration: .debug)),
        .define("NDEBUG", .when(configuration: .release)),
        .define("BX_CONFIG_DEBUG", to: "1", .when(configuration: .debug)),
        .define("BX_CONFIG_DEBUG", to: "0", .when(configuration: .release)),
        
        .define("GL_SILENCE_DEPRECATION", .when(platforms: [.macOS, .iOS, .tvOS])),
        .define("BGFX_CONFIG_RENDERER_OPENGL", to: "1", .when(platforms: [.macOS])),
        .define("BGFX_CONFIG_RENDERER_METAL", to: "1", .when(platforms: [.macOS, .iOS, .tvOS])),
        .define("BGFX_CONFIG_RENDERER_DIRECT3D12", to: "1", .when(platforms: [.windows])),
        
        .headerSearchPath("bx/include/compat/osx", .when(platforms: [.macOS])),
        .headerSearchPath("bx/include/compat/linux", .when(platforms: [.linux])),
        .headerSearchPath("bx/include/compat/msvc", .when(platforms: [.windows])),
        .headerSearchPath("bx/include/compat/ios", .when(platforms: [.iOS, .tvOS, .macCatalyst])),
        .headerSearchPath("bx/include"),
        .headerSearchPath("bx/3rdparty"),
        
        .headerSearchPath("bimg/include"),
        .headerSearchPath("bimg/3rdparty/astc-encoder/include"),
        .headerSearchPath("bimg/3rdparty/tinyexr/deps/miniz"),
        
        .headerSearchPath("bgfx/3rdparty"),
        .headerSearchPath("bgfx/3rdparty/khronos"),
        .headerSearchPath("bgfx/include"),
                
        .unsafeFlags(["-fomit-frame-pointer", "-ffast-math"]),
//        .unsafeFlags(["-Wshadow", "-Wfatal-errors", "-Wunused-value", "-Wundef", "-Wall"]),
        .unsafeFlags(["-Wno-everything"]),

        .unsafeFlags(["-fno-objc-arc"], .when(platforms: [.macOS, .iOS, .tvOS, .macCatalyst])),
    ]
    
    let swiftSettings: [SwiftSetting] = [
        
    ]
    
    let linkerSettings: [LinkerSetting] = [
        // SR-14728
        .linkedLibrary("swiftCore", .when(platforms: [.windows])),
    ]

    return .target(name: "bgfxC",
                   exclude: exclude,
                   sources: sources,
                   cxxSettings: cxxSettings,
                   swiftSettings: swiftSettings,
                   linkerSettings: linkerSettings)
}
