package components.scoreboard_part
{
   import codo.localization.Dict;
   import codo.objects.ScoreboardObj;
   import components.CodoList;
   import components.list_part.HudScoreboardItemRenderer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import shaui.component.core.UIComponent;
   
   public class ScoreboardTeamPanel extends UIComponent
   {
      
      public var myScoreTF:TextField;
      
      public var myNameTF:TextField;
      
      public var myList:CodoList;
      
      public var myTeamBlue:Sprite;
      
      public var myTeamRed:Sprite;
      
      public var myBkg:Sprite;
      
      public var myCellPattern:Sprite;
      
      private var _style:uint;
      
      public function ScoreboardTeamPanel()
      {
         super();
      }
      
      public function SetStyle(style:uint) : void
      {
         this._style = style;
         this.myList.addEventListener(Event.ADDED_TO_STAGE,this.InitList);
         if(!this.IsCyborgsAsset())
         {
            if(style == HudScoreboardItemRenderer.STYLE_BLUE)
            {
               this.myTeamBlue.visible = true;
               this.myTeamRed.visible = false;
               this.SetScoreDisplay(Dict.FORCE_TF,11725298);
            }
            else if(style == HudScoreboardItemRenderer.STYLE_RED)
            {
               this.myTeamBlue.visible = false;
               this.myTeamRed.visible = true;
               this.SetScoreDisplay(Dict.FORCE_SC,16435143);
            }
            else if(style == HudScoreboardItemRenderer.STYLE_NOTEAM)
            {
               this.myTeamBlue.visible = false;
               this.myTeamRed.visible = false;
               this.SetScoreDisplay("",11725298);
            }
         }
      }
      
      private function InitList(event:Event) : void
      {
         this.myList.removeEventListener(Event.ADDED_TO_STAGE,this.InitList);
         this.myList.setStyle(this._style);
      }
      
      public function AdjustHeight(delta:Number) : void
      {
         if(this.myBkg == null)
         {
            return;
         }
         if(Boolean(this.myBkg))
         {
            this.myBkg.height += delta;
         }
         if(Boolean(this.myCellPattern))
         {
            this.myCellPattern.height += delta;
         }
         if(delta > 0)
         {
            delta *= 0.5;
         }
         if(Boolean(this.myScoreTF))
         {
            this.myScoreTF.y += delta;
         }
         this.AdjustImg(this.myTeamBlue,delta);
         this.AdjustImg(this.myTeamRed,delta);
      }
      
      private function AdjustImg(sprite:Sprite, delta:Number) : void
      {
         var img:Sprite = sprite["myImg"];
         if(Boolean(img))
         {
            if(delta > 0)
            {
               img.y += delta;
            }
            else
            {
               sprite.visible = false;
            }
         }
      }
      
      public function SetScoreboardData(data:ScoreboardObj) : void
      {
         var score:int = 0;
         var players:Array = null;
         var mode:String = null;
         if(this._style == HudScoreboardItemRenderer.STYLE_BLUE || this._style == HudScoreboardItemRenderer.STYLE_NOTEAM)
         {
            score = data.alliesScore;
            players = data.alliesPlayers;
         }
         else if(this._style == HudScoreboardItemRenderer.STYLE_RED)
         {
            score = data.axisScore;
            players = data.axisPlayers;
         }
         if(Boolean(this.myScoreTF))
         {
            this.myScoreTF.text = String(score);
            mode = data.gametype;
            this.myScoreTF.visible = mode != "coop" && mode != "zm" && mode != "dm" && mode != "infect" && mode != "borg";
         }
         this.myList.dataProvider = players;
      }
      
      private function SetScoreDisplay(txt:String, color:uint) : void
      {
         if(!this.myNameTF)
         {
            return;
         }
         this.myNameTF.text = txt;
         this.myScoreTF.textColor = color;
      }
      
      protected function IsCyborgsAsset() : Boolean
      {
         return false;
      }
   }
}

