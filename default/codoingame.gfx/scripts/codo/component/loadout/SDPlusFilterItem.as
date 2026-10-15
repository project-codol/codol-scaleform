package codo.component.loadout
{
   import codo.component.Button;
   import codo.objects.SDPSubGroupObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   
   public class SDPlusFilterItem extends Button
   {
      
      private static const SLIDE_DURATION:Number = 0.25;
      
      private static const UNFOCUS_ALPHA:Number = 0.66;
      
      public var myIcon:MovieClip;
      
      public function SDPlusFilterItem()
      {
         super();
         myLabel.font = GlobalGuide.FONT_FACE_BOLD;
         myLabel.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         myLabel.alignment = TextStyle.HALIGN_LEFT;
         myLabel.alignmentVertical = TextStyle.VALIGN_TOP;
         myLabel.alpha = UNFOCUS_ALPHA;
         mTextFocusColor = GlobalGuide.WHITE;
         mTextUnfocusColor = GlobalGuide.WHITE;
         this.endHighlight();
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var sdpData:SDPSubGroupObj = data as SDPSubGroupObj;
         this.myIcon.gotoAndStop(sdpData.name);
         myLabel.text = sdpData.label;
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         super.setToggled(toggled);
         if(mToggled)
         {
            this.showHighlight();
         }
         else
         {
            this.endHighlight();
         }
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      override public function draw() : void
      {
      }
      
      override protected function showHighlight() : void
      {
         super.showHighlight();
         TweenLite.killTweensOf(this.myIcon);
         TweenLite.killTweensOf(myBackground);
         TweenLite.killTweensOf(myLabel);
         TweenLite.to(this.myIcon,SLIDE_DURATION,{"x":-3});
         TweenLite.to(myBackground,SLIDE_DURATION,{"x":-3});
         TweenLite.to(myLabel,SLIDE_DURATION,{
            "x":13,
            "alpha":1
         });
      }
      
      override protected function endHighlight() : void
      {
         super.endHighlight();
         TweenLite.killTweensOf(this.myIcon);
         TweenLite.killTweensOf(myBackground);
         TweenLite.killTweensOf(myLabel);
         TweenLite.to(this.myIcon,SLIDE_DURATION,{"x":0});
         TweenLite.to(myBackground,SLIDE_DURATION,{"x":0});
         TweenLite.to(myLabel,SLIDE_DURATION,{
            "x":16,
            "alpha":UNFOCUS_ALPHA
         });
      }
   }
}

