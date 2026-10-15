package components.fsgmatchresults_part
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgImageHolder;
   
   public class MissionAwardsComponent extends MovieClip
   {
      
      public var myHitArea:MovieClip;
      
      public var myContainer:MovieClip;
      
      public var myAwardText:TextField;
      
      public var myImgHolder:FsgImageHolder;
      
      private var m_award:Object;
      
      private var m_onMouseOverCallback:Function;
      
      private var m_onMouseOutCallback:Function;
      
      public function MissionAwardsComponent()
      {
         super();
         this.myHitArea = this.myContainer["myHitArea"];
         this.myAwardText = this.myContainer["myAwardText"];
         this.myImgHolder = this.myContainer["myImgHolder"];
         this.myAwardText.autoSize = TextFieldAutoSize.CENTER;
      }
      
      public function SetItem(awardItem:Object) : void
      {
         this.m_award = awardItem;
         this.myAwardText.text = awardItem.name;
         gotoAndStop(2);
         if(awardItem.imageURL != null)
         {
            this.myImgHolder.clearImage();
            this.myImgHolder.setImage(awardItem.imageURL);
         }
      }
      
      public function get awardData() : Object
      {
         return this.m_award;
      }
      
      private function onMouseOver(e:MouseEvent) : void
      {
         this.gotoAndStop(2);
         if(this.m_onMouseOverCallback != null)
         {
            this.m_onMouseOverCallback(this);
         }
      }
      
      public function set onMouseOverCallback(func:Function) : void
      {
         this.m_onMouseOverCallback = func;
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         this.gotoAndStop(1);
         if(this.m_onMouseOutCallback != null)
         {
            this.m_onMouseOutCallback();
         }
      }
      
      public function set onMouseOutCallback(func:Function) : void
      {
         this.m_onMouseOutCallback = func;
      }
   }
}

