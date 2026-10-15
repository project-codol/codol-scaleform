package codo.views.hud.popups.hudTdLoadoutView_parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionInGameContainer;
   import codo.localization.DictTD;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.TextUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HudTdLoadoutWeaponSlot extends HudTdLoadoutViewSlotBase
   {
      
      public var myTierColorAccent:MovieClip;
      
      public var myCategory:TextField;
      
      public var myName:TextField;
      
      public var myTierColorBarCap:MovieClip;
      
      public var myTierColorBar:MovieClip;
      
      public var myCategoryBG:MovieClip;
      
      public var myActiveTag:MovieClip;
      
      public var myAttach1Image:FsgImageHolder;
      
      public var myAttach2Image:FsgImageHolder;
      
      public var myAttach3Image:FsgImageHolder;
      
      public var myAttach4Image:FsgImageHolder;
      
      public var myAmmoInfo:HudTdLoadoutWeaponSlotAmmoInfo;
      
      private var mSlot:int;
      
      private var mAttachmentIcons:Vector.<FsgImageHolder>;
      
      public function HudTdLoadoutWeaponSlot()
      {
         super();
         var activeTagText:TextField = this.myActiveTag.getChildByName("myText") as TextField;
         activeTagText.text = DictTD.LOADOUT_ACTIVE_WEAPON;
         this.lootItemIndex = 0;
      }
      
      public function set slot(slot:int) : void
      {
         this.mSlot = slot;
      }
      
      override public function set lootItemIndex(lootItemIndex:int) : void
      {
         var i:int = 0;
         var itemID:int = 0;
         var productObj:ProductObj = null;
         var token:String = null;
         var itemName:String = null;
         mLootItemIndex = lootItemIndex;
         this.mAttachmentIcons = new <FsgImageHolder>[this.myAttach1Image,this.myAttach2Image,this.myAttach3Image,this.myAttach4Image];
         for(i = 0; i < this.mAttachmentIcons.length; i++)
         {
            this.mAttachmentIcons[i].setImage("");
         }
         var lootItemInfo:Object = CFunctionInGameContainer.AS_TD_GetLootItemInfo(lootItemIndex);
         if(lootItemInfo == null)
         {
            this.myName.text = "";
            myImage.setImage(null);
            this.myCategory.text = "";
            this.myCategoryBG.visible = false;
            this.myTierColorAccent.gotoAndStop(1);
            this.myTierColorBarCap.visible = false;
            this.myTierColorBar.width = 0;
            myDropButton.visible = false;
            this.myAmmoInfo.visible = false;
            return;
         }
         var tokens:Array = lootItemInfo.item.split("|");
         var attachmentSlot:int = 0;
         for(i = 0; i < tokens.length; i++)
         {
            token = tokens[i];
            if(i == 0)
            {
               itemName = token;
               itemID = CFunctionCommonContainer.GetItemIDByName(itemName);
               productObj = CFunctionCommonContainer.GetItemInfo(itemID);
               if(productObj == null)
               {
                  this.myName.text = "";
                  myImage.setImage(null);
                  this.myCategory.text = "";
                  this.myCategoryBG.visible = false;
                  this.myTierColorAccent.gotoAndStop(1);
                  this.myTierColorBarCap.visible = false;
                  this.myTierColorBar.width = 0;
                  myDropButton.visible = false;
                  this.myAmmoInfo.visible = false;
                  return;
               }
               this.myName.text = LocalizeUtil.localize(productObj.name);
               TextUtil.resizeTextToFitWidth(this.myName);
               myImage.setImage(productObj.imageURL);
               this.myAmmoInfo.visible = true;
               myDropButton.visible = true;
               this.myCategoryBG.visible = this.myCategory.visible = productObj.group.length > 0;
               if(true == this.myCategory.visible)
               {
                  this.myCategory.text = LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(productObj.group));
                  this.myCategoryBG.width = this.myCategory.x + this.myCategory.textWidth + GlobalGuide.COMPONENT_PADDING;
               }
               this.myTierColorAccent.gotoAndStop(lootItemInfo.tier + 1);
               GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[lootItemInfo.tier],new <DisplayObject>[this.myTierColorBar]);
               this.myTierColorBar.width = this.myName.x + this.myName.textWidth + this.myTierColorBarCap.width + 5;
               this.myTierColorBarCap.x = this.myTierColorBar.x + this.myTierColorBar.width - this.myTierColorBarCap.width;
               this.myTierColorBarCap.visible = true;
            }
            else
            {
               if(attachmentSlot >= this.mAttachmentIcons.length)
               {
                  break;
               }
               if(token.indexOf("cam") != 0)
               {
                  itemID = CFunctionCommonContainer.GetItemIDByName(token);
                  productObj = CFunctionCommonContainer.GetItemInfo(itemID);
                  if(productObj != null)
                  {
                     this.mAttachmentIcons[attachmentSlot++].setImage(productObj.imageURL);
                  }
               }
            }
         }
      }
      
      override protected function onDrop() : void
      {
         CFunctionCommonContainer.ScriptMenuResponse("td_drop_item","weapon|" + this.mSlot.toString());
      }
   }
}

