/**
 * Copyright © 2023 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 *
 * http://stregasgate.com
 */

import bgfxC
import struct Foundation.Data
#if canImport(GameMath)
import GameMath
#endif

public enum BGFX {}

public extension BGFX {
    typealias PlatformData = bgfx_platform_data_s
    typealias Framebuffer = bgfx_frame_buffer_handle_s
    @inlinable
    static func startup(_ config: (_ platformData: inout PlatformData)->()) {
        var pd = bgfx_platform_data_t()
        config(&pd)
        bgfx_set_platform_data(&pd)
        
        bgfx_render_frame(0)
        
        var bgfxInit = bgfx_init_t()
        bgfx_init_ctor(&bgfxInit)
        bgfxInit.platformData = pd
        
        bgfxInit.type = BGFX_RENDERER_TYPE_COUNT // Automatically choose a renderer.
        
        bgfxInit.resolution.reset = 0x00000080
        
        bgfx_init(&bgfxInit)
    }
    
    @inlinable
    static func shutdown() {
        bgfxC.bgfx_shutdown()
    }
    
    enum RendererType: UInt32 {
        case noRendering
        case acg
        case direct3D9
        case direct3D11
        case direct3D12
        case gnm
        case metal
        case nvm
        case openGLES
        case openGL
        case vulkan
        case webGPU
    }
    @inlinable
    static func rendererType() -> RendererType {
        let type = bgfx_get_renderer_type()
        return RendererType(rawValue: type.rawValue)!
    }
}

public extension BGFX {
    /**
     Set view rectangle. Draw primitive outside view will be clipped.
     - parameter id: View id.
     - parameter x: Position x from the left corner of the window.
     - parameter y: Position y from the top corner of the window.
     - parameter width: Width of view port region.
     - parameter height: Height of view port region.
     */
    @inlinable
    static func setViewRect(viewID: ViewID, x: UInt16, y: UInt16, width: UInt16, height: UInt16) {
        bgfx_set_view_rect(viewID, x, y, width, height)
    }
    
    @inlinable
    static func createFramebuffer(width: UInt16, height: UInt16, format: TextureFormat, flags: UInt64) -> Framebuffer {
        return bgfxC.bgfx_create_frame_buffer(width, height, bgfx_texture_format_t(rawValue: format.rawValue), flags)
    }
}

