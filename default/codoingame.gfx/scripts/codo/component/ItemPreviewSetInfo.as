package codo.component
{
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.manager.EventManager;
   import codo.objects.ProductObj;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class ItemPreviewSetInfo extends MovieClip
   {
      
      public var myBg:MovieClip;
      
      public var myItemNames:flash.text.TextField;
      
      public var myBorderDown:MovieClip;
      
      public var myDesc:flash.text.TextField;
      
      public var myEffectDescs:flash.text.TextField;
      
      public var myName:flash.text.TextField;
      
      private var mPreviewItem:ProductObj;
      
      public function ItemPreviewSetInfo()
      {
         super();
      }
      
      public function show() : void
      {
         if(visible)
         {
            return;
         }
         visible = true;
         EventManager.getInstance().listen(BCEvent.EVT_EQUIPPED,this.onItemEquipped);
      }
      
      public function hide() : void
      {
         if(!visible)
         {
            return;
         }
         visible = false;
         EventManager.getInstance().unlisten(BCEvent.EVT_EQUIPPED,this.onItemEquipped);
      }
      
      public function setData(data:Object, previewItem:ProductObj) : void
      {
         var items:Array;
         var itemNames:Array;
         var itemNameColors:Array;
         var itemEffectDescTexts:Array;
         var equippedItemNum:int = 0;
         var item:Object = null;
         var i:int = 0;
         var onSetDescFormat:Function = null;
         onSetDescFormat = function(textFormat:TextFormat, index:int):void
         {
            textFormat.color = index / 2 < equippedItemNum - 1 ? 15198183 : 10066329;
            textFormat.leftMargin = index % 2 == 0 ? 0 : 20;
         };
         this.mPreviewItem = previewItem;
         items = data.items;
         itemNames = [];
         itemNameColors = [];
         equippedItemNum = 0;
         for each(item in items)
         {
            itemNames.push(LocalizeUtil.localize("@" + item.name) + "\n");
            if(Boolean(item.equipped))
            {
               equippedItemNum++;
               itemNameColors.push(16747264);
            }
            else
            {
               itemNameColors.push(10066329);
            }
         }
         LocalizeUtil.combineColorizedStrings(this.myItemNames,itemNames,itemNameColors);
         this.myName.text = LocalizeUtil.localize("@" + data.name) + "(" + equippedItemNum + "/" + itemNames.length + ")";
         this.myBorderDown.y = this.myItemNames.y + this.myItemNames.textHeight + 8;
         this.myEffectDescs.y = this.myBorderDown.y + this.myBorderDown.height + 16;
         itemEffectDescTexts = [];
         for(i = 0; i < data.effectDescs.length; i++)
         {
            itemEffectDescTexts.push(LocalizeUtil.param("@SF_UI_PVE_SET_ITEM_NUM",[i + 2]) + "\n");
            itemEffectDescTexts.push(LocalizeUtil.localize("@" + data.effectDescs[i]) + "\n");
         }
         LocalizeUtil.combineCustomizeFormatStrings(this.myEffectDescs,itemEffectDescTexts,onSetDescFormat);
         this.myDesc.y = this.myEffectDescs.y + this.myEffectDescs.textHeight + 16;
         this.myDesc.text = "@" + data.desc;
         this.myBg.height = this.myDesc.y + this.myDesc.textHeight + 16;
      }
      
      private function onItemEquipped(cEvt:ParaEvent) : void
      {
         var itemSetInfo:Object = CFunctionCommonContainer.AS_GetPveSetInfo(this.mPreviewItem.id,this.mPreviewItem.group);
         if(itemSetInfo != null)
         {
            this.setData(itemSetInfo,this.mPreviewItem);
         }
      }
   }
}

