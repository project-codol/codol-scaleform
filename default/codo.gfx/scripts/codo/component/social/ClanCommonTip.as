package codo.component.social
{
   import codo.component.TextField;
   import codo.style.ClanGuide;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class ClanCommonTip extends MovieClip
   {
      
      public static const TYPE_SINGLE_LINE:int = 0;
      
      public static const TYPE_MULTIPLE_LINE:int = 1;
      
      private static const PADDING:int = 5;
      
      private static const X_OFFSET:int = 20;
      
      private static const Y_OFFSET:int = 20;
      
      private static const BG_PADDING:int = 13;
      
      public var myText:TextField;
      
      public var myBg:MovieClip;
      
      private var mDataProvider:Dictionary = new Dictionary();
      
      private var mType:int;
      
      private var mFixedWidth:int = 100;
      
      public function ClanCommonTip()
      {
         super();
      }
      
      public function showTip(mc:MovieClip) : void
      {
         if(this.mType == TYPE_SINGLE_LINE)
         {
            this.myText.textStyle = ClanGuide.styleClanCommonTip;
         }
         else
         {
            this.myText.textStyle = ClanGuide.styleClanMultipleTip;
            this.myText.width = this.mFixedWidth;
         }
         visible = true;
         this.setTipStringByCustomizedHandler(mc);
         this.myText.x = this.myText.y = PADDING;
         this.myBg.x = this.myBg.y = 0;
         if(this.mType == TYPE_SINGLE_LINE)
         {
            this.myBg.width = this.myText.textWidth + BG_PADDING;
         }
         else
         {
            this.myBg.width = this.mFixedWidth + PADDING;
         }
         this.myBg.height = this.myText.textHeight + BG_PADDING;
      }
      
      public function hideTip() : void
      {
         visible = false;
      }
      
      public function setType(type:int) : void
      {
         this.mType = type;
      }
      
      public function setFixedWidth(value:Number) : void
      {
         this.mFixedWidth = value;
      }
      
      public function bindMovieClip(mc:MovieClip, dataHandler:Function) : void
      {
         mc.addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOverHandler);
         mc.addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOutHandler);
         mc.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
         this.mDataProvider[mc] = dataHandler;
      }
      
      public function unbindMovieClip(mc:MovieClip) : void
      {
         mc.removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOverHandler);
         mc.removeEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOutHandler);
         mc.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
         delete this.mDataProvider[mc];
      }
      
      private function onMouseRollOverHandler(e:MouseEvent) : void
      {
         var p:Point = null;
         if(!parent)
         {
            return;
         }
         var curTarget:MovieClip = e.currentTarget as MovieClip;
         this.showTip(curTarget);
         p = new Point(e.stageX,e.stageY);
         p = curTarget.parent.globalToLocal(p);
         x = p.x + X_OFFSET;
         y = p.y + Y_OFFSET;
      }
      
      private function onMouseRollOutHandler(e:MouseEvent) : void
      {
         var curTarget:MovieClip = e.currentTarget as MovieClip;
         this.hideTip();
      }
      
      private function onMouseMoveHandler(e:MouseEvent) : void
      {
         var p:Point = null;
         if(!parent)
         {
            return;
         }
         var curTarget:MovieClip = e.currentTarget as MovieClip;
         p = new Point(e.stageX,e.stageY);
         p = curTarget.parent.globalToLocal(p);
         x = p.x + X_OFFSET;
         y = p.y + Y_OFFSET;
      }
      
      private function setTipStringByCustomizedHandler(mc:MovieClip) : void
      {
         var handler:Function = null;
         if(this.mDataProvider[mc] is Function)
         {
            handler = this.mDataProvider[mc] as Function;
            handler(this.myText);
         }
      }
   }
}

