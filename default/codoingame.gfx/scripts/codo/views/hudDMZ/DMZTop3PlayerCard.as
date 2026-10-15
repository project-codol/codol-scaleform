package codo.views.hudDMZ
{
   import codo.common.CFunctionCommonContainer;
   import codo.component.PlayerCard;
   import codo.localization.DictDmz;
   import codo.objects.UserObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import fsg.util.FsgUtil;
   
   public class DMZTop3PlayerCard extends MovieClip
   {
      
      public var myMatchScoreLabel:TextField;
      
      public var myPlayerCard:PlayerCard;
      
      public var myScore:TextField;
      
      public var myKill:TextField;
      
      public var myDamage:TextField;
      
      public function DMZTop3PlayerCard()
      {
         super();
         this.myMatchScoreLabel.visible = false;
         this.myScore.visible = false;
      }
      
      public function setData(data:UserObj) : void
      {
         this.truncateName(data.name);
         this.myPlayerCard.setClanName(data.clanName);
         var prestigeLvl:uint = uint(data.prestige);
         this.myPlayerCard.setPrestige(prestigeLvl == 0 ? "" : prestigeLvl.toString());
         this.myPlayerCard.setRank(CFunctionCommonContainer.GetDisplayLevel(data.level));
         this.myPlayerCard.setTitle(LocalizeUtil.localize("@" + data.callSignObj.cardTitle));
         this.myPlayerCard.setEmblem(data.callSignObj.cardIconURL);
         this.myPlayerCard.setBackground(data.callSignObj.cardBackgroundURL);
         this.myPlayerCard.setNameplate(data.callSignObj.cardNameplateColor);
         this.myPlayerCard.setFrame(data.callSignObj.cardFrameURL);
         if(data.prestige > 0)
         {
            this.myPlayerCard.setPrestigeIcon(FsgUtil.getPrestigeIcon(data.prestige));
         }
         else
         {
            this.myPlayerCard.setPrestigeIcon("");
         }
         var damage:String = (data.damage as int).toString();
         var kills:String = (data.kills as int).toString();
         var killLabelText:String = LocalizeUtil.param(DictDmz.NUM_KILLS,[kills]);
         this.myKill.text = killLabelText;
         var format:TextFormat = this.myKill.getTextFormat();
         format.font = GlobalGuide.FONT_FACE_NUMBERS;
         format.size = 60;
         format.bold = true;
         var index:int = killLabelText.indexOf(kills);
         this.myKill.setTextFormat(format,index,index + kills.length);
         var damageLabelText:String = LocalizeUtil.param(DictDmz.DAMAGE_MADE,[damage]);
         this.myDamage.text = damageLabelText;
         format = this.myDamage.getTextFormat();
         format.font = GlobalGuide.FONT_FACE_NUMBERS;
         format.size = 24;
         format.bold = true;
         index = damageLabelText.indexOf(damage);
         this.myDamage.setTextFormat(format,index,index + damage.length);
      }
      
      private function truncateName(txt:String) : void
      {
         this.myPlayerCard.setName(txt);
         var offset:int = 4;
         if(this.myPlayerCard.myName.textWidth > this.myPlayerCard.myName.width - offset)
         {
            while(this.myPlayerCard.myName.textWidth > this.myPlayerCard.myName.width)
            {
               txt = txt.substring(0,txt.length - 1);
               this.myPlayerCard.setName(txt + "...");
            }
         }
      }
   }
}

