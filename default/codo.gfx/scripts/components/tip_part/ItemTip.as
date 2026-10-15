package components.tip_part
{
   import codo.base.BaseView;
   import codo.constants.ComponentCSS;
   import codo.utils.DebugUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class ItemTip extends BaseView
   {
      
      private static const PROPERTY_AMOUNT:uint = 5;
      
      private static const COLOR_TEXT:Array = [ComponentCSS.FSG_COLOR_BLUE,ComponentCSS.FSG_COLOR_BLUE];
      
      public var myHeader:MovieClip;
      
      public var myDescription:MovieClip;
      
      public var myToolTipStats:MovieClip;
      
      public var myBackground1:MovieClip;
      
      public var myBackground2:MovieClip;
      
      private const ACCURACY_TEXT:String = "@SF_WEAPON_ACCURACY";
      
      private const DAMAGE_TEXT:String = "@SF_WEAPON_DAMAGE";
      
      private const RANGE_TEXT:String = "@SF_WEAPON_RANGE";
      
      private const FIRERATE_TEXT:String = "@SF_WEAPON_FIRERATE";
      
      private const MOBILITY_TEXT:String = "@SF_WEAPON_MOBILITY";
      
      private const PROPERTY_BAR_MAX:Number = 135;
      
      public function ItemTip()
      {
         super();
         this.onInit();
         this.onStyleChangeForMatchType();
      }
      
      override protected function onInit() : void
      {
         super.onInit();
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.myToolTipStats.myAccuracyText.text = this.ACCURACY_TEXT;
         this.myToolTipStats.myDamageText.text = this.DAMAGE_TEXT;
         this.myToolTipStats.myRangeText.text = this.RANGE_TEXT;
         this.myToolTipStats.myFireText.text = this.FIRERATE_TEXT;
         this.myToolTipStats.myMobilityText.text = this.MOBILITY_TEXT;
      }
      
      public function set data(cDat:Object) : void
      {
         var descText:String = null;
         var gap:Number = NaN;
         this.myHeader.myWeaponHeaderText.text = cDat.data.name;
         if(ScaleformUtil.IsLogItemIDEnabled())
         {
            descText = "";
            descText = DebugUtil.concatenateDebugSkuInfoToString(descText,cDat.data);
            this.myDescription.myWeaponBodyText.text = descText;
         }
         else
         {
            this.myDescription.myWeaponBodyText.text = cDat.data.description;
         }
         this.myDescription.myWeaponBodyText.autoSize = TextFieldAutoSize.LEFT;
         this.myToolTipStats.y = this.myDescription.y + this.myDescription.height + 10;
         var iHighest:int = 0;
         var properties:Array = cDat.data.properties;
         for(var j:int = 0; j < properties.length; j++)
         {
            if(properties[j].val > iHighest)
            {
               iHighest = int(properties[j].val);
            }
         }
         for(var i:int = 0; i < properties.length; i++)
         {
            switch(properties[i].key)
            {
               case this.ACCURACY_TEXT:
                  this.setPropertyBar(this.myToolTipStats.myAccuracyBar,properties[i].val,properties[i].val == iHighest ? 1 : 0.3);
                  break;
               case this.DAMAGE_TEXT:
                  this.setPropertyBar(this.myToolTipStats.myDamageBar,properties[i].val,properties[i].val == iHighest ? 1 : 0.3);
                  break;
               case this.RANGE_TEXT:
                  this.setPropertyBar(this.myToolTipStats.myRangeBar,properties[i].val,properties[i].val == iHighest ? 1 : 0.3);
                  break;
               case this.FIRERATE_TEXT:
                  this.setPropertyBar(this.myToolTipStats.myFireBar,properties[i].val,properties[i].val == iHighest ? 1 : 0.3);
                  break;
               case this.MOBILITY_TEXT:
                  this.setPropertyBar(this.myToolTipStats.myMobilityBar,properties[i].val,properties[i].val == iHighest ? 1 : 0.3);
            }
         }
         var tmpY:Number = y + height;
         var tmpX:Number = x + width;
         var visibleRect:Rectangle = ScaleformUtil.visibleRect();
         this.myHeader.y = 7;
         this.myDescription.y = 35;
         this.myToolTipStats.y = 164;
         if(x < visibleRect.x)
         {
            x = visibleRect.x;
         }
         else if(tmpX > visibleRect.x + visibleRect.width)
         {
            x = visibleRect.x + visibleRect.width - width;
         }
         if(tmpY > visibleRect.height)
         {
            this.myBackground2.height = this.myHeader.height + this.myDescription.height + this.myToolTipStats.height + 30;
            gap = 282 - this.myBackground2.height;
            this.myHeader.y = 7 + gap;
            this.myDescription.y = 35 + gap;
            this.myToolTipStats.y = this.myDescription.y + this.myDescription.height + 10;
            y -= 74 + height;
            this.myBackground1.visible = false;
            this.myBackground2.visible = true;
         }
         else
         {
            this.myBackground1.height = this.myHeader.height + this.myDescription.height + this.myToolTipStats.height + 30;
            this.myToolTipStats.y = this.myDescription.y + this.myDescription.height + 10;
            this.myBackground1.visible = true;
            this.myBackground2.visible = false;
         }
      }
      
      private function setPropertyBar(bar:MovieClip, w:Number, a:Number) : void
      {
         bar.mybarHighlight.width = w / 100 * this.PROPERTY_BAR_MAX;
         bar.mybarHighlight.alpha = a;
      }
      
      protected function onImageLoadComplete(cBMP:Bitmap) : void
      {
         if(cBMP.width == 90)
         {
            cBMP.x = 120;
         }
      }
   }
}

