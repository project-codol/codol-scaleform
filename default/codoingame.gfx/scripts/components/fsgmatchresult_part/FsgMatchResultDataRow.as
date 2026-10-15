package components.fsgmatchresult_part
{
   import codo.component.PlayerName;
   import codo.objects.PlayerNameSettings;
   import codo.objects.ScoreboardRowObj;
   import codo.style.GlobalGuide;
   
   public class FsgMatchResultDataRow extends MatchDataRow
   {
      
      protected var dwUserId:String = "";
      
      public var myPlayerName:PlayerName;
      
      private var mPlayerSetting:PlayerNameSettings;
      
      public function FsgMatchResultDataRow()
      {
         super();
      }
      
      override public function SetData(data:ScoreboardRowObj, orderedKeys:Array) : void
      {
         super.SetData(data,orderedKeys);
         this.dwUserId = data.dwUserId != null ? data.dwUserId : "0";
         var showTeamTag:Boolean = data.partyIndex > 0;
         this.myPlayerName.setData(data.player,data.dwUserId,null,showTeamTag);
      }
      
      override public function SetColumnWidths(orderedWidths:Array) : void
      {
         super.SetColumnWidths(orderedWidths);
         if(orderedWidths.length >= 2)
         {
            this.mPlayerSetting.textWidth = orderedWidths[1] - 5;
            this.myPlayerName.settings = this.mPlayerSetting;
            this.myPlayerName.x = this["myData1"].x;
            this["myData1"].visible = false;
         }
      }
      
      override public function ClearData() : void
      {
         super.ClearData();
         this.dwUserId = "";
         if(null == this.mPlayerSetting)
         {
            this.mPlayerSetting = new PlayerNameSettings();
            this.mPlayerSetting.mode = PlayerNameSettings.MODE_DIRECT;
            this.mPlayerSetting.fontSize = 18;
            this.mPlayerSetting.textWidth = 200;
            this.mPlayerSetting.textHeight = 25;
            this.mPlayerSetting.textColor = GlobalGuide.WHITE;
            this.mPlayerSetting.fitSizeMethod = PlayerNameSettings.FIT_SIZE_METHOD_SMALL_FONT;
            this.myPlayerName.settings = this.mPlayerSetting;
         }
         this.myPlayerName.setData("","");
      }
      
      override public function set isMe(value:Boolean) : void
      {
         super.isMe = value;
      }
   }
}