public extension BGFX {
    struct ResetFlags: OptionSet {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        /// Enable 2x MSAA.
        public static let msaaX2 = ResetFlags(rawValue: 0x00000010)
        /// Enable 4x MSAA.
        public static let msaaX4 = ResetFlags(rawValue: 0x00000020)
        /// Enable 8x MSAA.
        public static let msaaX8 = ResetFlags(rawValue: 0x00000030)
        /// Enable 16x MSAA.
        public static let msaaX16 = ResetFlags(rawValue: 0x00000040)
        /// No reset flags.
        @available(*, unavailable, message: "Use `[]`.")
        public static let none = ResetFlags([])
        /// Not supported yet.
        public static let fullscreen = ResetFlags(rawValue: 0x00000001)
        /// Enable V-Sync.
        public static let vsync = ResetFlags(rawValue: 0x00000080)
        /// Turn on/off max anisotropy.
        public static let maxAnisotropy = ResetFlags(rawValue: 0x00000100)
        /// Begin screen capture.
        public static let capture = ResetFlags(rawValue: 0x00000200)
        /// Flush rendering after submitting to GPU.
        public static let flushAfterRender = ResetFlags(rawValue: 0x00002000)
        /**
         * This flag specifies where flip occurs. Default behaviour is that flip occurs
         * before rendering new frame. This flag only has effect when `BGFX_CONFIG_MULTITHREADED=0`.
         */
        public static let flipAfterRender = ResetFlags(rawValue: 0x00004000)
        /// Enable sRGB backbuffer.
        public static let srgbBackbuffer = ResetFlags(rawValue: 0x00008000)
        /// Enable HDR10 rendering.
        public static let hdr10 = ResetFlags(rawValue: 0x00010000)
        /// Enable HiDPI rendering.
        public static let hiDPI = ResetFlags(rawValue: 0x00020000)
        /// Enable depth clamp.
        public static let depthClamp = ResetFlags(rawValue: 0x00040000)
        /// Suspend rendering.
        public static let suspend = ResetFlags(rawValue: 0x00080000)
        /// Transparent backbuffer. Availability depends on: `BGFX_CAPS_TRANSPARENT_BACKBUFFER`.
        public static let transparentBackbuffer = ResetFlags(rawValue: 0x00100000)
    }
    enum TextureFormat: UInt32 {
        /// DXT1 R5G6B5A1
        case bc1
        /// DXT3 R5G6B5A4
        case bc2
        /// DXT5 R5G6B5A8
        case bc3
        /// LATC1/ATI1 R8
        case bc4
        /// LATC2/ATI2 RG8
        case bc5
        /// BC6H RGB16F
        case bc6h
        /// BC7 RGB 4-7 bits per color channel, 0-8 bits alpha
        case bc7
        /// ETC1 RGB8
        case etc1
        /// ETC2 RGB8
        case etc2
        /// ETC2 RGBA8
        case etc2a
        /// ETC2 RGB8A1
        case etc2a1
        /// PVRTC1 RGB 2BPP
        case ptc12
        /// PVRTC1 RGB 4BPP
        case ptc14
        /// PVRTC1 RGBA 2BPP
        case ptc12a
        /// PVRTC1 RGBA 4BPP
        case ptc14a
        /// PVRTC2 RGBA 2BPP
        case ptc22
        /// PVRTC2 RGBA 4BPP
        case ptc24
        /// ATC RGB 4BPP
        case atc
        /// ATCE RGBA 8 BPP explicit alpha
        case atce
        /// ATCI RGBA 8 BPP interpolated alpha
        case atci
        /// ASTC 4x4 8.0 BPP
        case astc4X4
        /// ASTC 5x4 6.40 BPP
        case astc5X4
        /// ASTC 5x5 5.12 BPP
        case astc5X5
        /// ASTC 6x5 4.27 BPP
        case astc6X5
        /// ASTC 6x6 3.56 BPP
        case astc6X6
        /// ASTC 8x5 3.20 BPP
        case astc8X5
        /// ASTC 8x6 2.67 BPP
        case astc8X6
        /// ASTC 8x8 2.00 BPP
        case astc8X8
        /// ASTC 10x5 2.56 BPP
        case astc10X5
        /// ASTC 10x6 2.13 BPP
        case astc10X6
        /// ASTC 10x8 1.60 BPP
        case astc10X8
        /// ASTC 10x10 1.28 BPP
        case astc10X10
        /// ASTC 12x10 1.07 BPP
        case astc12X10
        /// ASTC 12x12 0.89 BPP
        case astc12X12
        //Compressed formats above.
        case unknown
        case r1
        case a8
        case r8
        case r8i
        case r8u
        case r8s
        case r16
        case r16i
        case r16u
        case r16f
        case r16s
        case r32i
        case r32u
        case r32f
        case rg8
        case rg8i
        case rg8u
        case rg8s
        case rg16
        case rg16i
        case rg16u
        case rg16f
        case rg16s
        case rg32i
        case rg32u
        case rg32f
        case rgb8
        case rgb8i
        case rgb8u
        case rgb8s
        case rgb9e5f
        case bgra8
        case rgba8
        case rgba8i
        case rgba8u
        case rgba8s
        case rgba16
        case rgba16i
        case rgba16u
        case rgba16f
        case rgba16s
        case rgba32i
        case rgba32u
        case rgba32f
        case b5g6r5
        case r5g6b5
        case bgra4
        case rgba4
        case bgr5a1
        case rgb5a1
        case rgb10a2
        case rg11b10f
        // Depth formats below
        case unknownDepth
        case depth16
        case depth24
        case depth24Stencil8
        case depth32
        case depth16Float
        case depth24Float
        case depth32Float
        case depth0Stencil8
        
