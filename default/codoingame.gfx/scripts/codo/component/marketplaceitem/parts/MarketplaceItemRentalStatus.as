package codo.component.marketplaceitem.parts
{
   import codo.common.CFunctionCommonContainer;
   import codo.objects.ClanGlobalConfig;
   import codo.objects.SKUObj;
   import codo.utils.TextUtil;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import fsg.util.FsgUtil;
   import scaleform.gfx.TextFieldEx;
   
   public class MarketplaceItemRentalStatus extends Sprite
   {
      
      private static const LEVEL_LOCK_ICON_Y1:int = -6;
      
      private static const LEVEL_LOCK_ICON_Y2:int = 21;
      
      private static const LEVEL_LOCK_LABEL_Y1:int = 6;
      
      private static const LEVEL_LOCK_LABEL_Y2:int = 33;
      
      public var myGPIcon:Sprite;
      
      public var myCPIcon:Sprite;
      
      public var myHPIcon:Sprite;
      
      public var myEHPIcon:Sprite;
      
      public var myLevelLockIcon:IconLock;
      
      public var myLockIconLabel:MovieClip;
      
      public var myGPTF:TextField;
      
      public var myCPTF:TextField;
      
      public var myHPTF:TextField;
      
      public var myEHPTF:TextField;
      
      public function MarketplaceItemRentalStatus()
      {
         super();
         this.hidePriceInformation();
         TextFieldEx.setVerticalAlign(this.myGPTF,TextFieldEx.VALIGN_CENTER);
         TextFieldEx.setVerticalAlign(this.myCPTF,TextFieldEx.VALIGN_CENTER);
         TextFieldEx.setVerticalAlign(this.myLockIconLabel.myTF,TextFieldEx.VALIGN_CENTER);
      }
      
      public function setItemPurchaseable(minSKUs:Object) : void
      {
         var gpSKU:SKUObj = null;
         var cpSKU:SKUObj = null;
         var hpSKU:SKUObj = null;
         var ehpSKU:SKUObj = null;
         var levelLabel:String = null;
         var prestigeImgPath:String = null;
         this.myCPTF.visible = this.myCPIcon.visible = false;
         this.myGPTF.visible = this.myGPIcon.visible = false;
         this.myHPTF.visible = this.myHPIcon.visible = false;
         this.myEHPTF.visible = this.myEHPIcon.visible = false;
         this.myLevelLockIcon.visible = false;
         this.myLockIconLabel.visible = false;
         gpSKU = minSKUs.minGPSku;
         cpSKU = minSKUs.minCPSku;
         hpSKU = minSKUs.minHPSku;
         ehpSKU = minSKUs.minEHPSku;
         this.myGPTF.visible = this.myGPIcon.visible = false;
         if(Boolean(gpSKU) && gpSKU.price > 0)
         {
            this.myGPTF.visible = this.myGPIcon.visible = true;
            this.myGPTF.text = String(gpSKU.price);
         }
         this.myCPTF.visible = this.myCPIcon.visible = false;
         if(Boolean(cpSKU) && cpSKU.price > 0)
         {
            this.myCPTF.visible = this.myCPIcon.visible = true;
            this.myCPTF.text = String(cpSKU.price);
         }
         this.myHPTF.visible = this.myHPIcon.visible = false;
         if(Boolean(hpSKU) && hpSKU.price > 0)
         {
            this.myHPTF.visible = this.myHPIcon.visible = true;
            this.myHPTF.text = String(hpSKU.price);
         }
         this.myEHPTF.visible = this.myEHPIcon.visible = false;
         if(Boolean(ehpSKU) && ehpSKU.price > 0)
         {
            this.myEHPTF.visible = this.myEHPIcon.visible = true;
            this.myEHPTF.text = String(ehpSKU.price);
         }
         var lockFactors:Array = [gpSKU,cpSKU];
         var mainFactor:SKUObj = null;
         for(var i:int = 0; i < lockFactors.length; i++)
         {
            if(Boolean(lockFactors[i]) && lockFactors[i].price > 0)
            {
               mainFactor = lockFactors[i];
               this.myLevelLockIcon.visible = !mainFactor.purchasable;
               break;
            }
         }
         if(Boolean(mainFactor) && !mainFactor.purchasable)
         {
            if(mainFactor == gpSKU && mainFactor.requirementUnlockFlag != "uf_clan_rank" && mainFactor.requirementUnlockFlag != "uf_wargod_rank")
            {
               levelLabel = CFunctionCommonContainer.GetDisplayLevel(gpSKU.requirementLevel);
               prestigeImgPath = FsgUtil.getPrestigeIcon(gpSKU.requirementPrestige);
               this.myLevelLockIcon.setLockLevel(levelLabel,prestigeImgPath);
               this.myGPIcon.visible = this.myGPTF.visible = false;
               this.myLevelLockIcon.y = LEVEL_LOCK_ICON_Y1;
               this.myLockIconLabel.y = LEVEL_LOCK_LABEL_Y1;
            }
            else if(mainFactor.requirementUnlockFlag == "uf_clan_rank")
            {
               this.myLevelLockIcon.setLockLevel("","");
               this.myGPIcon.visible = this.myGPTF.visible = false;
               this.myCPIcon.visible = this.myCPTF.visible = false;
               this.myLockIconLabel.visible = true;
               this.myLevelLockIcon.y = LEVEL_LOCK_ICON_Y2;
               this.myLockIconLabel.y = LEVEL_LOCK_LABEL_Y2;
               TextUtil.setFontSize(this.myLockIconLabel.myTF,16);
               this.myLockIconLabel.myTF.text = ClanGlobalConfig.CLAN_LEVEL_NAMES[mainFactor.requirementLevel - 1];
               TextUtil.resizeTextToFitWidth(this.myLockIconLabel.myTF);
            }
            else if(mainFactor.requirementUnlockFlag == "uf_wargod_rank")
            {
               this.myLevelLockIcon.setLockLevel("","");
               this.myHPIcon.visible = this.myHPTF.visible = false;
               this.myEHPIcon.visible = this.myEHPTF.visible = false;
               this.myLockIconLabel.visible = true;
               this.myLevelLockIcon.y = LEVEL_LOCK_ICON_Y2;
               this.myLockIconLabel.y = LEVEL_LOCK_LABEL_Y2;
               TextUtil.setFontSize(this.myLockIconLabel.myTF,16);
               this.myLockIconLabel.myTF.text = WarGodUtility.getTierName(mainFactor.requirementLevel - 1);
               TextUtil.resizeTextToFitWidth(this.myLockIconLabel.myTF);
            }
         }
      }
      
      private function hidePriceInformation() : void
      {
         this.myCPTF.visible = this.myCPIcon.visible = this.myGPTF.visible = this.myGPIcon.visible = this.myLevelLockIcon.visible = false;
      }
   }
}

