package codo.component.social
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.TextField;
   import codo.localization.DictCareer;
   import codo.style.SocialGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import fsg.util.FsgUtil;
   
   public class LevelWidget extends MovieClip
   {
      
      public var myNote:TextField;
      
      public var myRankIcon:MemberRankIcon;
      
      public var myRankName:TextField;
      
      public function LevelWidget()
      {
         super();
         this.myRankName.textStyle = SocialGuide.styleLevelWidget;
         this.myRankName.width = 75;
         this.myNote.textStyle = SocialGuide.styleLevelPending;
         this.myNote.width = 200;
         this.myNote.text = "@SF_UI_PENDING";
      }
      
      public function setRank(level:int, prestige:int = 0) : void
      {
         if(level >= 0)
         {
            this.myRankIcon.setImage(FsgUtil.getRankIcon(level,prestige));
            this.myRankName.text = (level + 1).toString();
            this.myRankIcon.visible = this.myRankName.visible = true;
            this.myNote.visible = false;
         }
         else
         {
            this.myRankIcon.visible = this.myRankName.visible = false;
            this.myNote.visible = true;
         }
      }
      
      protected function formatRank(prestige:int, level:int) : String
      {
         if(level < 0)
         {
            level = 0;
         }
         var levelStr:String = CFunctionCommonContainer.GetDisplayLevel(level);
         if(prestige == 0)
         {
            return LocalizeUtil.param(DictCareer.CAREER_X_LEVEL,[levelStr]);
         }
         return LocalizeUtil.param(DictCareer.CAREER_X_PRESTIGE,[String(prestige),levelStr]);
      }
      
      public function setTextStyle(style:TextStyle) : void
      {
         this.myRankName.textStyle = style;
         this.myNote.textStyle = style;
      }
   }
}