        case _count
    }
    
    /**
     Reset graphic settings and back-buffer size.
     - parameter width: Back-buffer width.
     - parameter height: Back-buffer height.
     - parameter flags: See: `ResetFlags` for more info.
     - parameter format: Texture format. See: `TextureFormat`.
     - note: This call doesn’t change the window size, it just resizes
     the back-buffer. Your windowing code controls the window size.
     */
    @inlinable
    static func reset(width: UInt32, height: UInt32, flags: ResetFlags, format: TextureFormat) {
#if DEBUG
        assert(TextureFormat._count.rawValue == 96, "TextureFormat is no longer a valid enum. Update from bgfx source.")
#endif
        bgfx_reset(width, height, flags.rawValue, bgfx_texture_format(rawValue: format.rawValue))
    }
}

public extension BGFX {
    struct ClearFlags: OptionSet {
        public let rawValue: UInt16
        public init(rawValue: UInt16) {
            self.rawValue = rawValue
        }
        /// No clear flags.
        @available(*, unavailable, message: "Use `[]`.")
        public static let none = ClearFlags([])
        /// Clear color.
        public static let color = ClearFlags(rawValue: 0x0001)
        /// Clear depth.
        public static let depth = ClearFlags(rawValue: 0x0002)
        /// Clear stencil.
        public static let stencil = ClearFlags(rawValue: 0x0004)
        /// Discard frame buffer attachment 0.
        public static let discardColor0 = ClearFlags(rawValue: 0x0008)
        /// Discard frame buffer attachment 1.
        public static let discardColor1 = ClearFlags(rawValue: 0x0010)
        /// Discard frame buffer attachment 2.
        public static let discardColor2 = ClearFlags(rawValue: 0x0020)
        /// Discard frame buffer attachment 3.
        public static let discardColor3 = ClearFlags(rawValue: 0x0040)
        /// Discard frame buffer attachment 4.
        public static let discardColor4 = ClearFlags(rawValue: 0x0080)
        /// Discard frame buffer attachment 5.
        public static let discardColor5 = ClearFlags(rawValue: 0x0100)
        /// Discard frame buffer attachment 6.
        public static let discardColor6 = ClearFlags(rawValue: 0x0200)
        /// Discard frame buffer attachment 7.
        public static let discardColor7 = ClearFlags(rawValue: 0x0400)
        /// Discard frame buffer depth attachment.
        public static let discardDepth = ClearFlags(rawValue: 0x0800)
        /// Discard frame buffer stencil attachment.
        public static let discardStencil = ClearFlags(rawValue: 0x1000)
    }
    /**
     Set view clear flags.
     - parameter id: View id.
     - parameter flags: Clear flags. Use `[]` to remove any clear
     - parameter color: Color clear value.
     - parameter depth: Depth clear value.
     - parameter stencil: Stencil clear value.
     */
    @inlinable
    static func setViewClear(id: ViewID, flags: ClearFlags, color: UInt32, depth: Float, stencil: UInt8) {
        bgfx_set_view_clear(0, flags.rawValue, color, depth, stencil)
    }
}

public extension BGFX {
    /**
     Advance to next frame. When using multithreaded renderer, this call
     just swaps internal buffers, kicks render thread, and returns. In
     singlethreaded renderer this call does frame rendering.
     - parameter capture: Capture frame with graphics debugger.
     - returns: The frame number.
     */
    @inlinable @discardableResult
    static func frame(capture: Bool = false) -> UInt32 {
        return bgfx_frame(capture)
    }

}

public extension BGFX {

}

public extension BGFX {
    /// Vertex attribute enum.
    enum VertexAttribute: UInt32 {
        case position
        case normal
        case tangent
        case bitangent
        case color0
        case color1
        case color2
        case color3
        case indices
        case weight
        case textureCoord0
        case textureCoord1
        case textureCoord2
        case textureCoord3
        case textureCoord4
        case textureCoord5
        case textureCoord6
        case textureCoord7
        
        case _count
    }
    
