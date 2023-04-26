/**
 * Copyright © 2023 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 *
 * http://stregasgate.com
 */

import bgfxC

public extension BGFX {
    typealias ViewID = bgfx_view_id_t
    typealias Memory = bgfx_memory_t
    typealias VertexBuffer = bgfx_vertex_buffer_handle_t
    typealias IndexBuffer = bgfx_index_buffer_handle_t
    
    typealias Shader = bgfx_shader_handle_t
    typealias Program = bgfx_program_handle_t
    
    typealias Texture = bgfx_texture_handle_t
    
    typealias Uniform = bgfx_uniform_handle_t
}

public struct DiscardFlags: OptionSet {
    public let rawValue: UInt8
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    /// Preserve everything.
    @available(*, unavailable, message: "Use `[]`.")
    public static let none = DiscardFlags([])
    /// Discard texture sampler and buffer bindings.
    public static let bindings = DiscardFlags(rawValue: 0x01)
    /// Discard index buffer.
    public static let indexBuffer = DiscardFlags(rawValue: 0x02)
    /// Discard instance data.
    public static let instanceData = DiscardFlags(rawValue: 0x04)
    /// Discard state and uniform bindings.
    public static let state = DiscardFlags(rawValue: 0x08)
    /// Discard transform.
    public static let transform = DiscardFlags(rawValue: 0x10)
    /// Discard vertex streams.
    public static let vertexStreams = DiscardFlags(rawValue: 0x20)
    /// Discard all states.
    public static let all = DiscardFlags(rawValue: 0xff)
}

