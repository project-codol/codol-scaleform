package components.scoreboard_part
{
   import codo.localization.DictInGame;
   import codo.utils.LocalizeUtil;
   import flash.text.TextField;
   import shaui.component.core.UIComponent;
   
   public class MatchStatusBar extends UIComponent
   {
      
      public var myMapTF:TextField;
      
      public var myRoundTF:TextField;
      
      public var myTimeTF:TextField;
      
      public function MatchStatusBar()
      {
         super();
      }
      
      public function SetMatchStatus(status:Object) : void
      {
         if(status == null)
         {
            this.myMapTF.text = "";
            this.myRoundTF.text = "";
            this.myTimeTF.text = "";
            return;
         }
         this.myMapTF.text = status.gametype + " - " + status.map;
         this.myRoundTF.text = "";
         if(status.gametypeID == "coop" || status.gametypeID == "zm")
         {
            this.myTimeTF.text = "";
         }
         else
         {
            this.myTimeTF.text = "";
            if(status.gametypeID == "dd" || status.gametypeID == "sd" || status.gametypeID == "sdp" || status.gametypeID == "sdc" || status.gametypeID == "ctf")
            {
               this.myRoundTF.text = LocalizeUtil.param(DictInGame.RoundNum,[String(status.round)]);
            }
         }
      }
   }
}