    /// Vertex attribute type enum.
    enum VertexAttributeType: UInt32 {
        case uint8
        /// Uint10, availability depends on: `BGFX_CAPS_VERTEX_ATTRIB_UINT10`.
        case uint10
        case int16
        /// Half, availability depends on: `BGFX_CAPS_VERTEX_ATTRIB_HALF`.
        case half
        case float
        
        case _count
    }
    
    struct VertexLayout {
        @usableFromInline
        var layout: bgfx_vertex_layout_t
        @inlinable
        public init() {
            layout = bgfx_vertex_layout_t()
#if DEBUG
        assert(VertexAttribute._count.rawValue == 18 && VertexAttributeType._count.rawValue == 5, "Enum is no longer valid. Update from bgfx source.")
#endif
        }
        
        @inlinable
        public mutating func begin() {
            bgfx_vertex_layout_begin(&layout, BGFX_RENDERER_TYPE_COUNT)
        }
        
        /**
         Add attribute to VertexLayout.
         - parameter attribute: See: `VertexAttribute`
         - parameter count: Number of elements 1, 2, 3 or 4.
         - parameter type: Element type.
         - parameter normalized: When using fixed point AttribType (f.e. Uint8) value will be normalized for vertex shader usage. When normalized is set to true, AttribType::Uint8 value in range 0-255 will be in range 0.0-1.0 in vertex shader.
         - parameter asInt: Packaging rule for vertexPack, vertexUnpack, and vertexConvert for AttribType::Uint8 and AttribType::Int16. Unpacking code must be implemented inside vertex shader.
         - note: Must be called between begin/end.
         */
        @inlinable
        public mutating func add(attribute: VertexAttribute, count: UInt8, type: VertexAttributeType, normalized: Bool, asInt: Bool = false) {
            bgfx_vertex_layout_add(&layout, bgfx_attrib_t(rawValue: attribute.rawValue), count, bgfx_attrib_type_t(rawValue: type.rawValue), normalized, asInt)
        }
        
        @inlinable
        public mutating func end() {
            bgfx_vertex_layout_end(&layout)
        }
    }
}

public extension BGFX {
//    @inlinable
//    static func makeRef<T>(_ data: Array<T>) -> UnsafePointer<Memory>! {
//        return data.withUnsafeBytes { buffer in
//            return bgfx_copy(buffer.baseAddress, UInt32(data.count))
////            return bgfx_make_ref(buffer.baseAddress, )
//        }
//    }
    
    @inlinable
    static func copy(_ data: Array<UInt8>) -> UnsafePointer<Memory>! {
        return data.withUnsafeBytes { buffer in
            return bgfx_copy(buffer.baseAddress, UInt32(buffer.count))
        }
    }
    
    @inlinable
    static func makeRef(_ pointer: UnsafeRawPointer, count: Int) -> UnsafePointer<Memory>! {
        return bgfx_make_ref(pointer, UInt32(count))
    }
    
    struct VertexBufferFlags: OptionSet {
        public var rawValue: UInt16
        public init(rawValue: UInt16) {
            self.rawValue = rawValue
        }
        
        /// No flags.
        @available(*, unavailable, message: "Use `[]`.")
        public static let none = VertexBufferFlags([])
        /// Buffer will be read from by compute shader.
        public static let computeRead = VertexBufferFlags(rawValue: 0x0100)
        ///  Buffer will be written into by compute shader. When buffer
        public static let computeWrite = VertexBufferFlags(rawValue: 0x0200)
        /// Buffer will be used for storing draw indirect commands.
        public static let drawIndirect = VertexBufferFlags(rawValue: 0x0400)
        /// Buffer will resize on buffer update if a different amount of data is passed. If this flag is not specified,
        /// and more data is passed on update, the buffer will be trimmed to fit the existing buffer size.
        /// This flag has effect only on dynamic buffers.
        public static let allowResize = VertexBufferFlags(rawValue: 0x0800)
        /// Buffer is using 32-bit indices. This flag has effect only on index buffers.
        public static let index32 = VertexBufferFlags(rawValue: 0x1000)
        /// Buffer will be used for read/write by compute shader.
        public static let computeReadWrite = VertexBufferFlags(rawValue: 0x0300)
    }

