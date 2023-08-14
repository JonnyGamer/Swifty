//
//  PolygonMesh.swift
//  SpriterKit
//
//  Created by Jonathan Pappas on 5/23/22.
//

import SpriteKit

extension Array {
    func modSub(_ mod: Int) -> Element {
        if mod > 0 { return self[mod % count] }
        return self[((mod % count) + count) % count]
    }
}

public extension SKShapeNode {
    convenience init (p: [CGPoint]) {
        var w = p
        assert(!p.isEmpty)
        if p.first != p.last {
            w.append(p[0])
        }
        self.init(points: &w, count: w.count)
    }
}

extension Polygon {
    func concavePhysicsBody() -> SKPhysicsBody {
        var n: [SKPhysicsBody] = []
        for i in concavePolygons() {
            n.append(SKPhysicsBody.init(polygonFrom: i.shape().path!))
        }
        return SKPhysicsBody.init(bodies: n)
    }
}

struct Polygon {
    var numberOfPoints: Int
    var points: [CGPoint] = []
    var frame: (minX: CGFloat, minY: CGFloat, maxX: CGFloat, maxY: CGFloat)
    init(_ points: [CGPoint]) {
        self.points = points.convertToClockwise()
        self.frame = points.frame()
        self.numberOfPoints = points.count
    }
    private init(safe: [CGPoint]) {
        self.points = safe
        self.frame = points.frame()
        self.numberOfPoints = points.count
    }
    func shape() -> SKShapeNode {
        return SKShapeNode.init(p: points)
    }
    func concavePolygons() -> [Polygon] {
        return points.convertToConcave().map({ Polygon(safe: $0) })
    }
    func point(i: Int) -> CGPoint {
        return points[((i % numberOfPoints) + numberOfPoints) % numberOfPoints]
    }
    
    var passThrough: [Int] = []
}

struct PolygonMesh {
    var polygons: [Polygon] = []
    init(_ _polygons: [Polygon]) {
        self.polygons = _polygons.reduce([Polygon]()) { $0 + $1.concavePolygons() }
        
        for (i, polygon1) in polygons.enumerated() {
            for (j, polygon2) in polygons.enumerated() {
                if i == j { continue }
                
                let (matches, indicesToSkip) = polygon1.points.matchingIndicesInARow(polygon2.points)
                if matches {
                    if connectedTo[i] == nil { connectedTo[i] = [] }
                    connectedTo[i]?.append(j)
                    if skipIndex[i] == nil { skipIndex[i] = [:] }
                    skipIndex[i]?[indicesToSkip] = j
                    self.polygons[i].passThrough.append(indicesToSkip)
                }
            }
        }
        
        print(connectedTo)
    }
    
    var shapes: [SKShapeNode] = []
    var connectedTo: [Int: [Int]] = [:]
    var skipIndex: [Int: [Int: Int]] = [:]
    
}



func minn<T: Comparable>(_ lhs: T?,_ rhs: T) -> T {
    if let l = lhs { return Swift.min(l, rhs) }
    return rhs
}
func maxx<T: Comparable>(_ lhs: T?,_ rhs: T) -> T {
    if let l = lhs { return Swift.max(l, rhs) }
    return rhs
}

extension Array where Element == CGPoint {
    func convertToClockwise() -> Self {
        var area: CGFloat = 0;
        for i in 0..<count {
            let j = (i + 1) % count;
            area += self[i].x * self[j].y;
            area -= self[j].x * self[i].y;
        }
        return (area / 2) > 0 ? self : self.reversed()
    }
    func frame() -> (minX: CGFloat, minY: CGFloat, maxX: CGFloat, maxY: CGFloat) {
        var minX: CGFloat?
        var minY: CGFloat?
        var maxX: CGFloat?
        var maxY: CGFloat?
        for i in self {
            minX = minn(minX, i.x)
            minY = minn(minY, i.y)
            maxX = maxx(maxX, i.x)
            maxY = maxx(maxY, i.y)
        }
        return (minX!, minY!, maxX!, maxY!)
    }
    func closestPointTo(_ this: CGPoint) -> (CGPoint, [Int]) {
        var id: [Int] = []
        var smallestDist: CGFloat?
        for (i, j) in self.enumerated() {
            let dist = j._FAST_distance(this)
            if let s = smallestDist {
                if dist > s { continue }
                if dist < s { id = [] }
            }
            id.append(i)
            smallestDist = dist
        }
        return (self[id[0]], id)
    }
    
}
extension CGPoint {
    
