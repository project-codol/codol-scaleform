package components.fsgmatchresult_part
{
   import codo.localization.Dict;
   import codo.objects.SKUObj;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class FsgMatchResultsUnlockListItem extends MovieClip
   {
      
      public var myImageHolder:FsgImageHolder;
      
      public var myTitle:TextField;
      
      public var myGPCost:TextField;
      
      public var myCPCost:TextField;
      
      public var mySecondaryText:TextField;
      
      public var myTertiaryText:TextField;
      
      public var myPlayerCardTitle:TextField;
      
      public var myContainer:MovieClip;
      
      public var myCPIcon:MovieClip;
      
      public var myGPIcon:MovieClip;
      
      public var myLargeGPIcon:MovieClip;
      
      public var myDivider:MovieClip;
      
      public function FsgMatchResultsUnlockListItem()
      {
         super();
      }
      
      public function setData(data:Object) : void
      {
         var skus:Array = null;
         var skuObject:SKUObj = null;
         var i:int = 0;
         this.myTitle = this.myContainer["myTitle"];
         this.myGPCost = this.myContainer["myGPCost"];
         this.myGPIcon = this.myContainer["myGPIcon"];
         this.myCPCost = this.myContainer["myCPCost"];
         this.myCPIcon = this.myContainer["myCPIcon"];
         this.myLargeGPIcon = this.myContainer["myLargeGPIcon"];
         this.mySecondaryText = this.myContainer["mySecondaryText"];
         this.myTertiaryText = this.myContainer["myTertiaryText"];
         this.myImageHolder = this.myContainer["myImageHolder"];
         this.myDivider = this.myContainer["myDivider"];
         this.myPlayerCardTitle = this.myContainer["myPlayerCardTitle"];
         this.myTitle.text = this.mySecondaryText.text = "";
         this.myImageHolder.visible = true;
         if(null != this.myLargeGPIcon)
         {
            this.myLargeGPIcon.visible = false;
         }
         if(data.type == "pct")
         {
            this.myPlayerCardTitle.visible = true;
            this.myPlayerCardTitle.text = data.name;
            this.myTitle.visible = false;
            this.myImageHolder.visible = false;
         }
         else if(null != this.myPlayerCardTitle)
         {
            this.myPlayerCardTitle.visible = false;
         }
         if(null != data.name)
         {
            this.myTitle.text = String(data.name).toUpperCase();
         }
         if(null != data.imageURL)
         {
            this.myImageHolder.clearImage();
            this.myImageHolder.setImage(data.imageURL);
         }
         if(null != data.SKUs)
         {
            skus = data.SKUs;
            for(i = 0; i < skus.length; i++)
            {
               skuObject = skus[i] as SKUObj;
               if(skuObject.currency == Dict.CP && null != this.myCPCost)
               {
                  this.myCPCost.text = String(skuObject.price);
               }
               else if(null != this.myCPCost)
               {
                  this.myCPCost.visible = false;
                  this.myCPIcon.visible = false;
               }
               if(skuObject.currency == Dict.GP && null != this.myGPCost)
               {
                  this.myGPCost.text = String(skuObject.price);
               }
               else if(null != this.myGPCost)
               {
                  this.myGPCost.visible = false;
                  this.myGPIcon.visible = false;
               }
            }
         }
         if(null != data.gp)
         {
            if(null != this.myLargeGPIcon)
            {
               this.myLargeGPIcon.visible = true;
               this.myImageHolder.visible = false;
            }
            if(null != this.myCPCost && null != this.myGPCost)
            {
               this.myCPCost.visible = false;
               this.myCPIcon.visible = false;
               this.myGPCost.visible = false;
               this.myGPIcon.visible = false;
            }
            if(null != this.myDivider)
            {
               this.myDivider.visible = false;
            }
         }
         if(null != this.myGPCost && null != this.myCPCost)
         {
            this.myCPCost.visible = false;
            this.myCPIcon.visible = false;
            this.myGPCost.visible = false;
            this.myGPIcon.visible = false;
            if(null != this.myDivider)
            {
               this.myDivider.visible = false;
            }
         }
         if(null != data.secondaryText && null != this.mySecondaryText)
         {
            if(null != this.myDivider)
            {
               this.myDivider.visible = false;
            }
            this.mySecondaryText.text = String(data.secondaryText).toUpperCase();
         }
         if(null != data.tertiaryText && null != this.myTertiaryText)
         {
            this.myTertiaryText.text = String(data.tertiaryText).toUpperCase();
         }
      }
   }
}

