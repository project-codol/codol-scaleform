package components.list_part
{
   import codo.localization.Dict;
   import codo.localization.DictInGame;
   import codo.objects.ScoreboardObj;
   import codo.objects.ScoreboardRowObj;
   import codo.utils.ClashPvpUtil;
   import codo.utils.LocalizeUtil;
   import codo.utils.Logger;
   import components.CodoList;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class HudScoreboardItemRenderer extends ListItemRendererBase
   {
      
      public static const STYLE_BLUE:uint = 1;
      
      public static const STYLE_RED:uint = 2;
      
      public static const STYLE_NOTEAM:uint = 3;
      
      protected static const FIELD_RANK:int = 0;
      
      protected static const FIELD_PLAYER:int = 1;
      
      protected static const FIELD_SCORE:int = 2;
      
      protected static const FIELD_KILLS:int = 3;
      
      protected static const FIELD_DEATHS:int = 4;
      
      protected static const FIELD_ASSISTS:int = 5;
      
      protected static const FIELD_OBJECTIVES_OR_HEADSHOTS:int = 6;
      
      protected static const FIELD_PING:int = 7;
      
      protected static const FIELD_RANK_NO_LVL:int = 8;
      
      protected static const FIELD_REVIVES:int = 9;
      
      protected static const FIELD_DOWNS:int = 10;
      
      public static const FIELDS_MP:Vector.<int> = new <int>[FIELD_RANK,FIELD_PLAYER,FIELD_SCORE,FIELD_KILLS,FIELD_DEATHS,FIELD_ASSISTS,FIELD_OBJECTIVES_OR_HEADSHOTS,FIELD_PING];
      
      public static const FIELDS_COOP:Vector.<int> = new <int>[FIELD_RANK,FIELD_PLAYER,FIELD_SCORE,FIELD_KILLS,FIELD_DEATHS,FIELD_OBJECTIVES_OR_HEADSHOTS];
      
      public static const FIELDS_ZM:Vector.<int> = new <int>[FIELD_RANK_NO_LVL,FIELD_PLAYER,FIELD_KILLS,FIELD_OBJECTIVES_OR_HEADSHOTS,FIELD_REVIVES,FIELD_DOWNS,FIELD_PING];
      
      protected static const MAX_COLUMNS:int = 8;
      
      public var mySepTop:Sprite;
      
      public var mySepBot:Sprite;
      
      public var mySepTopRed:Sprite;
      
      public var mySepBotRed:Sprite;
      
      public var mySepTopSelf:Sprite;
      
      public var mySepBotSelf:Sprite;
      
      public var myColumns:Sprite;
      
      public var myDeathIconBkg:Sprite;
      
      public var myDeathIcon:Sprite;
      
      protected var _mvpIcon:Sprite;
      
      protected var _textColor:uint;
      
      protected var _columns:Vector.<TextField>;
      
      protected var _currentGameType:String;
      
      public function HudScoreboardItemRenderer()
      {
         var column:TextField = null;
         super();
         this._mvpIcon = this.myColumns["mvp"];
         this._columns = new Vector.<TextField>();
         for(var i:int = 0; i < MAX_COLUMNS; i++)
         {
            column = this.myColumns["col" + String(i)] as TextField;
            if(column == null)
            {
               break;
            }
            this._columns.push(column);
         }
         this._textColor = this._columns[0].textColor;
      }
      
      private static function GetFields(gametype:String) : Vector.<int>
      {
         if(gametype == "coop")
         {
            return FIELDS_COOP;
         }
         if(gametype == "zm")
         {
            return FIELDS_ZM;
         }
         return FIELDS_MP;
      }
      
      private function GetHeader(field:int, data:ScoreboardObj) : String
      {
         var objectivesMap:Object = null;
         var objectives:String = null;
         switch(field)
         {
            case FIELD_RANK:
            case FIELD_RANK_NO_LVL:
               if(this._currentGameType == "zm")
               {
                  return "";
               }
               return DictInGame.ScoreboardRank;
               break;
            case FIELD_PLAYER:
               return DictInGame.ScoreboardName;
            case FIELD_SCORE:
               return DictInGame.ScoreboardScore;
            case FIELD_KILLS:
               return DictInGame.ScoreboardKills;
            case FIELD_DEATHS:
               return DictInGame.ScoreboardDeaths;
            case FIELD_DOWNS:
               return DictInGame.ScoreboardDowns;
            case FIELD_ASSISTS:
               return DictInGame.ScoreboardAssists;
            case FIELD_OBJECTIVES_OR_HEADSHOTS:
               objectivesMap = {
                  "sd":DictInGame.ScoreboardObjectivesSD,
                  "dd":DictInGame.ScoreboardObjectivesDD,
                  "sab":DictInGame.ScoreboardObjectivesSAB,
                  "dom":DictInGame.ScoreboardObjectivesDOM,
                  "ctf":DictInGame.ScoreboardObjectivesCTF,
                  "koth":DictInGame.ScoreboardObjectivesKOTH,
                  "conf":DictInGame.ScoreboardObjectivesCONF,
                  "vip":DictInGame.ScoreboardObjectivesVIP
               };
               objectives = objectivesMap[data.gametype];
               if(data.gametype == ClashPvpUtil.MODE_ID && ClashPvpUtil.isClashCTF())
               {
                  objectives = DictInGame.ScoreboardObjectivesCTF;
               }
               if(objectives == null)
               {
                  objectives = DictInGame.ScoreboardHeadshots;
               }
               return objectives;
            case FIELD_PING:
               return DictInGame.ScoreboardPing;
            case FIELD_REVIVES:
               return Dict.CYBORG_STAT_REVIVES;
            default:
               Logger.print("GetHeader bad field " + String(field));
               return null;
         }
      }
      
      private function GetValue(field:int, row:ScoreboardRowObj) : String
      {
         var lvlStr:String = null;
         var rankStr:String = null;
         switch(field)
         {
            case FIELD_RANK:
               lvlStr = LocalizeUtil.param(DictInGame.ScoreboardLevelNum,[String(row.level)]);
               rankStr = String(row.rank) + "   ";
               if(row.rank < 10)
               {
                  rankStr += "  ";
               }
               return rankStr + lvlStr;
            case FIELD_RANK_NO_LVL:
               return String(row.rank);
            case FIELD_PLAYER:
               return row.player;
            case FIELD_SCORE:
               return String(row.score);
            case FIELD_KILLS:
               return String(row.kills);
            case FIELD_DOWNS:
            case FIELD_DEATHS:
               return String(row.deaths);
            case FIELD_ASSISTS:
               return String(row.assists);
            case FIELD_OBJECTIVES_OR_HEADSHOTS:
               return String(row.objectives);
            case FIELD_PING:
               return String(row.ping);
            case FIELD_REVIVES:
               return String(row.revives);
            default:
               Logger.print("GetValue bad field " + String(field));
               return null;
         }
      }
      
      public function InitHeader(data:ScoreboardObj) : void
      {
         var header:String = null;
         var standardFormat:TextFormat = null;
         this.mySepTop.visible = this.mySepBot.visible = false;
         this.mySepTopRed.visible = this.mySepBotRed.visible = false;
         this.mySepTopSelf.visible = this.mySepBotSelf.visible = false;
         if(Boolean(this._mvpIcon))
         {
            this._mvpIcon.visible = false;
         }
         this.SetDeathIconVisible(false,false);
         this._currentGameType = data.gametype;
         var fields:Vector.<int> = GetFields(data.gametype);
         for(var i:int = 0; i < this._columns.length; i++)
         {
            header = null;
            if(i < fields.length)
            {
               header = this.GetHeader(fields[i],data);
               if(fields[i] == FIELD_PLAYER)
               {
                  standardFormat = this._columns[0].getTextFormat();
                  this._columns[i].setTextFormat(standardFormat);
               }
            }
            this.SetColumn(i,header);
         }
      }
      
      override protected function onGetData() : void
      {
         var value:String = null;
         super.onGetData();
         var row:ScoreboardRowObj = new ScoreboardRowObj(this._data);
         this._data = row;
         var fields:Vector.<int> = GetFields(row.gametype);
         var textColor:uint = row.isSelf ? this.GetSelfTextColor() : this._textColor;
         for(var i:int = 0; i < this._columns.length; i++)
         {
            value = null;
            if(i < fields.length)
            {
               value = this.GetValue(fields[i],row);
               this._columns[i].textColor = textColor;
            }
            if(fields[i] == FIELD_DEATHS)
            {
               if(row.isDeathInvisible == false)
               {
                  this.SetColumn(i,"--/--");
               }
               else
               {
                  this.SetColumn(i,value);
               }
            }
            else
            {
               this.SetColumn(i,value);
            }
         }
         if(Boolean(this._mvpIcon))
         {
            this._mvpIcon.visible = row.rank == 1;
         }
         this.SetDeathIconVisible(row.isDead,true);
         this.onStyleChanged();
      }
      
      protected function GetSelfTextColor() : uint
      {
         return 11322393;
      }
      
      private function SetDeathIconVisible(iconVis:Boolean, bkgVis:Boolean) : void
      {
         if(Boolean(this.myDeathIcon))
         {
            this.myDeathIcon.visible = iconVis;
         }
         if(Boolean(this.myDeathIconBkg))
         {
            this.myDeathIconBkg.visible = bkgVis;
         }
      }
      
      protected function SetColumn(col:int, value:String) : void
      {
         if(this._currentGameType == "zm" && col == 0)
         {
            value = "";
         }
         if(value == null)
         {
            value = "";
         }
         this._columns[col].text = value;
      }
      
      override public function set positionIndex(cPos:int) : void
      {
         super.positionIndex = cPos;
         this.onStyleChanged();
      }
      
      override protected function onStyleChanged() : void
      {
         var next:ScoreboardRowObj = null;
         super.onStyleChanged();
         if(this._data != null && ScoreboardRowObj(this._data).isSelf)
         {
            this.mySepTopSelf.visible = this.mySepBotSelf.visible = true;
            this.mySepTopRed.visible = this.mySepTop.visible = this.mySepBotRed.visible = this.mySepBot.visible = false;
            return;
         }
         this.mySepTopSelf.visible = this.mySepBotSelf.visible = false;
         this.mySepTop.visible = this.mySepBot.visible = this._styleID == STYLE_BLUE || this._styleID == STYLE_NOTEAM;
         this.mySepTopRed.visible = this.mySepBotRed.visible = this._styleID == STYLE_RED;
         if(this._positionIndex != 0)
         {
            this.mySepTop.visible = this.mySepTopRed.visible = false;
         }
         var list:CodoList = this.parent as CodoList;
         if(list.dataProvider.length > index + 1)
         {
            next = new ScoreboardRowObj(list.dataProvider[index + 1]);
            if(next.isSelf)
            {
               this.mySepBot.visible = this.mySepBotRed.visible = false;
            }
         }
      }
   }
}