    /**
     Create static vertex buffer.
     - parameter memory: Vertex buffer data.
     - parameter layout: Vertex layout.
     - parameter flags: Buffer creation flags.
     */
    @inlinable
    static func createVertexBuffer<T>(data: [T], layout: VertexLayout, flags: VertexBufferFlags = []) -> VertexBuffer {
        return data.withUnsafeBytes { buffer in
            var layout = layout.layout
            let memory = bgfx_copy(buffer.baseAddress, UInt32(buffer.count))
            return bgfx_create_vertex_buffer(memory, &layout, flags.rawValue)
        }
    }
    
    /**
     Create static index buffer.
     - parameter memory: Index buffer data.
     - parameter flags: Buffer creation flags.
     */
    @inlinable
    static func createIndexBuffer<T>(data: [T], flags: VertexBufferFlags = []) -> IndexBuffer {
        return data.withUnsafeBytes { buffer in
            let memory = bgfx_copy(buffer.baseAddress, UInt32(buffer.count))
            return bgfx_create_index_buffer(memory, flags.rawValue)
        }
    }
    
    /// Set view’s view matrix and projection matrix, all draw primitives in this view will use these two matrices.
    @inlinable
    static func setViewTransform(viewID: ViewID, viewMatrix: [Float], projectionMatrix: [Float]) {
        viewMatrix.withUnsafeBytes { view in
            projectionMatrix.withUnsafeBytes { projection in
                bgfx_set_view_transform(viewID, view.baseAddress, projection.baseAddress)
            }
        }
    }

    /**
     Set model matrix for draw primitive. If it is not called, the model will be rendered with an identity model matrix.
     - parameter modelMatricies: Array of matricies.
     */
    @inlinable @discardableResult
    static func setTransform(viewID: ViewID, modelMatricies: [[Float]]) -> UInt32 {
        return modelMatricies.withUnsafeBytes { model in
            return bgfx_set_transform(model.baseAddress, UInt16(modelMatricies.count))
        }
    }
    
    #if canImport(GameMath)
    @inlinable
    static func setViewTransform(viewID: ViewID, viewMatrix: Matrix4x4, projectionMatrix: Matrix4x4) {
        self.setViewTransform(viewID: viewID, viewMatrix: viewMatrix.transposedArray(), projectionMatrix: projectionMatrix.transposedArray())
    }
    
    @inlinable @discardableResult
    static func setTransform(viewID: ViewID, modelMatricies: [Matrix4x4]) -> UInt32 {
        self.setTransform(viewID: viewID, modelMatricies: modelMatricies.map({$0.transposedArray()}))
    }
    
    @inlinable @discardableResult
    static func setTransform(viewID: ViewID, modelMatrix: Matrix4x4) -> UInt32 {
        self.setTransform(viewID: viewID, modelMatrix: modelMatrix.transposedArray())
    }
    #endif
}

public extension BGFX {
    @inlinable
    static func createShader(_ memory: UnsafePointer<Memory>!) -> Shader {
        return bgfx_create_shader(memory)
    }
    
    @inlinable
    static func createShader(_ data: [UInt8]) -> Shader {
        let mem = copy(data)
        return bgfx_create_shader(mem)
    }
    
    /**
     Create program with vertex and fragment shaders.
     - parameter vertex: Vertex shader.
     - parameter fragment: Fragment shader.
     - parameter destroyShaders: If true, shaders will be destroyed when program is destroyed.
     */
    @inlinable
    static func createProgram(vertex: Shader, fragment: Shader, destroyShaders: Bool) -> Program {
        return bgfx_create_program(vertex, fragment, destroyShaders)
    }
    
