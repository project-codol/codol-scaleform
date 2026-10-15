package codo.component
{
   import codo.localization.Dict;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ExperienceBar extends MovieClip
   {
      
      private static const TEXT_WIDTH:Number = 200;
      
      public var myFill:MovieClip;
      
      public var myFillCap:Sprite;
      
      public var myBackground:Sprite;
      
      public var myXPValue:TextField;
      
      public function ExperienceBar()
      {
         super();
         this.myXPValue.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myXPValue.alignment = TextStyle.HALIGN_RIGHT;
         this.myXPValue.width = TEXT_WIDTH;
      }
      
      public function setProgress(p:Number) : void
      {
         this.myFill.width = this.myBackground.width * p;
         this.myFillCap.x = this.myFill.x + this.myFill.width - this.myFillCap.width;
      }
      
      public function setExperiencePoints(current:Number, max:Number) : void
      {
         this.myXPValue.text = current.toString() + " / " + max.toString() + LocalizeUtil.localize(Dict.XP);
      }
      
      public function setTier(t:int) : void
      {
         this.myFill.gotoAndStop(t + 1);
      }
   }
}

