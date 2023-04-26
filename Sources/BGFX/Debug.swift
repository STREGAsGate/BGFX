/**
 * Copyright © 2023 Dustin Collins (Strega's Gate)
 * All Rights Reserved.
 *
 * http://stregasgate.com
 */

import bgfxC

public extension BGFX {
    enum Debug {}
}

public extension BGFX.Debug {
    struct Flags: OptionSet {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
        public static let ifh = Flags(rawValue: 0x00000002)
        /// Enable statistics display.
        public static let stats = Flags(rawValue: 0x00000004)
        /// Enable debug text display.
        public static let text = Flags(rawValue: 0x00000008)
        public static let profiler = Flags(rawValue: 0x00000010)
    }
    @inlinable
    static func setDebug(_ flags: Flags) {
        bgfx_set_debug(flags.rawValue)
    }
    
    /**
     Clear internal debug text buffer.
     - parameter backgroundColor: Background color.
     - parameter useSmallFont: Default 8x16 or 8x8 font.
     */
    @inlinable
    static func textClear(backgroundColor: UInt8 = 0, useSmallFont: Bool = false) {
        bgfx_dbg_text_clear(backgroundColor, useSmallFont)
    }
    
    enum DebugColor: UInt8 {
        case color0 = 0x0
        case color1 = 0x1
        case color2 = 0x2
        case color3 = 0x3
        case color4 = 0x4
        case color5 = 0x5
        case color6 = 0x6
        case color7 = 0x7
        case color8 = 0x8
        case color9 = 0x9
        case color10 = 0xA
        case color11 = 0xB
        case color12 = 0xC
        case color13 = 0xD
        case color14 = 0xE
        case color16 = 0xF
    }
    
    /**
     Print formatted data from variable argument list to internal debug text character-buffer (VGA-compatible text mode).
     - parameter x: Position x from the left corner of the window.
     - parameter y: Position y from the top corner of the window.
     - parameter backgroundColor: Color palette of background.
     - parameter textColor: Color palette of text.
     - parameter format: `printf` style format.
     - parameter args: Variable arguments list for format string.
     */
    @inlinable
    static func print(x: UInt16, y: UInt16, backgroundColor: DebugColor = .color0, textColor: DebugColor = .color16, _ format: String, _ args: CVarArg...) {
        format.withCString { string in
            withVaList(args) { pointer in
                bgfx_dbg_text_vprintf(x, y, textColor.rawValue + backgroundColor.rawValue << 4, string, pointer)
            }
        }
    }
}
