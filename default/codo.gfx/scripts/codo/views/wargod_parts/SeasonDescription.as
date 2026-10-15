package codo.views.wargod_parts
{
   import codo.component.TextField;
   import codo.localization.DictWarGod;
   import codo.objects.WarGodGlobalSettingObj;
   import codo.objects.WarGodPlayerObj;
   import codo.objects.WarGodSeasonObj;
   import codo.style.WarGodGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   
   public class SeasonDescription extends MovieClip implements IWarGodUIElement
   {
      
      public var myStateLabel:TextField;
      
      public var myDetailDesc:TextField;
      
      public function SeasonDescription()
      {
         super();
         this.myStateLabel.textStyle = WarGodGuide.styleStateLabel;
         this.myStateLabel.width = 204;
         this.myStateLabel.height = 24;
         this.myStateLabel.x = 17;
         this.myStateLabel.y = 17;
         this.myDetailDesc.textStyle = WarGodGuide.styleDetailDesc;
         this.myDetailDesc.alpha = 0.7;
         this.myDetailDesc.width = 1200;
         this.myDetailDesc.height = 75;
         this.myDetailDesc.x = 17;
         this.myDetailDesc.y = 47;
         this.myStateLabel.text = DictWarGod.WARGOD_SEASON_DESC_LABEL;
      }
      
      public function setData(seasonObj:WarGodSeasonObj, playerObj:WarGodPlayerObj, globalSetting:WarGodGlobalSettingObj) : void
      {
         if(WarGodUtility.isJuniorWarGod(playerObj))
         {
            this.myStateLabel.text = DictWarGod.JUNIOR_WARGOD_DESCRIPTION_LABEL;
            this.myDetailDesc.text = DictWarGod.JUNIOR_WARGOD_DESCRIPTION_CONTENT;
         }
         else
         {
            this.myStateLabel.text = LocalizeUtil.param(DictWarGod.SENIOR_WARGOD_DESCRIPTION_LABEL,[seasonObj.name]);
            this.myDetailDesc.text = DictWarGod.SENIOR_WARGOD_DESCRIPTION_CONTENT;
         }
      }
   }
}

