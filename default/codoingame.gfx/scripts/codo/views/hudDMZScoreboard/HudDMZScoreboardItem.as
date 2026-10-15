package codo.views.hudDMZScoreboard
{
   import codo.component.playerAccount.PlayerAccountInfoPrivileges;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   import fsg.util.FsgUtil;
   
   public class HudDMZScoreboardItem extends MovieClip
   {
      
      public var myPlacement:TextField;
      
      public var myPlayerName:TextField;
      
      public var myEliminations:TextField;
      
      public var myGear:TextField;
      
      public var myRankIcon:FsgImageHolder;
      
      public var myState:PlayerAccountInfoPrivileges;
      
      public var myPing:TextField;
      
      public var myBorder:MovieClip;
      
      public function HudDMZScoreboardItem()
      {
         super();
         this.myPlacement.text = "--";
         this.myPlayerName.text = "";
         this.myEliminations.text = "0";
         this.myGear.text = "0";
         this.myPing.text = "0";
      }
      
      public function cppSetRank(level:int) : void
      {
         this.myRankIcon.setImage(FsgUtil.getRankIcon(level));
      }
      
      public function cppSetState(qqMembership:int, netCafePrivileges:int) : void
      {
         this.myState.showPlayerPrivileges(qqMembership,netCafePrivileges);
      }
      
      public function cppSetPlayerName(name:String) : void
      {
         this.myPlayerName.text = name;
         StringUtil.fitTextField(this.myPlayerName);
      }
   }
}