    /**
     Create program with vertex and fragment shaders.
     - parameter vertex: Vertex shader.
     - parameter fragment: Fragment shader.
     - parameter destroyShaders: If true, shaders will be destroyed when program is destroyed.
     */
    @inlinable
    static func createProgram(vertex: [UInt8], fragment: [UInt8]) -> Program {
        let vMem = copy(vertex)
        let vsh = createShader(vMem)
        let fMem = copy(fragment)
        let fsh = createShader(fMem)
        return bgfx_create_program(vsh, fsh, true)
    }
}

public extension BGFX {
    /**
     Submit an empty primitive for rendering. Uniforms and draw state
     will be applied but no geometry will be submitted. Useful in cases
     when no other draw/compute primitive is submitted to view, but it's
     desired to execute clear view.
     - note: These empty draw calls will sort before ordinary draw calls.
     - parameter viewID: View id.
     - parameter encoder: The encoder.
     */
    @inlinable
    static func touch(viewID id: BGFX.ViewID) {
        bgfx_touch(id)
    }
    
    /**
     Set vertex buffer for draw primitive.
     - parameter stream: Vertex stream.
     - parameter buffer: Vertex buffer.
     - parameter startVertex: First vertex to render.
     - parameter numVertices: Number of vertices to render.
     */
    @inlinable
    static func setVertexBuffer(_ buffer: VertexBuffer, stream: UInt8, first: UInt32 = 0, count: UInt32 = .max) {
        bgfx_set_vertex_buffer(stream, buffer, first, count)
    }
    
    /**
     Set index buffer for draw primitive.
     - parameter buffer: Index buffer.
     - parameter firstIndex: First index to render.
     - parameter indiciesCount: Number of indices to render.
     */
    @inlinable
    static func setIndexBuffer(_ buffer: IndexBuffer, first: UInt32 = 0, count: UInt32 = .max) {
        bgfx_set_index_buffer(buffer, first, count)
    }
    
    /**
     Set model matrix for draw primitive. If it is not called, the model will be rendered with an identity model matrix.
     - parameter modelMatrix: Model matrix.
     */
    @inlinable @discardableResult
    static func setTransform(viewID: ViewID, modelMatrix: [Float]) -> UInt32 {
        return modelMatrix.withUnsafeBytes { model in
            return bgfx_set_transform(model.baseAddress, 1)
        }
    }
    
    @inlinable
    static func setState(_ state: State) {
        bgfx_set_state(state.rawValue, 0)
    }
    
    /**
     Submit primitive for rendering.
     - parameter viewID: View id.
     - parameter program: Program.
     - parameter depth: Depth for sorting.
     - parameter flags: Which states to discard for next draw. See `DiscardFlags`.
     */
    @inlinable
    static func submit(viewID: ViewID, program: Program, depth: UInt32 = 0, discard flags: DiscardFlags) {
        bgfx_submit(viewID, program, depth, flags.rawValue)
    }
}

public extension BGFX {
    @inlinable
    static func createTexture(width: UInt16, height: UInt16, hasMips: Bool, numMipsLayers: Int, format: TextureFormat, flags: UInt64, data: Array<UInt8>) -> Texture {
        return data.withUnsafeBytes { pointer -> bgfx_texture_handle_t in
            let ref = makeRef(pointer.baseAddress!, count: data.count)
            let cap = bgfx_get_caps()!.pointee.limits.maxTextureLayers
            let layerCount = UInt16(min(cap, UInt32(clamping: numMipsLayers)))
            return bgfx_create_texture_2d(width, height, hasMips, layerCount, bgfx_texture_format_t(rawValue: format.rawValue), flags, ref)
        }
    }
    
    @inlinable
    static func destroyTexture(_ texture: Texture) {
        bgfx_destroy_texture(texture)
    }
    
    enum UniformType: UInt32 {
        case sampler
        case _reserved
        case vec4
        case mat3
        case mat4
    }
    @inlinable
    static func createUniform(_ name: String, type: UniformType, num: UInt16 = 0) -> Uniform {
        return name.withCString { cString in
            return bgfx_create_uniform(cString, bgfx_uniform_type_t(rawValue: type.rawValue), num)
        }
    }
}
