package codo.component.social
{
   import codo.localization.DictClan;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class ClanDetailInfoPanel extends MovieClip
   {
      
      private static const TEXT_PADDING:int = 5;
      
      private static const PANEL_PADDING:int = 15;
      
      public var myClanNameLabel:TextField;
      
      public var myClanIDLabel:TextField;
      
      public var myClanLeaderLabel:TextField;
      
      public var myClanDescriptionLabel:TextField;
      
      public var myClanName:TextField;
      
      public var myClanID:TextField;
      
      public var myClanLeader:TextField;
      
      public var myClanDescription:TextField;
      
      public var myBg:MovieClip;
      
      public function ClanDetailInfoPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.mouseChildren = this.mouseEnabled = false;
         this.myClanName.autoSize = TextFieldAutoSize.LEFT;
         this.myClanID.autoSize = TextFieldAutoSize.LEFT;
         this.myClanLeader.autoSize = TextFieldAutoSize.LEFT;
         this.myClanNameLabel.text = DictClan.CLAN_NAME_LABEL;
         this.myClanIDLabel.text = DictClan.LABEL_CLAN_ID;
         this.myClanLeaderLabel.text = DictClan.LABEL_CLAN_LEADER;
         this.myClanDescriptionLabel.text = DictClan.CLAN_DESCRIPTION;
      }
      
      public function set data(obj:Object) : void
      {
         this.myClanName.text = obj.name;
         this.myClanID.text = obj.id;
         this.myClanLeader.text = obj.ownerName;
         var desc:String = StringUtil.trim(obj.description);
         this.myClanDescription.text = desc == "" ? DictClan.NOTE_NO_CLAN_DESCRIPTION : desc;
         this.resizePanel();
      }
      
      private function resizePanel() : void
      {
         var maxWidth:Number = this.myClanName.width;
         if(this.myClanID.textWidth > this.myClanName.width)
         {
            maxWidth = this.myClanID.width;
         }
         if(this.myClanLeader.textWidth > maxWidth)
         {
            maxWidth = this.myClanLeader.width;
         }
         if(maxWidth > this.myClanDescription.width)
         {
            this.myClanDescription.width = maxWidth;
         }
         else
         {
            maxWidth = this.myClanDescription.width;
         }
         this.myClanDescription.height = this.myClanDescription.textHeight + TEXT_PADDING;
         this.myBg.width = this.myClanName.x + maxWidth + PANEL_PADDING;
         this.myBg.height = this.myClanDescription.y + this.myClanDescription.height + PANEL_PADDING;
      }
   }
}