public struct State: OptionSet {
    public var rawValue: UInt64
    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }
    
    /// No state.
    @available(*, unavailable, message: "Use `[]`.")
    public static let none = State([])
    /// Enable R write.
    public static let writeRed = State(rawValue: 0x0000000000000001)
    /// Enable G write.
    public static let writeGreen = State(rawValue: 0x0000000000000002)
    /// Enable B write.
    public static let writeBlue = State(rawValue: 0x0000000000000004)
    /// Enable alpha write.
    public static let writeAlpha = State(rawValue: 0x0000000000000008)
    /// Enable depth write.
    public static let writeDepth = State(rawValue: 0x0000004000000000)
    /// Enable RGB write.
    public static let writeRGB = State([.writeRed, .writeGreen, .writeBlue])
    /// Write all channels mask.
    public static let writeAll = State([.writeRGB, .writeAlpha, .writeDepth])
    

    /**
     * Depth test state. When `BGFX_STATE_DEPTH_` is not specified depth test will be disabled.
     *
     */
    public enum DepthTest: UInt64 {
        /// Enable depth test, less.
        case less = 0x0000000000000010
        /// Enable depth test, less or equal.
        case lessEqual = 0x0000000000000020
        /// Enable depth test, equal.
        case equal = 0x0000000000000030
        /// Enable depth test, greater or equal.
        case greaterEqual = 0x0000000000000040
        /// Enable depth test, greater.
        case greater = 0x0000000000000050
        /// Enable depth test, not equal.
        case notEqual = 0x0000000000000060
        /// Enable depth test, never.
        case never = 0x0000000000000070
        /// Enable depth test, always.
        case always = 0x0000000000000080
    }
    @inlinable
    public static func depthTest(_ test: DepthTest) -> State {
        return State(rawValue: test.rawValue)
    }

    public enum BlendFunction: UInt64 {
        /// 0, 0, 0, 0
        case zero = 0x0000000000001000
        /// 1, 1, 1, 1
        case one = 0x0000000000002000
        /// Rs, Gs, Bs, As
        case srcColor = 0x0000000000003000
        /// 1-Rs, 1-Gs, 1-Bs, 1-As
        case invSrcColor = 0x0000000000004000
        /// As, As, As, As
        case srcAlpha = 0x0000000000005000
        /// 1-As, 1-As, 1-As, 1-As
        case invSrcAlpha = 0x0000000000006000
        /// Ad, Ad, Ad, Ad
        case dstAlpha = 0x0000000000007000
        /// 1-Ad, 1-Ad, 1-Ad ,1-Ad
        case invDstAlpha = 0x0000000000008000
        /// Rd, Gd, Bd, Ad
        case dstColor = 0x0000000000009000
        /// 1-Rd, 1-Gd, 1-Bd, 1-Ad
        case invDstColor = 0x000000000000a000
        /// f, f, f, 1; f = min(As, 1-Ad)
        case srcAlphaSat = 0x000000000000b000
        /// Blend factor
        case factor = 0x000000000000c000
        /// 1-Blend factor
        case invFactor = 0x000000000000d000
    }
    /// Blend function separate.
    @inlinable
    public static func blendFunctionSeparate(srcRGB: BlendFunction, dstRGB: BlendFunction, srcA: BlendFunction, dstA: BlendFunction) -> State {
        let a = srcRGB.rawValue | (dstRGB.rawValue << 4)
        let b = (srcA.rawValue | (dstA.rawValue << 4)) << 8
        return State(rawValue: a | b)
    }
    /// Blend function.
    @inlinable
    public static func blendFunction(src: BlendFunction, dst: BlendFunction) -> State {
        return .blendFunctionSeparate(srcRGB: src, dstRGB: dst, srcA: src, dstA: dst)
    }
    
    public enum BlendEquation: UInt64 {
        /// Blend add: src + dst.
        case add = 0x0000000000000000
        /// Blend subtract: src - dst.
        case sub = 0x0000000010000000
        /// Blend reverse subtract: dst - src.
        case revSub = 0x0000000020000000
        /// Blend min: min(src, dst).
        case min = 0x0000000030000000
        /// Blend max: max(src, dst).
        case max = 0x0000000040000000
    }
    /// Blend equation separate.
    @inlinable
    public static func blendEquationSeperate(equationRGB: BlendEquation, equationA: BlendEquation) -> State {
        let a = equationRGB.rawValue | (equationA.rawValue << 3)
        return State(rawValue: a)
    }
    /// Blend equation.
    @inlinable
    public static func blendEquation(_ equation: BlendEquation) -> State {
        return .blendEquationSeperate(equationRGB: equation, equationA: equation)
    }

    public enum Winding: UInt64 {
        /// Cull clockwise triangles.
        case clockwise = 0x0000001000000000
        /// Cull counter-clockwise triangles.
        case counterClockwise = 0x0000002000000000
    }
    @inlinable
    public static func cull(_ winding: Winding) -> State {
        return State(rawValue: winding.rawValue)
    }

    /// Alpha reference value.
    @inlinable
    public static func alphaReference(_ v: UInt64) -> State {
        let shift: UInt64 = 40
        let mask: UInt64 = 0x0000ff0000000000
        return State(rawValue: (v << shift) & mask)
    }
    
    public enum PrimitiveType: UInt64 {
        /// Tristrip.
        case triangleStrip = 0x0001000000000000
        /// Lines.
        case lines = 0x0002000000000000
        /// Line strip.
        case lineStrip = 0x0003000000000000
        /// Points.
        case points = 0x0004000000000000
    }
    @inlinable
    public static func primitiveType(_ type: PrimitiveType) -> State {
        return State(rawValue: type.rawValue)
    }
    
    /// Point size value.
    @inlinable
    public static func pointSize(_ size: UInt64) -> State {
        let shift: UInt64 = 52
        let mask: UInt64 = 0x00f0000000000000
        return State(rawValue: (size << shift) & mask)
    }

    /**
     Enable MSAA write when writing into MSAA frame buffer.
     - note: This flag is ignored when not writing into MSAA frame buffer.
     */
    public static let msaa = State(rawValue: 0x0100000000000000)
    /// Enable line AA rasterization.
    public static let lineAntiAliasing = State(rawValue: 0x0200000000000000)
    /// Enable conservative rasterization.
    public static let conservativeRasterization = State(rawValue: 0x0400000000000000)
    /// Front counter-clockwise (default is clockwise).
    public static let frontCCW = State(rawValue: 0x0000008000000000)
    /// Enable blend independent.
    public static let blendIndependent = State(rawValue: 0x0000000400000000)
    /// Enable alpha to coverage.
    public static let alphaToCoverage = State(rawValue: 0x0000000800000000)
    
    /// Default state is write to RGB, alpha, and depth with depth test less enabled, with clockwise
    /// culling and MSAA (when writing into MSAA frame buffer, otherwise this flag is ignored).
    public static let `default` = State([.writeRGB, .writeAlpha, .writeDepth, .depthTest(.less), .cull(.clockwise), .msaa])
}
