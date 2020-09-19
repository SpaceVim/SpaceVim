module Geometry {
    export class Square {
        constructor(public sideLength: number = 0) {
        }
        area() {
            return Math.pow(this.sideLength, 2);
        }
    }
}

class Tuple<T1, T2> {
    constructor(public item1: T1, public item2: T2) { }
}
