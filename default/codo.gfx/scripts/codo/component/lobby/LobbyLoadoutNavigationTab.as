package codo.component.lobby
{
   import codo.component.Button;
   import codo.style.GlobalGuide;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   
   public class LobbyLoadoutNavigationTab extends Button
   {
      
      private static const FADE_DURATION:Number = 0.25;
      
      public var myGlow:Sprite;
      
      public function LobbyLoadoutNavigationTab()
      {
         super();
         mTextUnfocusColor = GlobalGuide.WHITE;
         mTextFocusColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         myLabel.font = GlobalGuide.FONT_FACE_BOLD;
         myLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         myLabel.fontColor = mTextUnfocusColor;
         myLabel.width = myHitArea.width;
         myLabel.height = myHitArea.height;
         this.myGlow.alpha = 0;
      }
      
      override public function setToggled(toggled:Boolean) : void
      {
         super.setToggled(toggled);
         if(mToggled)
         {
            TweenLite.killTweensOf(this.myGlow);
            TweenLite.to(this.myGlow,FADE_DURATION,{"alpha":1});
         }
         else
         {
            TweenLite.killTweensOf(this.myGlow);
            TweenLite.to(this.myGlow,FADE_DURATION,{"alpha":0});
         }
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         if(false == mToggled)
         {
            TweenLite.killTweensOf(this.myGlow);
            TweenLite.to(this.myGlow,FADE_DURATION,{"alpha":1});
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         if(false == mToggled)
         {
            TweenLite.killTweensOf(this.myGlow);
            TweenLite.to(this.myGlow,FADE_DURATION,{"alpha":0});
         }
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      override public function draw() : void
      {
      }
   }
}

