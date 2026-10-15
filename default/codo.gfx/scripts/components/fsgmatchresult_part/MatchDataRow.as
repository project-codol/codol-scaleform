package components.fsgmatchresult_part
{
   import codo.constants.ScoreboardColumnData;
   import codo.localization.DictInGame;
   import codo.objects.ScoreboardRowObj;
   import codo.services.InGameService;
   import codo.utils.ClashPvpUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.PrivilegeUtil;
   import codo.utils.StringUtil;
   import codo.utils.WarGodUtility;
   import codo.views.wargod_parts.TierMeter;
   import components.fsgmatchresult_part.panels.FsgMatchResultScoreboardPopupPanel;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import fsg.shared.ToolTipItem;
   import fsg.util.FsgImageHolder;
   import fsg.util.FsgUtil;
   
   public class MatchDataRow extends MovieClip
   {
      
      protected static const HIGHLIGHTED_TEXT_ALPHA:Number = 1;
      
      protected static const UNHIGHLIGHTED_TEXT_ALPHA:Number = 1;
      
      public static const DEFAULT_HEIGHT:int = 34;
      
      private static const NETCAFE_TIP_OFFSET:Point = new Point(-40,-15);
      
      private static const ICON_PADDING:Number = 4;
      
      private static const WARGOD_ICON_JUNIOR:int = 1;
      
      private static const WARGOD_ICON_SENIOR:int = 2;
      
      private static const WARGOD_ICON_UNDEFINED:int = 3;
      
      public var myHighlight:MovieClip;
      
      public var myRankIcon:FsgImageHolder;
      
      public var myVIPImage:ToolTipItem;
      
      public var myBlueDiamondImage:ToolTipItem;
      
      public var myNetCafeImage:ToolTipItem;
      
      public var myTGPImage:ToolTipItem;
      
      public var myRowBackground:MovieClip;
      
      public var myWarGod:TierMeter;
      
      public var myTeamTag:MovieClip;
      
      protected var mIsMe:Boolean = false;
      
      protected var mTeam:int;
      
      public function MatchDataRow()
      {
         super();
         this.ClearData();
      }
      
      public static function GetHeight() : int
      {
         return DEFAULT_HEIGHT;
      }
      
      public function ClearData() : void
      {
         for(var i:int = 0; i < ScoreboardColumnData.MAX_COLUMNS; i++)
         {
            this["myData" + String(i)].text = "";
         }
         this.myHighlight.visible = false;
         this.myRankIcon.visible = false;
         this.myVIPImage.visible = false;
         this.myBlueDiamondImage.visible = false;
         this.myNetCafeImage.visible = false;
      }
      
      public function SetData(data:ScoreboardRowObj, orderedKeys:Array) : void
      {
         var columnText:TextField = null;
         var lastIndexOf:int = 0;
         var timeSeconds:int = 0;
         var timeMinutes:int = 0;
         var secondsStr:String = null;
         var icons:Array = null;
         var curX:Number = NaN;
         var iconIndex:int = 0;
         this.isMe = data.isSelf;
         this.rank = data.rank;
         this.qq_membership = data.qq_membership;
         this.netcafe = data.netcafe;
         this.wargod = data.wargod;
         this.myWarGod.visible = false;
         var key:String = "";
         var dataAtKey:String = "";
         for(var i:int = 0; i < ScoreboardColumnData.MAX_COLUMNS; i++)
         {
            key = orderedKeys[i];
            columnText = this["myData" + String(i)];
            columnText.mouseEnabled = false;
            if(Boolean(key) && data.hasOwnProperty(key))
            {
               dataAtKey = data[key];
               if(key == ScoreboardColumnData.KEY_PLAYER && dataAtKey.indexOf("[") == 0)
               {
                  lastIndexOf = dataAtKey.lastIndexOf("]");
                  dataAtKey = dataAtKey.substring(lastIndexOf + 2);
               }
               else if(key == ScoreboardColumnData.KEY_OBJECTIVE2 && (InGameService.getInstance().getGameType() == "infect" || InGameService.getInstance().getGameType() == "borg"))
               {
                  timeSeconds = int(dataAtKey);
                  timeMinutes = Math.floor(timeSeconds / 60);
                  secondsStr = "00" + String(timeSeconds % 60);
                  dataAtKey = String(timeMinutes) + ":" + secondsStr.substring(secondsStr.length - 2,secondsStr.length);
               }
               columnText.text = dataAtKey;
               if(key == ScoreboardColumnData.KEY_CLANNAME)
               {
                  StringUtil.fitTextFieldByLength(columnText,columnText.width - 9);
               }
               else if(key == ScoreboardColumnData.KEY_PLAYER)
               {
                  if(data.gametype == ClashPvpUtil.MODE_ID && data.killStreak >= 3)
                  {
                     columnText.text = LocalizeUtil.localize(DictInGame.CLASH_BUTCHER_TAG) + columnText.text;
                  }
                  if(data.partyIndex != 0)
                  {
                     StringUtil.fitTextFieldByLength(columnText,columnText.width - 60);
                     this.myTeamTag.visible = true;
                     this.myTeamTag.gotoAndStop(data.team + 1);
                     this.myTeamTag["myText"].text = LocalizeUtil.param(DictInGame.SCOREBOARD_TEAM_TAG,[data.partyIndex]);
                  }
                  else
                  {
                     this.myTeamTag.visible = false;
                  }
               }
            }
            else
            {
               columnText.text = "";
               if(key == ScoreboardColumnData.KEY_LEVEL)
               {
                  this.myRankIcon.x = columnText.x;
               }
               else if(key == ScoreboardColumnData.KEY_BUFFS)
               {
                  icons = [this.myTGPImage,this.myVIPImage,this.myBlueDiamondImage,this.myNetCafeImage];
                  curX = columnText.x;
                  for(iconIndex = 0; iconIndex < icons.length; iconIndex++)
                  {
                     if(null != icons[iconIndex] && Boolean(icons[iconIndex].visible))
                     {
                        icons[iconIndex].x = curX;
                        curX += icons[iconIndex].width + ICON_PADDING;
                     }
                  }
               }
               else if(key == ScoreboardColumnData.KEY_WARGOD)
               {
                  this.myWarGod.visible = true;
                  this.myWarGod.x = columnText.x;
               }
            }
         }
      }
      
      public function SetColumnWidths(orderedWidths:Array) : void
      {
         var columnText:TextField = null;
         var xPos:Number = 9;
         for(var i:int = 0; i < ScoreboardColumnData.MAX_COLUMNS; i++)
         {
            columnText = this["myData" + String(i)];
            if(Boolean(orderedWidths[i]) && Boolean(columnText))
            {
               columnText.width = orderedWidths[i];
               columnText.x = xPos;
               xPos += columnText.width;
            }
         }
      }
      
      public function set TeamColor(team:String) : void
      {
         if(!this.myRowBackground)
         {
            return;
         }
         this.myRowBackground.gotoAndStop(team);
      }
      
      public function set isMe(value:Boolean) : void
      {
         var i:int = 0;
         var j:int = 0;
         this.mIsMe = value;
         this.myHighlight.visible = value;
         if(value == true)
         {
            for(i = 0; i < ScoreboardColumnData.MAX_COLUMNS; i++)
            {
               this["myData" + String(i)].alpha = HIGHLIGHTED_TEXT_ALPHA;
            }
         }
         else
         {
            for(j = 0; j < ScoreboardColumnData.MAX_COLUMNS; j++)
            {
               this["myData" + String(j)].alpha = UNHIGHLIGHTED_TEXT_ALPHA;
            }
         }
      }
      
      public function set level(value:String) : void
      {
         var tempA:Array = value.split("|");
         var realLevel:int = parseInt(tempA[0]) - 1;
         var prestige:int = parseInt(tempA[1]);
         this.myRankIcon.setImage(FsgUtil.getRankIcon(realLevel,prestige));
         this.myRankIcon.visible = true;
      }
      
      public function set rank(value:int) : void
      {
         if(value == 1 && this.mIsMe == false && this.mTeam == FsgMatchResultScoreboardPopupPanel.NO_TEAM)
         {
            this.myHighlight.visible = false;
         }
      }
      
      public function set qq_membership(privileges:int) : void
      {
         PrivilegeUtil.showQQMembership(privileges,this.myVIPImage,this.myBlueDiamondImage,this.myTGPImage);
      }
      
      public function set netcafe(privileges:int) : void
      {
         PrivilegeUtil.showNetCafePrivileges(privileges,this.myNetCafeImage,this.mIsMe);
         this.myNetCafeImage.tipOffset = NETCAFE_TIP_OFFSET;
      }
      
      public function set wargod(score:int) : void
      {
         var playerRankObj:Object = WarGodUtility.getPlayerWarGodRankByScore(score);
         if(playerRankObj == null)
         {
            this.myWarGod.alpha = 0;
         }
         else
         {
            this.myWarGod.alpha = 1;
            this.myWarGod.setData(playerRankObj.tier);
         }
      }
   }
}

