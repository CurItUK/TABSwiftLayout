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


// MARK: - Extends UI/NS View to provide better support for programmatic constraints
public extension View {
  
  
  /**
  Resests all constraints for this view (similar to Xcode)
  */
  func resetConstraints() {
    removeConstraints(constraints)
  }
  
  /**
  Resets all constraints for this views subviews (similar to Xcode)
  */
  func resetSubViewConstraints() {
    for constraint: NSLayoutConstraint in self.constraints {
      let item = constraint.firstItem as? View
      if item != self {
        removeConstraint(constraint)
      }
    }
  }
  
  /**
  Pins the edges of 2 associated views
  
  - parameter edges:  The edges (bitmask) to pin
  - parameter view:   The second view to pin to
  - parameter margins: The margins to apply for each applicable edge
  
  - returns: The constaints that were added to this view
  */
  public func pin(edges: EdgeMask, toView view: View, margins: EdgeMargins) -> [NSLayoutConstraint] {
    var constraints = [NSLayoutConstraint]()
    
    if edges.contains(.Top) {
      constraints.append(pin(.Top, toEdge: .Top, ofView: view, margin: margins.top))
    }
    
    if edges.contains(.Bottom) {
      constraints.append(pin(.Bottom, toEdge: .Bottom, ofView: view, margin: margins.bottom))
    }
    
    if edges.contains(.Left) {
      constraints.append(pin(.Left, toEdge: .Left, ofView: view, margin: margins.left))
    }
    
    if edges.contains(.Right) {
      constraints.append(pin(.Right, toEdge: .Right, ofView: view, margin: margins.right))
    }
    
    return constraints
  }
  
  
  /**
  Pins a single edge to another views edge
  
  - parameter edge:   The edge of this view to pin
  - parameter toEdge: The edge of the second view to pin
  - parameter view:   The second view to pin to
  - parameter margin: The margin to apply to this constraint
  
  - returns: The constraint that was added
  */
  func pin(edge: Edge, toEdge: Edge, ofView view: View, margin: CGFloat) -> NSLayoutConstraint {
    var constraint = Constraint(view: self)
    
    constraint.secondView = view
    constraint.firstAttribute = edgeAttribute(edge)
    constraint.secondAttribute = edgeAttribute(toEdge)
    constraint.constant = edge == .Right || toEdge == .Right || edge == .Bottom || toEdge == .Bottom ? -1 * margin : margin
    
    let layoutConstraint = constraint.constraint()
    NSLayoutConstraint.activateConstraints([layoutConstraint])
    return layoutConstraint
  }
  
  /**
  Aligns this views center to another view
  
  - parameter axis:   The axis to align
  - parameter view:   The second view to align to
  - parameter offset: The offset to apply to this alignment
  
  - returns: The constraint that was added
  */
  public func center(axis: Axis, relativeTo view: View, offset: CGFloat) -> NSLayoutConstraint {
    var constraint = Constraint(view: self)
    
    constraint.secondView = view
    constraint.firstAttribute = centerAttribute(axis)
    constraint.secondAttribute = centerAttribute(axis)
    constraint.constant = offset
    
    let layoutConstraint = constraint.constraint()
    NSLayoutConstraint.activateConstraints([layoutConstraint])
    return layoutConstraint
  }
  
  /**
  Sizes the specified views proportionally to this view
  
  - parameter axis:  The axis to size
  - parameter views: The views to size
  - parameter ratio: The ratio to apply to this sizing (e.g. 0.5 would size the second view by 50% of this view's edge)
  
  - returns: The constraint that was added
  */
  func size(axis: Axis, ofViews views: [View], ratio: CGFloat) -> [NSLayoutConstraint] {
    var constraints = [NSLayoutConstraint]()
    
    for view: View in views {
      constraints.append(view.size(axis, relativeTo: axis, ofView: self, ratio: ratio))
    }
    
    return constraints
  }

  /**
  Sizes this view
  
  - parameter axis:     The axis to size
  - parameter relation: The relation for this sizing, equal, greaterThanOrEqual, lessThanOrEqual
  - parameter size:     The size to set
  
  - returns: The constraint that was added
  */
  func size(axis: Axis, relatedBy relation: NSLayoutRelation, size: CGFloat) -> NSLayoutConstraint {
    var constraint = Constraint(view: self)
    
    constraint.firstAttribute = sizeAttribute(axis)
    constraint.secondAttribute = sizeAttribute(axis)
    constraint.relation = relation
    constraint.constant = size
    
    let layoutConstraint = constraint.constraint()
    NSLayoutConstraint.activateConstraints([layoutConstraint])
    return layoutConstraint
  }
  
  /**
  Sizes this view's axis relative to another view axis. Note: The axis for each view doesn't have to be the same
  
  - parameter axis:      The axis to size
  - parameter otherAxis: The other axis to use for sizing
  - parameter view:      The second view to reference
  - parameter ratio:     The ratio to apply to this sizing. (e.g. 0.5 would size this view by 50% of the second view's edge)
  
  - returns: The constraint that was added
  */
  func size(axis: Axis, relativeTo otherAxis: Axis, ofView view: View, ratio: CGFloat) -> NSLayoutConstraint {
    var constraint = Constraint(view: self)
    
    constraint.secondView = view
    constraint.firstAttribute = sizeAttribute(axis)
    constraint.secondAttribute = sizeAttribute(otherAxis)
    constraint.multiplier = ratio
    
    let layoutConstraint = constraint.constraint()
    NSLayoutConstraint.activateConstraints([layoutConstraint])
    return layoutConstraint
  }
  
}


// MARK: - Extends UI/NS View with some additional convenience methods
extension View {
  
  
  /**
  Aligns the top edge of this view to the top of the specified view
  
  - parameter view: The reference view to align to
  
  - returns: The constraint that was added
  */
  func alignTop(toView view: View) -> NSLayoutConstraint {
    return pin(.Top, toEdge: .Top, ofView: view, margin: frame.minY)
  }
  
  /**
  Aligns the top edge of this view to the top of the specified view
  
  - parameter view: The reference view to align to
  
  - returns: The constraint that was added
  */
  func alignLeft(toView view: View) -> NSLayoutConstraint {
    return pin(.Left, toEdge: .Left, ofView: view, margin: frame.minX)
  }
  
  /**
  Aligns the top edge of this view to the top of the specified view
  
  - parameter view: The reference view to align to
  
  - returns: The constraint that was added
  */
  func alignBottom(toView view: View) -> NSLayoutConstraint {
    return pin(.Bottom, toEdge: .Bottom, ofView: view, margin: view.bounds.maxY - frame.maxY)
  }
  
  /**
  Aligns the top edge of this view to the top of the specified view
  
  - parameter view: The reference view to align to
  
  - returns: The constraint that was added
  */
  func alignRight(toView view: View) -> NSLayoutConstraint {
    return pin(.Right, toEdge: .Right, ofView: view, margin: view.bounds.maxX - frame.maxX)
  }
  
  /**
  Aligns the view horizontally to the specified view
  
  - parameter view: The view to align to
  
  - returns: The constraint that was added
  */
  func centerHorizontally(toView view: View) -> NSLayoutConstraint {
    return center(.Horizontal, relativeTo: view, offset: 0)
  }
  
  /**
  Aligns the view vertically to the specified view
  
  - parameter view: The view to align to
  
  - returns: The constraint that was added
  */
  func centerVertically(toView view: View) -> NSLayoutConstraint {
    return center(.Vertical, relativeTo: view, offset: 0)
  }
  
}

