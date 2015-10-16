/*
  Copyright © 2015 The App Business. All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE APP BUSINESS `AS IS' AND ANY EXPRESS OR
  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
  EVENT SHALL THE APP BUSINESS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#if os(iOS)
  import UIKit
#else
  import AppKit
#endif

/**
Defines an axis used for horizontal and vertical based constraints

- Horizontal: Defines a horizontal axis
- Vertical:   Defines a vertical axis
*/
enum Axis {
  case Horizontal
  case Vertical
}


/**
Defines an edge used for edge based constraints

- Top:    Defines a top edge
- Left:   Defines a left edge
- Bottom: Defines a bottom edge
- Right:  Defines a right edge
*/
enum Edge {
  case Top
  case Left
  case Bottom
  case Right
}

/**
*  Defines edge (bitmask) options for use in edge based constraints
*/
struct EdgeMask: OptionSetType {
  let rawValue: Int
  init(rawValue: Int) { self.rawValue = rawValue }
  
  /// Defines a top edge
  static var Top: EdgeMask   { return EdgeMask(rawValue: 1 << 0) }
  
  /// Defines a left edge
  static var Left: EdgeMask  { return EdgeMask(rawValue: 1 << 1) }
  
  /// Defines a bottom edge
  static var Bottom: EdgeMask   { return EdgeMask(rawValue: 1 << 2) }
  
  /// Defines a right edge
  static var Right: EdgeMask  { return EdgeMask(rawValue: 1 << 3) }
  
  /// Defines a left and right edge
  static var LeftAndRight: EdgeMask  { return Left.union(.Right) }
  
  /// Defines a top and bottom edge
  static var TopAndBottom: EdgeMask { return Top.union(.Bottom) }
  
  /// Defines all edges
  static var All: EdgeMask { return Left.union(.Right).union(.Top).union(.Bottom) }
}

/**
*  Defines edge margins for use in edge based constraints
*/
struct EdgeMargins {
  /// Defines a top edge marge
  var top: CGFloat
  
  /// Defines a left edge margin
  var left: CGFloat
  
  /// Defines a bottom edge margin
  var bottom: CGFloat
  
  /// Defines a right edge margin
  var right: CGFloat
  
  init() {
    self.init(all: 0)
  }
  
  /**
  Initializes an instance with all edge margins defined with the same value
  
  - parameter all: The margin for each edge
  
  - returns: An EdgeMargins instance with its edges defined equally
  */
  init(all: CGFloat) {
    self.init(top: all, left: all, bottom: all, right: all)
  }
  
  
  /**
  Initializes an instance with all edge margins defined
  
  - parameter top:    The top margin
  - parameter left:   The left margin
  - parameter bottom: The bottom margin
  - parameter right:  The right margin
  
  - returns: An EdgeMargins instance with its edges defined
  */
  init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
    self.top = top
    self.left = left
    self.bottom = bottom
    self.right = right
  }
}


/**
Converts an Axis to its associated sizing attribute

- parameter axis: The axis to convert

- returns: The associated NSLayoutAttribute
*/
func sizeAttribute(axis: Axis) -> NSLayoutAttribute {
  switch axis {
  case .Horizontal:
    return .Width
  case .Vertical:
    return .Height
  }
}

/**
Converts an Axis to its associated alignment attribute

- parameter axis: The axis to convert

- returns: The associated NSLayoutAttribute
*/
func centerAttribute(axis: Axis) -> NSLayoutAttribute {
  switch axis {
  case .Horizontal:
    return .CenterX
  case .Vertical:
    return .CenterY
  }
}

/**
Converts an Edge to its associated edge attribute

- parameter edge: The edge to convert

- returns: The associated NSLayoutAttribute
*/
func edgeAttribute(edge: Edge) -> NSLayoutAttribute {
  switch edge {
  case .Top:
    return .Top
  case .Left:
    return .Left
  case .Bottom:
    return .Bottom
  case .Right:
    return .Right
  }
}


