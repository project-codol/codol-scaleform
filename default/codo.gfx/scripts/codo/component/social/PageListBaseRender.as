package codo.component.social
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.core.UIInteractiveComponent;
   import codo.localization.Dict;
   import codo.localization.DictCareer;
   import codo.utils.LocalizeUtil;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class PageListBaseRender extends UIInteractiveComponent
   {
      
      private static const MOUSE_OVER_ANIM_DURATION:Number = 0.15;
      
      public var myBg:MovieClip;
      
      protected var mHandler:Function;
      
      protected var mInteractiveHandler:Function;
      
      protected var mIndex:int;
      
      public function PageListBaseRender()
      {
         super();
         this.myBg.alpha = 0;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
      }
      
      public function set buttonClickHandler(handler:Function) : void
      {
         this.mHandler = handler;
      }
      
      public function set buttonMouseOverHandler(handler:Function) : void
      {
         this.mInteractiveHandler = handler;
      }
      
      override public function get height() : Number
      {
         return this.myBg.height;
      }
      
      protected function formatRank(prestige:int, rank:int) : String
      {
         var levelStr:String = CFunctionCommonContainer.GetDisplayLevel(rank);
         if(prestige == 0)
         {
            return LocalizeUtil.param(DictCareer.CAREER_X_LEVEL,[levelStr]);
         }
         return LocalizeUtil.param(DictCareer.CAREER_X_PRESTIGE,[String(prestige),levelStr]);
      }
      
      protected function calculateKDA(kills:int, deaths:int, assists:int) : String
      {
         var kda:Number = 0;
         if(deaths != 0)
         {
            kda = (kills + assists) / deaths;
         }
         return kda.toFixed(2);
      }
      
      protected function timePlayedHour(seconds:int) : String
      {
         return String((seconds / 3600).toFixed(0)) + LocalizeUtil.localize(Dict.HOUR);
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         TweenLite.to(this.myBg,MOUSE_OVER_ANIM_DURATION,{"alpha":1});
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         TweenLite.to(this.myBg,MOUSE_OVER_ANIM_DURATION,{"alpha":0});
      }
      
      public function set index(value:int) : void
      {
         this.mIndex = value;
      }
   }
}