    func difference(_ with: Self) -> Self {
        return .init(x: (self.x - with.x), y: (self.y - with.y))
    }
    func isClose(_ with: Self) -> Bool {
        return abs(self.x - with.x) < 1 && abs(self.y - with.y) < 1
    }
    func distance(_ with: Self) -> CGFloat {
        return sqrt((self.x - with.x) * (self.x - with.x) + (self.y - with.y) * (self.y - with.y))
    }
    func _FAST_distance(_ with: Self) -> CGFloat {
        return ((self.x - with.x) * (self.x - with.x) + (self.y - with.y) * (self.y - with.y))
    }
    func plus(_ this: CGPoint) -> CGPoint {
        return .init(x: x + this.x, y: y + this.y)
    }
    
    /// Determine whether a Point lies within the specified polygon
    func liesWithinPolygon(_ vs: [CGPoint]) -> Bool {
        let superSize = vs.frame()
        if x < superSize.minX { return false }
        if x > superSize.maxX { return false }
        if y < superSize.minY { return false }
        if y > superSize.maxY { return false }
        let toTestWith = CGPoint(x: superSize.minX + superSize.maxX / 2, y: superSize.minY - 10)
        
        var intersections = 0;
        for side in 0..<vs.count {
            let ray1 = vs.modSub(side)
            let ray2 = vs.modSub(side + 1)
            
            if areIntersecting(aa1: self, aa2: toTestWith, bb1: ray1, bb2: ray2) == true {
                intersections += 1
            }
        }
        return ((intersections & 1) == 1)
    }
    
    func snapToClosestLineIn(convexPolygon: Polygon) -> (CGPoint, indicesHit: [Int], passThrough: Bool) {
        
        var snappy: [CGPoint] = []
        for side in 0..<convexPolygon.numberOfPoints {
            let ray1 = convexPolygon.point(i: side)
            let ray2 = convexPolygon.point(i: side + 1)
            snappy.append(self.snapTo(p1: ray1, p2: ray2, infiniteLine: false))
        }
        
        let (closestPoint, indicesOfPoint) = snappy.closestPointTo(self)
        
        return (closestPoint, indicesOfPoint, !Set(convexPolygon.passThrough).intersection(Set(indicesOfPoint)).isEmpty)
    }
}



extension CGPoint {
    func snapTo(p1: CGPoint, p2: CGPoint, infiniteLine: Bool) -> CGPoint {
        let (Ax, Ay) = (p1.x, p1.y)
        let (Bx, By) = (p2.x, p2.y)
        let (Cx, Cy) = (x, y)

        let eps: CGFloat = 0.0000001
        if abs(Ax-Bx) < eps && abs(Ay-By) < eps {
            return p1
        }

        let dx = Bx-Ax
        let dy = By-Ay
        let d2 = dx*dx + dy*dy
        let t = ((Cx-Ax)*dx + (Cy-Ay)*dy) / d2
        if !infiniteLine {
            if t <= 0 { return p1 }
            if t >= 1 { return p2 }
        }
        return CGPoint.init(x: dx*t + Ax, y: dy*t + Ay)

    }
}


