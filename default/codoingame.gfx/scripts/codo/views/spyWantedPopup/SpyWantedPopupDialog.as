package codo.views.spyWantedPopup
{
   import codo.component.Popup;
   import codo.localization.DictSpy;
   import codo.shared.hud.spyWantedTableEntry;
   import codo.shared.hud.spyWantedTableHeader;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class SpyWantedPopupDialog extends MovieClip
   {
      
      private static const TABLE_ENTRY_START_X:Number = 32;
      
      private static const TABLE_ENTRY_START_Y:Number = 101;
      
      private static const TABLE_ENTRY_HEIGHT:Number = 34;
      
      private static const HINT_TEXT_MARGIN:Number = 4;
      
      private static const HEAD_BG_FRAME_ALIVE:Number = 1;
      
      private static const HEAD_BG_FRAME_CONFIRMED:Number = 2;
      
      private static const HEAD_BG_FRAME_MISSING:Number = 3;
      
      public var myContainer:Popup;
      
      public var myHint:TextField;
      
      public var myGrayQuad:MovieClip;
      
      private var mDynamicChilds:Array = [];
      
      private var mWantedClickCallback:Function;
      
      private var mCloseClickCallback:Function;
      
      public function SpyWantedPopupDialog()
      {
         super();
         this.myContainer.myBackground.gotoAndStop(7);
         this.myContainer.width = 550;
         this.myContainer.height = 800;
         this.myContainer.header.title = LocalizeUtil.localize(DictSpy.SKILL_WANTED_SELECT_TARGET);
         this.myContainer.myCloseButton.setClickCallback(this.onCloseBtnClick);
         this.myContainer.myCloseButton.x = this.myContainer.width - this.myContainer.myCloseButton.width * 0.5;
         if(!ScaleformUtil.isScaleform)
         {
            this.setData(this.getData());
            this.myContainer.header.title = "Choose a player ";
         }
         this.myHint.text = LocalizeUtil.localize(DictSpy.SKILL_WANTED_HINT);
      }
      
      private function getData() : Object
      {
         var data:Object = new Object();
         var player:Object = new Object();
         player.clientNum = 1;
         player.nickname = "3";
         player.name = "JoeyYu";
         player.state = 0;
         player.role = 3;
         player.isDeputy = false;
         player.state = 0;
         data.alive = [player];
         data.missing = [player];
         data.bodyFound = [player];
         return data;
      }
      
      private function removeAllDynamicChilds() : void
      {
         for(var i:int = 0; i < this.mDynamicChilds.length; i++)
         {
            this.myContainer.removeChild(this.mDynamicChilds[i]);
         }
         this.mDynamicChilds = [];
      }
      
      private function addDynamicChild(child:MovieClip, height:Number, yOffset:Number) : Number
      {
         this.myContainer.addChild(child);
         this.mDynamicChilds.push(child);
         child.y = yOffset;
         child.x = TABLE_ENTRY_START_X;
         return yOffset + height;
      }
      
      public function onEntryCheckboxClick(playerData:Object) : void
      {
         if(this.mWantedClickCallback != null)
         {
            this.mWantedClickCallback(playerData);
         }
      }
      
      private function addTableEntries(data:Array, nextY:Number) : Number
      {
         var entry:WantedTableEntry = null;
         var arrayLen:int = int(data.length);
         for(var index:int = 0; index < arrayLen; index++)
         {
            entry = new spyWantedTableEntry();
            entry.setData(data[index],index != arrayLen - 1);
            entry.setCheckButtonClickCallback(this.onEntryCheckboxClick);
            nextY = this.addDynamicChild(entry,TABLE_ENTRY_HEIGHT,nextY);
         }
         return nextY;
      }
      
      public function setData(data:Object) : void
      {
         var header:WantedTableHeader = null;
         this.removeAllDynamicChilds();
         var nextY:Number = TABLE_ENTRY_START_Y;
         header = new spyWantedTableHeader();
         header.myTitle.text = LocalizeUtil.localize(DictSpy.SCOREBOARD_CATEGORY_HEADER_ALIVE);
         header.myBG.gotoAndStop(HEAD_BG_FRAME_ALIVE);
         nextY = this.addDynamicChild(header,header.height,nextY);
         if(data.hasOwnProperty("alive"))
         {
            nextY = this.addTableEntries(data.alive,nextY);
         }
         this.myGrayQuad.y = nextY;
         header = new spyWantedTableHeader();
         header.myTitle.text = LocalizeUtil.localize(DictSpy.SKILL_WANTED_BODY_MISSING);
         header.myBG.gotoAndStop(HEAD_BG_FRAME_MISSING);
         nextY = this.addDynamicChild(header,header.height,nextY);
         if(data.hasOwnProperty("missing") && data.missing.length > 0)
         {
            nextY = this.addTableEntries(data.missing,nextY);
         }
         header = new spyWantedTableHeader();
         header.myTitle.text = LocalizeUtil.localize(DictSpy.SKILL_WANTED_BODY_CONFIRMED);
         header.myBG.gotoAndStop(HEAD_BG_FRAME_CONFIRMED);
         nextY = this.addDynamicChild(header,header.height,nextY);
         if(data.hasOwnProperty("bodyFound") && data.bodyFound.length > 0)
         {
            nextY = this.addTableEntries(data.bodyFound,nextY);
         }
         this.myGrayQuad.height = nextY - this.myGrayQuad.y;
         this.myHint.y = nextY + HINT_TEXT_MARGIN;
         this.myContainer.height = TABLE_ENTRY_START_Y + this.mDynamicChilds.length * TABLE_ENTRY_HEIGHT + this.myHint.height + HINT_TEXT_MARGIN;
      }
      
      public function setWantedClickCallback(callback:Function) : void
      {
         this.mWantedClickCallback = callback;
      }
      
      public function setCloseClickCallback(callback:Function) : void
      {
         this.mCloseClickCallback = callback;
      }
      
      private function onCloseBtnClick() : void
      {
         if(this.mCloseClickCallback != null)
         {
            this.mCloseClickCallback();
         }
      }
   }
}

