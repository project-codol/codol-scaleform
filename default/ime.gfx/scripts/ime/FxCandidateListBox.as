package ime
{
   import flash.display.*;
   import flash.utils.getDefinitionByName;
   
   public class FxCandidateListBox
   {
      
      private var ListObj:MovieClip;
      
      private var ItemName:String;
      
      private var SelectedItemIndex:Number;
      
      private var DisplayItems:Array;
      
      public var DisplayItemIndex:Number;
      
      private var Items:Array;
      
      private var ItemDataMap:Array;
      
      public var TextColor:Number;
      
      public var SelectedTextColor:Number;
      
      public var SelectedBackgroundColor:Number;
      
      public var BackgroundColor:Number;
      
      public var IndexBackgroundColor:Number;
      
      public var SelectedIndexBackgroundColor:Number;
      
      public var FontSize:Number;
      
      public var VisibleCount:Number;
      
      public var DisplayCallback:Function;
      
      private var IsListCreated:Boolean = false;
      
      public function FxCandidateListBox()
      {
         super();
         this.ListObj = null;
         this.ItemName = null;
         this.SelectedItemIndex = -1;
         this.DisplayItems = new Array();
         this.DisplayItemIndex = 0;
         this.Items = new Array();
         this.VisibleCount = 0;
         this.DisplayCallback = null;
      }
      
      public function InitCandidateListDefaults(styles:Object) : void
      {
         this.SelectedBackgroundColor = styles.selectedBackgroundColor == undefined ? 9755539 : Number(styles.selectedBackgroundColor);
         this.IndexBackgroundColor = styles.indexBackgroundColor == undefined ? 12503505 : Number(styles.indexBackgroundColor);
         this.SelectedIndexBackgroundColor = styles.selectedIndexBackgroundColor == undefined ? 6994017 : Number(styles.selectedIndexBackgroundColor);
         this.SelectedTextColor = styles.selectedTextColor == undefined ? 16777215 : Number(styles.selectedTextColor);
         this.TextColor = styles.textColor == undefined ? 5592405 : Number(styles.textColor);
         this.BackgroundColor = styles.backgroundColor == undefined ? 15725300 : Number(styles.backgroundColor);
         this.FontSize = styles.fontSize == undefined ? 26 : Number(styles.fontSize);
      }
      
      public function SetCandidateListProps(_textColor:Number, selectedTextColor:Number, _backgroundColor:Number, selectedBackgroundColor:Number, fontSize:Number, indexBackgroundColor:Number, selectedIndexBackgroundColor:Number) : *
      {
         this.SelectedBackgroundColor = selectedBackgroundColor >= 0 ? selectedBackgroundColor : this.SelectedBackgroundColor;
         this.SelectedIndexBackgroundColor = selectedIndexBackgroundColor >= 0 ? selectedIndexBackgroundColor : this.SelectedIndexBackgroundColor;
         this.BackgroundColor = _backgroundColor >= 0 ? _backgroundColor : this.BackgroundColor;
         this.IndexBackgroundColor = indexBackgroundColor >= 0 ? indexBackgroundColor : this.IndexBackgroundColor;
         this.FontSize = fontSize >= 0 ? fontSize : this.FontSize;
         this.SelectedTextColor = selectedTextColor >= 0 ? selectedTextColor : this.SelectedTextColor;
         this.TextColor = _textColor >= 0 ? _textColor : this.TextColor;
      }
      
      public function CreateCandidateList(list_mc:MovieClip, numRows:Number, itemName:String, x:Number, y:Number, rowMovie:String, dataMap:Array, styles:Object) : *
      {
         var cs:Class = null;
         var nmc:MovieClip = null;
         this.InitCandidateListDefaults(styles);
         for(var i:* = 0; i < numRows; i++)
         {
            cs = getDefinitionByName("ListRow") as Class;
            nmc = new cs();
            list_mc.addChild(nmc);
            nmc["setController"](this);
            nmc.name = itemName + i;
            nmc.x = x;
            nmc.y = y;
            nmc.Value.autoSize = true;
         }
         this.SetListObject(list_mc);
         this.SetItemDataMap(dataMap);
         this.SetItemName(itemName);
         this.SetVisibleCount(numRows);
         this.IsListCreated = true;
      }
      
      public function DestroyList() : void
      {
         for(var i:* = 0; i < this.VisibleCount; i++)
         {
            this.DisplayItems[i] = null;
         }
         this.IsListCreated = false;
      }
      
      public function ClearList() : void
      {
         this.DisplayItemIndex = 0;
         this.SelectedItemIndex = -1;
      }
      
      public function Add() : void
      {
         if(!this.IsListCreated || arguments == null || arguments.length < this.ItemDataMap.length)
         {
            return;
         }
         if(Boolean(this.DisplayItems) && this.DisplayItemIndex < this.DisplayItems.length)
         {
            this.DisplayItems[this.DisplayItemIndex].ItemData = arguments;
            ++this.DisplayItemIndex;
         }
      }
      
      public function SetVisibleCount(items:Number) : void
      {
         var item:* = undefined;
         this.VisibleCount = items;
         this.DisplayItems.splice(0);
         for(var i:* = 0; i < items; i++)
         {
            item = new FxCandidateListItemInterface(MovieClip(this.ListObj.getChildByName(this.ItemName + i)));
            item.ItemDataMap = this.ItemDataMap;
            this.DisplayItems.push(item);
         }
      }
      
      public function GetVisibleCount() : Number
      {
         return this.VisibleCount;
      }
      
      public function GetItemAtIndex(idx:Number) : FxCandidateListItemInterface
      {
         return this.DisplayItems[idx];
      }
      
      public function SetList() : void
      {
         var tmp:FxCandidateListItemInterface = null;
         var lobj:* = undefined;
         if(!this.IsListCreated)
         {
            return;
         }
         if(this.ListObj == null || this.ItemName == null)
         {
            return;
         }
         var l:* = this.ItemDataMap.length;
         for(var i:Number = 0; i < this.VisibleCount; i++)
         {
            tmp = this.DisplayItems[i] as FxCandidateListItemInterface;
            lobj = tmp.ItemObj;
            if(i < this.DisplayItemIndex)
            {
               lobj.visible = true;
               if(this.SelectedItemIndex == i)
               {
                  if(lobj != null)
                  {
                     lobj.GotoOnState();
                     lobj.selected = true;
                  }
               }
               else if(lobj != null)
               {
                  lobj.GotoOffState();
                  lobj.selected = false;
               }
            }
            if(i >= this.DisplayItemIndex)
            {
               lobj.visible = false;
            }
         }
         if(this.DisplayCallback != null)
         {
            this.DisplayCallback(this.SelectedItemIndex);
         }
      }
      
      public function SetItemDataMap(map:Array) : *
      {
         var itemDataNames:String = null;
         var i:* = undefined;
         this.ItemDataMap = map;
         if(this.ItemDataMap.length > 0)
         {
            itemDataNames = this.ItemDataMap[0];
            for(i = 1; i < this.ItemDataMap.length; i++)
            {
               itemDataNames += "," + this.ItemDataMap[i];
            }
         }
         MovieClip(this.ListObj.parent).SendIMEMessage("CandidateList_OnSetItemDataMap",itemDataNames);
      }
      
      public function DisplayInfo(name:String) : *
      {
         var item:FxCandidateListItemInterface = null;
         item = this.GetItem(name);
         if(item != null)
         {
            item.DisplayInfo();
         }
      }
      
      private function GetItem(name:String) : FxCandidateListItemInterface
      {
         if(this.ItemName == null)
         {
            return null;
         }
         if(name == null)
         {
            return null;
         }
         var i:* = parseInt(name.substring(this.ItemName.length));
         return this.DisplayItems[i];
      }
      
      public function SelectItem(name:String) : *
      {
         this.SelectedItemIndex = parseInt(name.substring(this.ItemName.length));
         MovieClip(this.ListObj.parent).SendIMEMessage("CandidateList_OnItemSelect",this.SelectedItemIndex);
      }
      
      public function SelectDataItem(idx:Number) : *
      {
         this.SelectedItemIndex = idx;
      }
      
      public function SetListObject(listobj:MovieClip) : *
      {
         this.ListObj = listobj;
      }
      
      public function SetItemName(itemname:String) : *
      {
         this.ItemName = itemname;
      }
      
      public function RegisterPostDisplayCallback(func:Function) : *
      {
         this.DisplayCallback = func;
      }
   }
}