// Determine whether two vectors intersect
func areIntersecting(aa1: CGPoint, aa2: CGPoint, bb1: CGPoint, bb2: CGPoint) -> Bool? {
    let (v1x1, v1y1) = (aa1.x, aa1.y)
    let (v1x2, v1y2) = (aa2.x, aa2.y)
    let (v2x1, v2y1) = (bb1.x, bb1.y)
    let (v2x2, v2y2) = (bb2.x, bb2.y)

    // Convert vector 1 to a line (line 1) of infinite length.
    // We want the line in linear equation standard form: A*x + B*y + C = 0
    // See: http://en.wikipedia.org/wiki/Linear_equation
    let a1 = v1y2 - v1y1;
    let b1 = v1x1 - v1x2;
    let c1 = (v1x2 * v1y1) - (v1x1 * v1y2);

    // Every point (x,y), that solves the equation above, is on the line,
    // every point that does not solve it, is not. The equation will have a
    // positive result if it is on one side of the line and a negative one
    // if is on the other side of it. We insert (x1,y1) and (x2,y2) of vector
    // 2 into the equation above.
    var d1 = (a1 * v2x1) + (b1 * v2y1) + c1;
    var d2 = (a1 * v2x2) + (b1 * v2y2) + c1;

    // If d1 and d2 both have the same sign, they are both on the same side
    // of our line 1 and in that case no intersection is possible. Careful,
    // 0 is a special case, that's why we don't test ">=" and "<=",
    // but "<" and ">".
    if (d1 > 0 && d2 > 0) { return false }
    if (d1 < 0 && d2 < 0) { return false }

    // The fact that vector 2 intersected the infinite line 1 above doesn't
    // mean it also intersects the vector 1. Vector 1 is only a subset of that
    // infinite line 1, so it may have intersected that line before the vector
    // started or after it ended. To know for sure, we have to repeat the
    // the same test the other way round. We start by calculating the
    // infinite line 2 in linear equation standard form.
    let a2 = v2y2 - v2y1;
    let b2 = v2x1 - v2x2;
    let c2 = (v2x2 * v2y1) - (v2x1 * v2y2);

    // Calculate d1 and d2 again, this time using points of vector 1.
    d1 = (a2 * v1x1) + (b2 * v1y1) + c2;
    d2 = (a2 * v1x2) + (b2 * v1y2) + c2;

    // Again, if both have the same sign (and neither one is 0),
    // no intersection is possible.
    if (d1 > 0 && d2 > 0) { return false }
    if (d1 < 0 && d2 < 0) { return false }

    // If we get here, only two possibilities are left. Either the two
    // vectors intersect in exactly one point or they are collinear, which
    // means they intersect in any number of points from zero to infinite.
    if ((a1 * b2) - (a2 * b1) == 0.0) { return nil };

    // If they are not collinear, they must intersect in exactly one point.
    return true
}

extension CGPoint {
    func isLeft(a: CGPoint, b: CGPoint) -> Bool {
         return ((b.x - a.x)*(y - a.y) - (b.y - a.y)*(x - a.x)) > 0
    }
    func midPoint(_ with: Self) -> Self {
        return .init(x: (self.x + with.x) / 2, y: (self.y + with.y) / 2)
    }
}

extension Array where Element == CGPoint {
    
    func matchingIndicesInARow(_ with: Self) -> (matches: Bool, indiceToSkip: Int) {
        var matchesFirst: Bool = false
        var matchesLast: Bool = false
        var inARow: Int = 0
        for (i, point) in self.enumerated() {
            if with.contains(point) {
                
                inARow += 1
                
                if i == 0 {
                    matchesFirst = true
                }
                if i == count-1 {
                    matchesLast = true
                }
                
            } else {
                inARow = 0
            }
            
            if inARow == 2 {
                return (true, i-1)
            }
        }
        
        return (matchesFirst && matchesLast, count-1)
    }
    
    func indicesOfConcavePoints() -> [Int] {
        if count < 4 { return [] }
        var inds: [Int] = []
        for (i, point) in self.enumerated() {
            if point.isLeft(a: modSub(i - 1), b: modSub(i + 1)) {
                inds.append(i)
            }
        }
        return inds
    }
    
    
    func convertToConcave() -> [[CGPoint]] {
        let inds = indicesOfConcavePoints()
        
        if inds.isEmpty {
            return [self]
        }
        
        for ind in inds {
            let i = self[ind]
            var good = [Int]()
            for (jnd, j) in self.enumerated() {
                if ind == jnd { continue }
                if ind == (jnd+1)%count { continue }
                if jnd == (ind+1)%count { continue }
                
                var bad = false
                for (ray, point) in self.enumerated() {
                    if ray == ind { continue }
                    if ray == jnd { continue }
                    if (ray+1)%count == ind { continue }
                    if (ray+1)%count == jnd { continue }
                    if areIntersecting(aa1: i, aa2: j, bb1: point, bb2: modSub(ray + 1)) == true {
                        bad = true
                    }
                }
                if !bad, i.midPoint(j).liesWithinPolygon(.init(self)) {
                    // Found ind - jnd connection!
                    good.append(jnd)
                    
                    // make cut on first decision
                    let (ii, jj) = ind > jnd ? (ind, jnd) : (jnd, ind)
                    
                    let newShape = (self[ii..<(count)] + self[0...jj]).map { $0 }
                    let oldShape = self[jj...ii].map { $0 }
                    
                    return newShape.convertToConcave() + oldShape.convertToConcave()
                }
                
            }
            //print(ind, good)
        }
        return [self]
    }
}


