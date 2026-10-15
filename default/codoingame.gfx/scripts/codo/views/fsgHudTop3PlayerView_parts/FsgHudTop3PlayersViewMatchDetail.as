package codo.views.fsgHudTop3PlayerView_parts
{
   import codo.common.CFunctionInGameContainer;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class FsgHudTop3PlayersViewMatchDetail extends MovieClip
   {
      
      public var myWeaponIcon:FsgImageHolder;
      
      public var myKillsAndDeaths:FsgHudTop3PlayersViewKillsAndDeaths;
      
      public var myRobberyDetail:FsgHudTop3PlayersViewRobberyDetail;
      
      public function FsgHudTop3PlayersViewMatchDetail()
      {
         super();
      }
      
      public function setData(playerData:Object, gametype:String) : void
      {
         this.myRobberyDetail.visible = this.myWeaponIcon.visible = this.myKillsAndDeaths.visible = false;
         if(gametype == "robbery")
         {
            this.myRobberyDetail.visible = true;
            this.myRobberyDetail.myKillsValue.text = playerData.kills;
            this.myRobberyDetail.myGoldsValue.text = playerData.objective2;
         }
         else
         {
            this.myWeaponIcon.visible = this.myKillsAndDeaths.visible = true;
            this.myKillsAndDeaths.kills = playerData.kills;
            this.myKillsAndDeaths.deaths = playerData.deaths;
            this.myWeaponIcon.setImage(CFunctionInGameContainer.AS_GetTop3SelfCurrentWeaponHudIcon());
            this.myKillsAndDeaths.x = this.myWeaponIcon.x + this.myWeaponIcon.width + 10;
         }
      }
   }
}

