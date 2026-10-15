package codo.component
{
   import codo.common.CFunctionCommonContainer;
   import codo.localization.Dict;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class ItemLevelDisplay extends MovieClip
   {
      
      public var myTierColor:MovieClip;
      
      public var myLevel:TextField;
      
      public var myLevelLabel:TextField;
      
      public var myBackground:Sprite;
      
      private var mLevel:int = 0;
      
      private var mTier:int = 0;
      
      public function ItemLevelDisplay()
      {
         var labelStyle:TextStyle = null;
         super();
         var headerStyle:TextStyle = new TextStyle();
         headerStyle.font = GlobalGuide.FONT_FACE_NUMBERS;
         headerStyle.fontColor = GlobalGuide.CODO_GRAY_DARK;
         headerStyle.fontSize = GlobalGuide.FONT_SIZE_HUGE;
         this.myLevel.textStyle = headerStyle;
         this.myLevel.alignment = TextStyle.HALIGN_CENTER;
         labelStyle = GlobalGuide.styleTextSmall;
         labelStyle.alignment = TextStyle.HALIGN_CENTER;
         labelStyle.fontColor = GlobalGuide.CODO_GRAY_DARK;
         this.myLevelLabel.textStyle = labelStyle;
         this.myLevelLabel.text = LocalizeUtil.localize(Dict.WEAPONLOADOUT_WEAPON_LEVEL);
         this.myLevelLabel.x = 51 - this.myLevelLabel.textWidth * 0.5;
      }
      
      public function hideLabel() : void
      {
         this.myLevelLabel.visible = false;
         this.myLevel.y = 17;
      }
      
      public function set tier(t:int) : void
      {
         this.mTier = t;
         this.myTierColor.gotoAndStop(this.mTier + 1);
      }
      
      public function get tier() : int
      {
         return this.mTier;
      }
      
      public function set level(l:int) : void
      {
         this.mLevel = l;
         this.myLevel.text = CFunctionCommonContainer.GetDisplayLevel(l);
         this.myLevel.x = 51 - this.myLevel.textWidth * 0.5;
      }
      
      public function get level() : int
      {
         return this.mLevel;
      }
   }
}

