package common.ui
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

public class SliceScalingBitmap extends Bitmap
   {


      public static var greenButton:String = "generic_green_button";
      
      public static var SCALE_TYPE_NONE:String = "none";
      
      public static var SCALE_TYPE_3:String = "3grid";
      
      public static var SCALE_TYPE_9:String = "9grid";
       
      
      private var scaleGrid:Rectangle;

      public var currentWidth:int;
      
      public var currentHeight:int;
      
      private var bitmapDataToSlice:BitmapData;
      
      private var _scaleType:String;
      
      private var fillColor:uint;
      
      protected var margin:Point;
      
      private var fillColorAlpha:Number;
      
      private var _forceRenderInNextFrame:Boolean;
      
      private var _sourceBitmapName:String;
      
      public function SliceScalingBitmap(texture:BitmapData, scaleType:String, sliceRect:Rectangle = null, fillColor:uint = 0, fillColorAlpha:Number = 1)
      {
         this.margin = new Point();
         super();
         this.bitmapDataToSlice = texture;
         this.scaleGrid = sliceRect;
         this.currentWidth = texture.width;
         this.currentHeight = texture.height;
         this._scaleType = scaleType;
         this.fillColor = fillColor;
         this.fillColorAlpha = fillColorAlpha;
         if(scaleType != SCALE_TYPE_NONE)
         {
            this.render();
         }
         else
         {
            this.bitmapData = texture;
         }
      }
      
      public function clone() : SliceScalingBitmap
      {
         return new SliceScalingBitmap(this.bitmapDataToSlice.clone(),this.scaleType,this.scaleGrid,this.fillColor,this.fillColorAlpha);
      }
      
      override public function set width(width:Number) : void
      {
         if(width != this.currentWidth || this._forceRenderInNextFrame)
         {
            this.currentWidth = width;
            this.render();
         }
      }
      
      override public function set height(height:Number) : void
      {
         if(height != this.currentHeight)
         {
            this.currentHeight = height;
            this.render();
         }
      }
      
      override public function get width() : Number
      {
         return this.currentWidth * this.scaleX;
      }
      
      override public function get height() : Number
      {
         return this.currentHeight * this.scaleY;
      }
      
      protected function render() : void
      {
         if(this._scaleType == SCALE_TYPE_NONE)
         {
            return;
         }
         if(this.bitmapData)
         {
            this.bitmapData.dispose();
         }
         if(this._scaleType == SCALE_TYPE_3)
         {
            this.prepare3grid();
         }
         if(this._scaleType == SCALE_TYPE_9)
         {
            this.prepare9grid();
         }
         if(this._forceRenderInNextFrame)
         {
            this._forceRenderInNextFrame = false;
         }
      }
      
      private function prepare3grid() : void
      {
         if(this.scaleGrid.y == 0)
         {
            var targetWidth:int = this.currentWidth - this.bitmapDataToSlice.width + this.scaleGrid.width;
            this.bitmapData = new BitmapData(this.currentWidth + this.margin.x,this.currentHeight + this.margin.y,true,0);
            this.bitmapData.copyPixels(this.bitmapDataToSlice,new Rectangle(0,0,this.scaleGrid.x,this.bitmapDataToSlice.height),new Point(this.margin.x,this.margin.y));
            var currentWidth:int = 0;
            while(currentWidth < targetWidth)
            {
               this.bitmapData.copyPixels(this.bitmapDataToSlice,new Rectangle(this.scaleGrid.x,0,this.scaleGrid.width,this.bitmapDataToSlice.height),new Point(this.scaleGrid.x + currentWidth + this.margin.x,this.margin.y));
               currentWidth++;
            }
            this.bitmapData.copyPixels(this.bitmapDataToSlice,new Rectangle(this.scaleGrid.x + this.scaleGrid.width,0,this.bitmapDataToSlice.width - (this.scaleGrid.x + this.scaleGrid.width),this.bitmapDataToSlice.height),new Point(this.scaleGrid.x + targetWidth + this.margin.x,this.margin.y));
         }
         else
         {
            var targetHeight:int = this.currentHeight - this.bitmapDataToSlice.height + this.scaleGrid.height;
            this.bitmapData = new BitmapData(this.currentWidth + this.margin.x,this.currentHeight + this.margin.y,true,0);
            this.bitmapData.copyPixels(this.bitmapDataToSlice,new Rectangle(0,0,this.bitmapDataToSlice.width,this.scaleGrid.y),new Point(this.margin.x,this.margin.y));
            var currentHeight:int = 0;
            while(currentHeight < targetHeight)
            {
               this.bitmapData.copyPixels(this.bitmapDataToSlice,new Rectangle(0,this.scaleGrid.y,this.scaleGrid.width,this.bitmapDataToSlice.height),new Point(this.margin.x,this.margin.y + this.scaleGrid.y + currentHeight));
               currentHeight++;
            }
            this.bitmapData.copyPixels(this.bitmapDataToSlice,new Rectangle(0,this.scaleGrid.y + this.scaleGrid.height,this.bitmapDataToSlice.width,this.bitmapDataToSlice.height - (this.scaleGrid.y + this.scaleGrid.height)),new Point(this.margin.x,this.margin.y + this.scaleGrid.y + targetHeight));
         }
      }
      
      private function prepare9grid() : void
      {
         var _loc1_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:Rectangle = new Rectangle();
         var _loc3_:Rectangle = new Rectangle();
         var _loc4_:Matrix = new Matrix();
         var _loc5_:BitmapData = new BitmapData(this.currentWidth + this.margin.x,this.currentHeight + this.margin.y,true,0);
         var _loc6_:Array = [0,this.scaleGrid.top,this.scaleGrid.bottom,this.bitmapDataToSlice.height];
         var _loc7_:Array = [0,this.scaleGrid.left,this.scaleGrid.right,this.bitmapDataToSlice.width];
         var _loc8_:Array = [0,this.scaleGrid.top,this.currentHeight - (this.bitmapDataToSlice.height - this.scaleGrid.bottom),this.currentHeight];
         var _loc9_:Array = [0,this.scaleGrid.left,this.currentWidth - (this.bitmapDataToSlice.width - this.scaleGrid.right),this.currentWidth];
         while(_loc10_ < 3)
         {
            _loc1_ = 0;
            while(_loc1_ < 3)
            {
               _loc2_.setTo(_loc7_[_loc10_],_loc6_[_loc1_],_loc7_[_loc10_ + 1] - _loc7_[_loc10_],_loc6_[_loc1_ + 1] - _loc6_[_loc1_]);
               _loc3_.setTo(_loc9_[_loc10_],_loc8_[_loc1_],_loc9_[_loc10_ + 1] - _loc9_[_loc10_],_loc8_[_loc1_ + 1] - _loc8_[_loc1_]);
               _loc4_.identity();
               _loc4_.a = _loc3_.width / _loc2_.width;
               _loc4_.d = _loc3_.height / _loc2_.height;
               _loc4_.tx = _loc3_.x - _loc2_.x * _loc4_.a;
               _loc4_.ty = _loc3_.y - _loc2_.y * _loc4_.d;
               _loc5_.draw(this.bitmapDataToSlice,_loc4_,null,null,_loc3_);
               _loc1_++;
            }
            _loc10_++;
         }
         this.bitmapData = _loc5_;
      }
      
      public function addMargin(param1:int, param2:int) : void
      {
         this.margin = new Point(param1,param2);
      }
      
      public function dispose() : void
      {
         this.bitmapData.dispose();
         this.bitmapDataToSlice.dispose();
      }
      
      public function get scaleType() : String
      {
         return this._scaleType;
      }
      
      public function set scaleType(param1:String) : void
      {
         this._scaleType = param1;
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = Math.round(param1);
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = Math.round(param1);
      }
      
      public function get forceRenderInNextFrame() : Boolean
      {
         return this._forceRenderInNextFrame;
      }
      
      public function set forceRenderInNextFrame(param1:Boolean) : void
      {
         this._forceRenderInNextFrame = param1;
      }
      
      public function get marginX() : int
      {
         return this.margin.x;
      }
      
      public function get marginY() : int
      {
         return this.margin.y;
      }
      
      public function get sourceBitmapName() : String
      {
         return this._sourceBitmapName;
      }
      
      public function set sourceBitmapName(param1:String) : void
      {
         this._sourceBitmapName = param1;
      }
   }
}
