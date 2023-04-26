/**
 * Copyright © 2023 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 *
 * http://stregasgate.com
 */

import bgfxC
#if canImport(GameMath)
import GameMath
#endif

public extension BGFX {
    struct Encoder {
        @usableFromInline
        let pointer: OpaquePointer
        @usableFromInline
        internal init(pointer: OpaquePointer) {
            self.pointer = pointer
        }
        
        /**
         Begin submitting draw calls from thread.
         - parameter forThread: Explicitly request an encoder for a worker thread.
         */
        public init(forWorkerThread forThread: Bool = false, name: String? = nil) {
            self.pointer = bgfx_encoder_begin(forThread)
        }
    }
}

public extension BGFX {
    /**
     Begin submitting draw calls from thread.
     - parameter forThread: Explicitly request an encoder for a worker thread.
     */
    @inlinable
    static func encoderBegin(forWorkerThread forThread: Bool = false) -> Encoder {
        return Encoder(pointer: bgfx_encoder_begin(forThread))
    }
}

public extension BGFX.Encoder {
    /**
     End submitting draw calls from thread.
     - parameter encoder: Encoder.
     */
    @inlinable
    func end() {
        bgfx_encoder_end(pointer)
    }
    
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
    func touch(viewID id: BGFX.ViewID) {
        bgfx_encoder_touch(pointer, id)
    }
    
    /**
     Set vertex buffer for draw primitive.
     - parameter stream: Vertex stream.
     - parameter buffer: Vertex buffer.
     - parameter first: First vertex to render.
     - parameter count: Number of vertices to render.
     */
    @inlinable
    func setVertexBuffer(_ buffer: BGFX.VertexBuffer, stream: UInt8, first: UInt32 = 0, count: UInt32 = .max) {
        bgfx_encoder_set_vertex_buffer(pointer, stream, buffer, first, count)
    }
    
    /**
     Set index buffer for draw primitive.
     - parameter buffer: Index buffer.
     - parameter first: First index to render.
     - parameter count: Number of indices to render.
     */
    @inlinable
    func setIndexBuffer(_ buffer: BGFX.IndexBuffer, first: UInt32 = 0, count: UInt32 = .max) {
        bgfx_encoder_set_index_buffer(pointer, buffer, first, count)
    }
    
    /**
     Submit primitive for rendering.
     - parameter viewID: View id.
     - parameter program: Program.
     - parameter depth: Depth for sorting.
     - parameter flags: Which states to discard for next draw. See `DiscardFlags`.
     */
    @inlinable
    func submit(viewID: BGFX.ViewID, program: BGFX.Program, depth: UInt32 = 0, discard flags: DiscardFlags) {
        bgfx_encoder_submit(pointer, viewID, program, depth, flags.rawValue)
    }
    
    /**
     Set model matrix for draw primitive. If it is not called, the model will be rendered with an identity model matrix.
     - parameter modelMatrix: Model matrix.
     */
    @inlinable @discardableResult
    func setTransform(viewID: BGFX.ViewID, modelMatrix: [Float]) -> UInt32 {
        return modelMatrix.withUnsafeBytes { model in
            return bgfx_encoder_set_transform(pointer, model.baseAddress, 1)
        }
    }
    
    @inlinable @discardableResult
    func setTransform(viewID: BGFX.ViewID, modelMatricies: [Float], count: UInt16) -> UInt32 {
        return modelMatricies.withUnsafeBytes { model in
            return bgfx_encoder_set_transform(pointer, model.baseAddress, count)
        }
    }
    
    /// Set render states for draw primitive.
    @inlinable
    func setState(_ state: State) {
        bgfx_encoder_set_state(pointer, state.rawValue, 0)
    }
    
    /// Sets a debug marker. This allows you to group graphics calls together for easy browsing in graphics debugging tools.
    @inlinable
    func setMarker(_ marker: String) {
        marker.withCString { cString in
            bgfx_encoder_set_marker(pointer, cString)
        }
    }
}

public extension BGFX.Encoder {
    func setTexture(_ stage: UInt8, _ texture: BGFX.Texture, sampler: BGFX.Uniform, flags: UInt32 = 0) {
        bgfx_encoder_set_texture(pointer, stage, sampler, texture, flags)
    }
}
