package components.ingameaar_part
{
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import shaui.component.core.UIComponent;
   
   public class AARXPPiechart extends UIComponent
   {
      
      protected var mPieChild:Sprite;
      
      protected var mPieRadius:Number;
      
      protected var mPieInnerRadius:Number;
      
      protected var mFocusedPiece:int;
      
      protected var mPieceSprites:Vector.<Sprite>;
      
      public function AARXPPiechart()
      {
         super();
         this.mPieRadius = width * 0.5;
         this.mPieInnerRadius = 0.8 * this.mPieRadius;
         this.mFocusedPiece = -1;
         this.mPieceSprites = new Vector.<Sprite>();
         this.mPieChild = new Sprite();
         addChild(this.mPieChild);
         this.mPieChild.x = this.mPieChild.y = this.mPieRadius;
      }
      
      public function SetPieData(percents:Vector.<Number>, colors:Vector.<uint>) : void
      {
         var colorToUse:uint = 0;
         var pct:Number = NaN;
         var sprite:Sprite = null;
         var endAngle:Number = NaN;
         while(this.mPieChild.numChildren > 0)
         {
            this.mPieChild.removeChildAt(0);
         }
         this.mPieceSprites.length = percents.length;
         var angle:Number = Math.PI * -0.5;
         for(var i:int = 0; i < percents.length; i++)
         {
            pct = percents[i];
            pct = Math.max(0,pct);
            pct = Math.min(1,pct);
            colorToUse = colors[i];
            if(pct > 0 && colors.length > i)
            {
               sprite = new Sprite();
               this.mPieChild.addChild(sprite);
               this.mPieceSprites[i] = sprite;
               endAngle = angle + pct * 2 * Math.PI;
               this.DrawPiePiece(sprite,angle,endAngle,colorToUse);
               angle = endAngle;
            }
         }
         this.mPieChild.filters = [new GlowFilter(0,0.8,30,30,1)];
      }
      
      protected function DrawPiePiece(sprite:Sprite, startAngle:Number, endAngle:Number, color:uint) : void
      {
         var deltaAngle:Number = endAngle - startAngle;
         var segs:Number = Math.ceil(deltaAngle / (Math.PI / 4));
         var segAngle:Number = deltaAngle / segs;
         sprite.graphics.beginFill(color);
         var cosStart:Number = Math.cos(startAngle);
         var sinStart:Number = Math.sin(startAngle);
         sprite.graphics.moveTo(cosStart * this.mPieInnerRadius,sinStart * this.mPieInnerRadius);
         sprite.graphics.lineTo(cosStart * this.mPieRadius,sinStart * this.mPieRadius);
         this.DrawArc(sprite,startAngle,segs,segAngle,this.mPieRadius);
         sprite.graphics.lineTo(Math.cos(endAngle) * this.mPieInnerRadius,Math.sin(endAngle) * this.mPieInnerRadius);
         this.DrawArc(sprite,endAngle,segs,-segAngle,this.mPieInnerRadius);
         sprite.graphics.endFill();
      }
      
      protected function DrawArc(sprite:Sprite, startAngle:Number, segs:Number, segAngle:Number, radius:Number) : void
      {
         var angleMid:Number = NaN;
         var halfSegAngle:Number = segAngle / 2;
         var ctrlPtDist:Number = radius / Math.cos(halfSegAngle);
         var curAngle:Number = startAngle;
         for(var i:Number = 0; i < segs; i++)
         {
            curAngle += segAngle;
            angleMid = curAngle - halfSegAngle;
            sprite.graphics.curveTo(Math.cos(angleMid) * ctrlPtDist,Math.sin(angleMid) * ctrlPtDist,Math.cos(curAngle) * radius,Math.sin(curAngle) * radius);
         }
      }
   }
}

