package codo.component
{
   import codo.constants.BCEvent;
   import codo.manager.EventManager;
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgImageHolder;
   import scaleform.gfx.TextFieldEx;
   
   public class PlayerCard extends MovieClip
   {
      
      private static const SUB_LINE_TOTAL_LINE:int = 240;
      
      private static const SUB_LINE_GAP:int = 15;
      
      public var myName:flash.text.TextField;
      
      public var myClanName:flash.text.TextField;
      
      public var myTitle:flash.text.TextField;
      
      public var myRank:flash.text.TextField;
      
      public var myPrestige:flash.text.TextField;
      
      public var myIcon:FsgImageHolder;
      
      public var myAnimatedIcon:MovieClip;
      
      public var myPrestigeIcon:FsgImageHolder;
      
      public var myBackground:FsgImageHolder;
      
      public var myAnimatedBackground:MovieClip;
      
      public var myDisabledIcon:Sprite;
      
      public var myAnimatedFrame:MovieClip;
      
      public var myFrame:FsgImageHolder;
      
      private var mCompleteClanName:String = "";
      
      public function PlayerCard()
      {
         super();
         this.clearData();
         if(this.myDisabledIcon != null)
         {
            this.myDisabledIcon.visible = false;
         }
         this.myRank.autoSize = this.myPrestige.autoSize = TextFieldAutoSize.RIGHT;
         TextFieldEx.setVerticalAlign(this.myRank,TextFieldEx.VALIGN_CENTER);
         if(this.myClanName != null)
         {
            this.myClanName.text = "";
         }
      }
      
      public function setName(name:String) : void
      {
         this.myName.text = name;
      }
      
      public function setClanName(clanName:String) : void
      {
         this.mCompleteClanName = clanName;
         this.alignSubline();
      }
      
      public function setTitle(title:String) : void
      {
         this.myTitle.text = title;
         this.alignSubline();
      }
      
      private function alignSubline() : void
      {
         var clanNameWidth:Number = NaN;
         var clanNameStartX:int = this.myTitle.x + this.myTitle.textWidth + SUB_LINE_GAP;
         clanNameWidth = SUB_LINE_TOTAL_LINE - (clanNameStartX - this.myTitle.x);
         this.myClanName.x = clanNameStartX;
         this.myClanName.width = clanNameWidth;
         this.myClanName.text = this.mCompleteClanName;
         StringUtil.fitTextField(this.myClanName);
      }
      
      public function setRank(rank:String) : void
      {
         this.myRank.text = rank;
      }
      
      public function setPrestige(prestige:String) : void
      {
         this.myPrestige.text = prestige;
      }
      
      public function setEmblem(emblem:String) : void
      {
         if(emblem.length <= 4)
         {
            return;
         }
         var compareStr:String = emblem.substr(0,4).toLowerCase();
         if(compareStr == "pci_")
         {
            this.setEmblemBackground(emblem);
         }
         else
         {
            this.setAnimatedEmblem(emblem);
         }
      }
      
      public function setNameplate(color:uint) : void
      {
         this.myName.textColor = color;
      }
      
      public function setAnimatedEmblem(animEmblem:String) : void
      {
         this.cleanOutAnimatedEmblem();
         this.myIcon.visible = false;
         this.myAnimatedIcon.visible = true;
         var animatedIconLoadData:Object = {
            "name":animEmblem,
            "holder":this.myAnimatedIcon
         };
         EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,animatedIconLoadData);
      }
      
      public function setEmblemBackground(imageEmblem:String) : void
      {
         this.myIcon.setImage(imageEmblem);
         this.myIcon.visible = true;
         this.myAnimatedIcon.visible = false;
         this.cleanOutAnimatedEmblem();
      }
      
      private function cleanOutAnimatedEmblem() : void
      {
         while(this.myAnimatedIcon.numChildren > 0)
         {
            this.myAnimatedIcon.removeChildAt(0);
         }
      }
      
      public function setPrestigeIcon(prestigeIcon:String) : void
      {
         this.myPrestigeIcon.setImage(prestigeIcon);
      }
      
      public function setBackground(background:String) : void
      {
         if(background.length <= 4)
         {
            return;
         }
         var compareStr:String = background.substr(0,4).toLowerCase();
         if(compareStr == "pcb_")
         {
            this.setImageBackground(background);
         }
         else
         {
            this.setAnimatedBackground(background);
         }
      }
      
      public function setFrame(frame:String) : void
      {
         if(frame.length <= 4)
         {
            this.myFrame.visible = false;
            this.myAnimatedFrame.visible = false;
            this.cleanOutAnimatedFrame();
            return;
         }
         var compareStr:String = frame.substr(0,4).toLowerCase();
         if(compareStr == "pcf_")
         {
            this.setImageFrame(frame);
         }
         else
         {
            this.setAnimatedFrame(frame);
         }
      }
      
      public function setImageBackground(imageBackground:String) : void
      {
         this.myBackground.setImage(imageBackground);
         this.myBackground.visible = true;
         this.myAnimatedBackground.visible = false;
         this.cleanOutAnimatedBg();
      }
      
      public function setAnimatedBackground(animBackground:String) : void
      {
         this.cleanOutAnimatedBg();
         this.myBackground.visible = false;
         this.myAnimatedBackground.visible = true;
         var animatedIconLoadData:Object = {
            "name":animBackground,
            "holder":this.myAnimatedBackground
         };
         EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,animatedIconLoadData);
      }
      
      public function setImageFrame(imageFrame:String) : void
      {
         this.myFrame.setImage(imageFrame);
         this.myFrame.visible = true;
         this.myAnimatedFrame.visible = false;
         this.cleanOutAnimatedFrame();
      }
      
      public function setAnimatedFrame(animFrame:String) : void
      {
         this.cleanOutAnimatedFrame();
         this.myFrame.visible = false;
         this.myAnimatedFrame.visible = true;
         var animatedFrameLoadData:Object = {
            "name":animFrame,
            "holder":this.myAnimatedFrame
         };
         EventManager.getInstance().broadcast(BCEvent.EVT_LOAD_ANIMATED_PRODUCT,animatedFrameLoadData);
      }
      
      private function cleanOutAnimatedFrame() : void
      {
         while(this.myAnimatedFrame.numChildren > 0)
         {
            this.myAnimatedFrame.removeChildAt(0);
         }
      }
      
      private function cleanOutAnimatedBg() : void
      {
         while(this.myAnimatedBackground.numChildren > 0)
         {
            this.myAnimatedBackground.removeChildAt(0);
         }
      }
      
      private function clearData() : void
      {
         this.myBackground.clearImage();
         this.cleanOutAnimatedBg();
         this.myIcon.clearImage();
         this.cleanOutAnimatedEmblem();
         this.setName("");
         this.setTitle("");
         this.setRank("");
         this.setPrestige("");
      }
   }
}

