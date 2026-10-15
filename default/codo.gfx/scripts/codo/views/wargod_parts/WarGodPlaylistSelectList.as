package codo.views.wargod_parts
{
   import codo.component.CheckBox;
   import codo.localization.DictWarGod;
   import codo.objects.WarGodPlaylistObj;
   import codo.utils.TextUtil;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class WarGodPlaylistSelectList extends MovieClip
   {
      
      private static const OPTION_NAME_HEADER:String = "option_";
      
      private static const OPTION_LINKAGE:String = "codo.shared.CheckBox";
      
      private static const OPTION_HEIGHT:int = 20;
      
      private static const OPTION_GAP:int = 10;
      
      private static const OPTION_MARGIN:int = 10;
      
      private static const HINT_HEIGHT:int = 37;
      
      public var myHint:MovieClip;
      
      public var myContainer:MovieClip;
      
      public var myHitArea:MovieClip;
      
      public var myBg:MovieClip;
      
      private var mChangeCallback:Function;
      
      private var mData:WarGodPlaylistObj;
      
      public function WarGodPlaylistSelectList()
      {
         super();
      }
      
      public function setPlaylist(playlistObj:WarGodPlaylistObj) : void
      {
         var playlistData:Array = null;
         var i:int = 0;
         var item:CheckBox = null;
         this.mData = playlistObj;
         playlistData = this.mData.playlist;
         var warnType:int = this.mData.warnType;
         if(warnType != WarGodPlaylistObj.WARN_TYPE_NO_WARN)
         {
            this.myHint.visible = true;
            if(warnType == WarGodPlaylistObj.WARN_TYPE_PARTY_MEMBER_PLACEMENT)
            {
               this.myHint.myText.text = DictWarGod.JWG_PLAYLIST_WARN_MEMBER_PLACEMENT;
            }
            else
            {
               this.myHint.myText.text = DictWarGod.JWG_PLAYLIST_WARN_PLACEMENT;
            }
            TextUtil.resizeTextToFitWidth(this.myHint.myText);
            this.myContainer.y = HINT_HEIGHT;
         }
         else
         {
            this.myHint.visible = false;
            this.myContainer.y = 0;
         }
         var optionLink:Class = getDefinitionByName(OPTION_LINKAGE) as Class;
         if(!optionLink)
         {
            return;
         }
         var numPlaylist:int = int(playlistData.length);
         var numExistingItems:int = this.myContainer.numChildren;
         for(i = 0; i < numPlaylist; i++)
         {
            if(i < numExistingItems)
            {
               item = this.myContainer.getChildByName(OPTION_NAME_HEADER + String(i)) as CheckBox;
            }
            else
            {
               item = new optionLink();
               item.addCheckedCallback(this.onOptionChecked,i);
               item.addUncheckedCallback(this.onOptionUnchecked,i);
               item.name = OPTION_NAME_HEADER + String(i);
            }
            item.x = OPTION_MARGIN;
            item.y = OPTION_MARGIN + (OPTION_HEIGHT + OPTION_GAP) * i;
            item.setData(playlistData[i]);
            item.enabled = playlistData[i].enabled;
            item.myOutline.visible = item.enabled || item.checked;
            this.myContainer.addChild(item);
         }
         this.myBg.height = this.myHitArea.height = numPlaylist * OPTION_HEIGHT + (numPlaylist - 1) * OPTION_GAP + 2 * OPTION_MARGIN + this.myContainer.y;
         for(i = int(playlistData.length); i < numExistingItems; i++)
         {
            item = this.myContainer.getChildByName(OPTION_NAME_HEADER + String(i)) as CheckBox;
            item.removeCheckedCallback(this.onOptionChecked,item.getData());
            item.removeUncheckedCallback(this.onOptionChecked,item.getData());
            this.myContainer.removeChild(item);
            item = null;
         }
      }
      
      public function setSeniorWarGodPlaylist() : void
      {
         var item:CheckBox = null;
         this.myHint.visible = true;
         this.myHint.myText.text = DictWarGod.WG_NO_PLAYLIST_WARNING;
         TextUtil.resizeTextToFitWidth(this.myHint.myText);
         this.myContainer.y = HINT_HEIGHT;
         var optionLink:Class = getDefinitionByName(OPTION_LINKAGE) as Class;
         if(!optionLink)
         {
            return;
         }
         var sadCheckBox:CheckBox = this.myContainer.getChildByName(OPTION_NAME_HEADER + String(0)) as CheckBox;
         if(!sadCheckBox)
         {
            sadCheckBox = new optionLink();
            sadCheckBox.name = OPTION_NAME_HEADER + String(0);
         }
         sadCheckBox.label = "@MPUI_SEARCH_AND_DESTROY";
         sadCheckBox.checked = true;
         sadCheckBox.enabled = false;
         sadCheckBox.x = OPTION_MARGIN;
         sadCheckBox.y = OPTION_MARGIN;
         var domCheckBox:CheckBox = this.myContainer.getChildByName(OPTION_NAME_HEADER + String(1)) as CheckBox;
         if(!domCheckBox)
         {
            domCheckBox = new optionLink();
            domCheckBox.name = OPTION_NAME_HEADER + String(1);
         }
         domCheckBox.label = "@MPUI_DOMINATION";
         domCheckBox.checked = true;
         domCheckBox.enabled = false;
         domCheckBox.x = OPTION_MARGIN;
         domCheckBox.y = OPTION_MARGIN + (OPTION_HEIGHT + OPTION_GAP);
         this.myContainer.addChild(sadCheckBox);
         this.myContainer.addChild(domCheckBox);
         var numExistingItems:int = this.myContainer.numChildren;
         for(var i:int = 2; i < numExistingItems; i++)
         {
            item = this.myContainer.getChildByName(OPTION_NAME_HEADER + String(i)) as CheckBox;
            if(Boolean(item))
            {
               item.removeCheckedCallback(this.onOptionChecked,item.getData());
               item.removeUncheckedCallback(this.onOptionChecked,item.getData());
               this.myContainer.removeChild(item);
               item = null;
            }
         }
         this.myBg.height = this.myHitArea.height = 2 * OPTION_HEIGHT + OPTION_GAP + 2 * OPTION_MARGIN + this.myContainer.y;
      }
      
      public function registerSelectionChangeEvent(callback:Function) : void
      {
         this.mChangeCallback = callback;
      }
      
      override public function get height() : Number
      {
         return this.myBg.height;
      }
      
      private function onOptionChecked(data:Object) : void
      {
         this.sendOptionChangeEvent(data as int);
      }
      
      private function onOptionUnchecked(data:Object) : void
      {
         this.sendOptionChangeEvent(data as int);
      }
      
      private function sendOptionChangeEvent(index:int) : void
      {
         var item:CheckBox = null;
         var data:Object = null;
         var numChildren:int = this.myContainer.numChildren;
         for(var i:int = 0; i < numChildren; i++)
         {
            item = this.myContainer.getChildAt(i) as CheckBox;
            data = item.getData();
            data.checked = item.checked;
         }
         this.mChangeCallback(this.mData);
      }
   }
}

