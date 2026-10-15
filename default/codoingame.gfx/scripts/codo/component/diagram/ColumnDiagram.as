package codo.component.diagram
{
   import codo.component.core.UIInteractiveComponent;
   import codo.utils.ScaleformUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class ColumnDiagram extends UIInteractiveComponent
   {
      
      private static const FULL_BAR_HEIGHT:int = 120;
      
      private static const TWEEN_DURATION:int = 1;
      
      public var myColumnLabel0:TextField;
      
      public var myColumnLabel1:TextField;
      
      public var myColumnLabel2:TextField;
      
      public var myColumnLabel3:TextField;
      
      public var myColumnLabel4:TextField;
      
      private var mFullHeightValue:Number;
      
      private var mTweenLite:TweenLite;
      
      private var mHeights:Array = [];
      
      public function ColumnDiagram()
      {
         super();
         if(!ScaleformUtil.isScaleform)
         {
            this.setData([100,20,30,50,70]);
         }
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.mFullHeightValue = 0;
         for(var i:int = 0; i < mData.length; i++)
         {
            if(this.mFullHeightValue < mData[i])
            {
               this.mFullHeightValue = mData[i];
            }
         }
         this.mHeights.splice(0);
         for(i = 0; i < mData.length; i++)
         {
            this.mHeights.push(this.getBarHeight(mData[i]));
         }
      }
      
      public function playAnimation() : void
      {
         this.clearColumn();
         this.mTweenLite = TweenLite.to(this,TWEEN_DURATION,{"onUpdate":this.onUpdateHandler});
      }
      
      private function getBarHeight(value:Number) : Number
      {
         return value / this.mFullHeightValue * FULL_BAR_HEIGHT;
      }
      
      private function setColumnHeight(index:int, value:Number, maxValue:Number) : void
      {
         if(maxValue == 0)
         {
            maxValue = 1;
         }
         var columnHeight:Number = value / maxValue * FULL_BAR_HEIGHT;
         var column:MovieClip = this["myColumn" + String(index)];
         column.myBg.height = columnHeight;
         column.y = column.height * -1 + 155;
      }
      
      private function setColumnText(index:int, value:Number) : void
      {
         var column:MovieClip = this["myColumn" + String(index)];
         column.myText.text = value.toFixed(0);
      }
      
      private function onUpdateHandler() : void
      {
         var percent:Number = this.mTweenLite.currentTime / TWEEN_DURATION;
         for(var i:int = 0; i < mData.length; i++)
         {
            this.setColumnHeight(i,mData[i] * percent,this.mFullHeightValue);
            this.setColumnText(i,mData[i] * percent);
         }
      }
      
      private function clearColumn() : void
      {
         for(var i:int = 0; i < mData.length; i++)
         {
            this.setColumnHeight(i,0,this.mFullHeightValue);
            this.setColumnText(i,0);
         }
      }
   }
}

