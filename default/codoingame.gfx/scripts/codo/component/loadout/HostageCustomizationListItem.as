package codo.component.loadout
{
   import codo.component.Button;
   import codo.localization.Dict;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HostageCustomizationListItem extends Button
   {
      
      public var myName:TextField;
      
      public var myImage:FsgImageHolder;
      
      public var myTierColorBar:MovieClip;
      
      public var myEquipButton:Button;
      
      public var myHighlightOverlay:MovieClip;
      
      public var myDisabledOverlay:MovieClip;
      
      public function HostageCustomizationListItem()
      {
         super();
         this.myEquipButton.width = 216;
         this.myEquipButton.height = 29;
         this.myEquipButton.enabled = false;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         var productData:ProductObj = data as ProductObj;
         if(productData == null)
         {
            return;
         }
         this.myName.text = LocalizeUtil.localize(productData.name);
         this.myImage.setImage(productData.imageURL);
         this.myTierColorBar.width = this.myName.textWidth + 20;
         GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[productData.tier],new <DisplayObject>[this.myTierColorBar]);
         if(productData.isOwned())
         {
            enabled = true;
            this.myDisabledOverlay.visible = false;
            this.myEquipButton.label = Dict.EQUIP_ITEM;
         }
         else
         {
            enabled = false;
            this.myDisabledOverlay.visible = true;
            this.myEquipButton.label = "@SF_UI_SUGGESTED_LOADOUT_UNOWNED_CAPS";
         }
         this.myEquipButton.forceEndHighlight();
         this.myHighlightOverlay.visible = false;
      }
      
      override public function draw() : void
      {
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.myEquipButton.forceShowHighlight();
         this.myHighlightOverlay.visible = true;
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.myEquipButton.forceEndHighlight();
         this.myHighlightOverlay.visible = false;
      }
   }
}

