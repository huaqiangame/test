//Created by Action Script Viewer - http://www.buraks.com/asv
package com.greensock.motionPaths {
    import flash.geom.*;
    import flash.display.*;

    public class LinePath2D extends MotionPath {

        protected var _first:PathPoint;
        protected var _points:Array;
        protected var _totalLength:Number;
        protected var _hasAutoRotate:Boolean;
        protected var _prevMatrix:Matrix;
        public var autoUpdatePoints:Boolean;

        public function LinePath2D(points:Array=null, x:Number=0, y:Number=0, autoUpdatePoints:Boolean=false){
            super();
            this._points = [];
            this._totalLength = 0;
            this.autoUpdatePoints = autoUpdatePoints;
            if (points != null){
                this.insertMultiplePoints(points, 0);
            };
            super.x = x;
            super.y = y;
        }
        public function appendPoint(point:Point):void{
            this._insertPoint(point, this._points.length, false);
        }
        public function insertPoint(point:Point, index:uint=0):void{
            this._insertPoint(point, index, false);
        }
        protected function _insertPoint(point:Point, index:uint, skipOrganize:Boolean):void{
            this._points.splice(index, 0, new PathPoint(point));
            if (!(skipOrganize)){
                this._organize();
            };
        }
        public function appendMultiplePoints(points:Array):void{
            this.insertMultiplePoints(points, this._points.length);
        }
        public function insertMultiplePoints(points:Array, index:uint=0):void{
            var l:int = points.length;
            var i:int;
            while (i < l) {
                this._insertPoint(points[i], (index + i), true);
                i++;
            };
            this._organize();
        }
        public function removePoint(point:Point):void{
            var i:int = this._points.length;
            while (--i > -1) {
                if (this._points[i].point == point){
                    this._points.splice(i, 1);
                };
            };
            this._organize();
        }
        public function removePointByIndex(index:uint):void{
            this._points.splice(index, 1);
            this._organize();
        }
        protected function _organize():void{
            var pp:PathPoint;
            this._totalLength = 0;
            this._hasAutoRotate = false;
            var last:int = (this._points.length - 1);
            if (last == -1){
                this._first = null;
            } else {
                if (last == 0){
                    this._first = this._points[0];
                    this._first.progress = (this._first.xChange = (this._first.yChange = (this._first.length = 0)));
                    return;
                };
            };
            var i:int;
            while (i <= last) {
                if (this._points[i] != null){
                    pp = this._points[i];
                    pp.x = pp.point.x;
                    pp.y = pp.point.y;
                    if (i == last){
                        pp.length = 0;
                        pp.next = null;
                    } else {
                        pp.next = this._points[(i + 1)];
                        pp.xChange = (pp.next.x - pp.x);
                        pp.yChange = (pp.next.y - pp.y);
                        pp.length = Math.sqrt(((pp.xChange * pp.xChange) + (pp.yChange * pp.yChange)));
                        this._totalLength = (this._totalLength + pp.length);
                    };
                };
                i++;
            };
            pp = this._points[0];
            this._first = pp;
            var curTotal:Number = 0;
            while (pp) {
                pp.progress = (curTotal / this._totalLength);
                curTotal = (curTotal + pp.length);
                pp = pp.next;
            };
            this._updateAngles();
        }
        protected function _updateAngles():void{
            var m:Matrix = this.transform.matrix;
            var pp:PathPoint = this._first;
            while (pp) {
                pp.angle = (Math.atan2(((pp.xChange * m.b) + (pp.yChange * m.d)), ((pp.xChange * m.a) + (pp.yChange * m.c))) * _RAD2DEG);
                pp = pp.next;
            };
            this._prevMatrix = m;
        }
        override protected function renderAll():void{
            var px:Number;
            var py:Number;
            var pp:PathPoint;
            var followerProgress:Number;
            var pathProg:Number;
            var g:Graphics;
            if ((((this._first == null)) || ((this._points.length <= 1)))){
                return;
            };
            var updatedAngles:Boolean;
            var m:Matrix = this.transform.matrix;
            var a:Number = m.a;
            var b:Number = m.b;
            var c:Number = m.c;
            var d:Number = m.d;
            var tx:Number = m.tx;
            var ty:Number = m.ty;
            var f:PathFollower = _rootFollower;
            if (this.autoUpdatePoints){
                pp = this._first;
                while (pp) {
                    if (((!((pp.point.x == pp.x))) || (!((pp.point.y == pp.y))))){
                        this._organize();
                        _redrawLine = true;
                        this.renderAll();
                        return;
                    };
                    pp = pp.next;
                };
            };
            while (f) {
                followerProgress = f.cachedProgress;
                pp = this._first;
                while (((!((pp == null))) && ((pp.next.progress < followerProgress)))) {
                    pp = pp.next;
                };
                if (pp != null){
                    pathProg = ((followerProgress - pp.progress) / (pp.length / this._totalLength));
                    px = (pp.x + (pathProg * pp.xChange));
                    py = (pp.y + (pathProg * pp.yChange));
                    f.target.x = (((px * a) + (py * c)) + tx);
                    f.target.y = (((px * b) + (py * d)) + ty);
                    if (f.autoRotate){
                        if (((!(updatedAngles)) && (((((((!((this._prevMatrix.a == a))) || (!((this._prevMatrix.b == b))))) || (!((this._prevMatrix.c == c))))) || (!((this._prevMatrix.d == d))))))){
                            this._updateAngles();
                            updatedAngles = true;
                        };
                        f.target.rotation = (pp.angle + f.rotationOffset);
                    };
                };
                f = f.cachedNext;
            };
            if (((((_redrawLine) && (this.visible))) && (this.parent))){
                g = this.graphics;
                g.clear();
                g.lineStyle(_thickness, _color, _lineAlpha, _pixelHinting, _scaleMode, _caps, _joints, _miterLimit);
                pp = this._first;
                g.moveTo(pp.x, pp.y);
                while (pp) {
                    g.lineTo(pp.x, pp.y);
                    pp = pp.next;
                };
                _redrawLine = false;
            };
        }
        override public function renderObjectAt(target:Object, progress:Number, autoRotate:Boolean=false, rotationOffset:Number=0):void{
            var pathProg:Number;
            var px:Number;
            var py:Number;
            var m:Matrix;
            if (progress > 1){
                progress = (progress - int(progress));
            } else {
                if (progress < 0){
                    progress = (progress - (int(progress) - 1));
                };
            };
            if (this._first == null){
                return;
            };
            var pp:PathPoint = this._first;
            while (((!((pp.next == null))) && ((pp.next.progress < progress)))) {
                pp = pp.next;
            };
            if (pp != null){
                pathProg = ((progress - pp.progress) / (pp.length / this._totalLength));
                px = (pp.x + (pathProg * pp.xChange));
                py = (pp.y + (pathProg * pp.yChange));
                m = this.transform.matrix;
                target.x = (((px * m.a) + (py * m.c)) + m.tx);
                target.y = (((px * m.b) + (py * m.d)) + m.ty);
                if (autoRotate){
                    if (((((((!((this._prevMatrix.a == m.a))) || (!((this._prevMatrix.b == m.b))))) || (!((this._prevMatrix.c == m.c))))) || (!((this._prevMatrix.d == m.d))))){
                        this._updateAngles();
                    };
                    target.rotation = (pp.angle + rotationOffset);
                };
            };
        }
        public function getSegmentProgress(segment:uint, progress:Number):Number{
            if (this._first == null){
                return (0);
            };
            if (this._points.length <= segment){
                segment = this._points.length;
            };
            var pp:PathPoint = this._points[(segment - 1)];
            return ((pp.progress + ((progress * pp.length) / this._totalLength)));
        }
        public function snap(target:Object, autoRotate:Boolean=false, rotationOffset:Number=0):PathFollower{
            return (this.addFollower(target, this.getClosestProgress(target), autoRotate, rotationOffset));
        }
        public function getClosestProgress(target:Object):Number{
            var closestPath:PathPoint;
            var dxTarg:Number;
            var dyTarg:Number;
            var dxNext:Number;
            var dyNext:Number;
            var dTarg:Number;
            var angle:Number;
            var next:PathPoint;
            var curDist:Number;
            if ((((this._first == null)) || ((this._points.length == 1)))){
                return (0);
            };
            var closest:Number = 9999999999;
            var length:Number = 0;
            var halfPI:Number = (Math.PI / 2);
            var xTarg:Number = target.x;
            var yTarg:Number = target.y;
            var pp:PathPoint = this._first;
            while (pp) {
                dxTarg = (xTarg - pp.x);
                dyTarg = (yTarg - pp.y);
                next = ((pp.next)!=null) ? pp.next : pp;
                dxNext = (next.x - pp.x);
                dyNext = (next.y - pp.y);
                dTarg = Math.sqrt(((dxTarg * dxTarg) + (dyTarg * dyTarg)));
                angle = (Math.atan2(dyTarg, dxTarg) - Math.atan2(dyNext, dxNext));
                if (angle < 0){
                    angle = -(angle);
                };
                if (angle > halfPI){
                    if (dTarg < closest){
                        closest = dTarg;
                        closestPath = pp;
                        length = 0;
                    };
                } else {
                    curDist = (Math.cos(angle) * dTarg);
                    if (curDist < 0){
                        curDist = -(curDist);
                    };
                    if (curDist > pp.length){
                        dxNext = (xTarg - next.x);
                        dyNext = (yTarg - next.y);
                        curDist = Math.sqrt(((dxNext * dxNext) + (dyNext * dyNext)));
                        if (curDist < closest){
                            closest = curDist;
                            closestPath = pp;
                            length = pp.length;
                        };
                    } else {
                        curDist = (Math.sin(angle) * dTarg);
                        if (curDist < closest){
                            closest = curDist;
                            closestPath = pp;
                            length = (Math.cos(angle) * dTarg);
                        };
                    };
                };
                pp = pp.next;
            };
            return ((closestPath.progress + (length / this._totalLength)));
        }
        public function get totalLength():Number{
            return (this._totalLength);
        }
        public function get points():Array{
            var a:Array = [];
            var l:int = this._points.length;
            var i:int;
            while (i < l) {
                a[i] = this._points[i].point;
                i++;
            };
            return (a);
        }
        public function set points(value:Array):void{
            this._points = [];
            this.insertMultiplePoints(value, 0);
        }

    }
}//package com.greensock.motionPaths 

import flash.geom.*;

class PathPoint {

    public var x:Number;
    public var y:Number;
    public var progress:Number;
    public var xChange:Number;
    public var yChange:Number;
    public var point:Point;
    public var length:Number;
    public var angle:Number;
    public var next:PathPoint;

    private function PathPoint(point:Point){
        super();
        this.x = point.x;
        this.y = point.y;
        this.point = point;
    }
}
