package codo.component
{
   import codo.component.marketplaceitem.MarketplaceItemStatBar;
   import codo.component.marketplaceitem.MarketplaceStatGainArrow;
   import codo.localization.DictRoom;
   import codo.objects.WeaponBasicStatObj;
   import codo.objects.WeaponStatsObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   
   public class WeaponStatsGraph extends Sprite
   {
      
      public static var DEFAULT_WIDTH:Number = 234;
      
      public static var DEFAULT_HEIGHT:Number = 144;
      
      public var myStatBar:Vector.<MarketplaceItemStatBar>;
      
      public var myFireTypeValue:TextField;
      
      public var myFireRateLabel:TextField;
      
      public var myFireRateValue:TextField;
      
      public var myClipSizeLabel:TextField;
      
      public var myClipSizeValue:TextField;
      
      public var myClipSizeGainArrow:MarketplaceStatGainArrow;
      
      public var myFrame:MovieClip;
      
      public function WeaponStatsGraph()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         var statBar:MarketplaceItemStatBar = null;
         var labelStyle:TextStyle = new TextStyle();
         labelStyle.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         labelStyle.allCaps = true;
         labelStyle.fontColor = GlobalGuide.WHITE;
         labelStyle.autoSize = TextFieldAutoSize.CENTER;
         labelStyle.alignment = TextStyle.HALIGN_CENTER;
         this.myFireRateLabel.textStyle = this.myClipSizeLabel.textStyle = this.myFireTypeValue.textStyle = labelStyle;
         this.myFireTypeValue.width = 40;
         this.myFireTypeValue.height = 60;
         this.myFireRateLabel.text = LocalizeUtil.localize("@SF_WEAPON_FIRERATE").toUpperCase();
         this.myClipSizeLabel.text = LocalizeUtil.localize("@SF_WEAPON_CLIPSIZE").toUpperCase();
         var valueStyle:TextStyle = GlobalGuide.styleTextHeader;
         valueStyle.font = GlobalGuide.FONT_FACE_NUMBERS;
         valueStyle.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         valueStyle.autoSize = TextFieldAutoSize.CENTER;
         valueStyle.alignment = TextStyle.HALIGN_CENTER;
         valueStyle.bold = true;
         this.myFireRateValue.textStyle = valueStyle;
         this.myClipSizeValue.textStyle = valueStyle;
         this.myFrame.width = DEFAULT_WIDTH;
         this.myFrame.height = DEFAULT_HEIGHT;
         this.myStatBar = new Vector.<MarketplaceItemStatBar>();
         for(var i:int = 0; true; i++)
         {
            statBar = getChildByName("myStatBar".concat(i)) as MarketplaceItemStatBar;
            if(statBar == null)
            {
               break;
            }
            this.myStatBar.push(statBar);
         }
      }
      
      public function setData(data:WeaponStatsObj, compareData:WeaponStatsObj = null, bCompareBase:Boolean = false, bSimpleGraph:Boolean = false) : void
      {
         var clipSize:int = 0;
         var compareClipSize:int = 0;
         var notApplicable:String = null;
         var weaponStatObj:WeaponBasicStatObj = null;
         this.myClipSizeGainArrow.visible = false;
         if(data.clipsize > 0)
         {
            this.myFireRateValue.font = this.myClipSizeValue.font = GlobalGuide.FONT_FACE_NUMBERS;
            this.myFireTypeValue.text = data.firetype;
            this.myFireTypeValue.fontColor = GlobalGuide.WHITE;
            this.myFireRateValue.text = data.rps.toFixed(2);
            clipSize = bCompareBase ? data.clipsize : data.modclipsize;
            compareClipSize = 0;
            if(compareData != null)
            {
               compareClipSize = bCompareBase ? compareData.clipsize : compareData.modclipsize;
            }
            if(Boolean(compareData) && !bSimpleGraph)
            {
               if(clipSize > compareClipSize)
               {
                  this.myClipSizeValue.text = clipSize.toString() + "(+" + (clipSize - compareClipSize) + ")";
                  this.myClipSizeValue.fontColor = GlobalGuide.GREEN;
               }
               else if(clipSize < compareClipSize)
               {
                  this.myClipSizeValue.text = clipSize.toString() + "(" + (clipSize - compareClipSize) + ")";
                  this.myClipSizeValue.fontColor = GlobalGuide.CODO_RED;
               }
               else
               {
                  this.myClipSizeValue.text = clipSize.toString();
                  this.myClipSizeValue.fontColor = GlobalGuide.WHITE;
               }
               if(data.firetype != compareData.firetype)
               {
                  this.myFireTypeValue.fontColor = GlobalGuide.GREEN;
               }
            }
            else
            {
               this.myClipSizeValue.text = clipSize.toString();
               this.myClipSizeValue.fontColor = GlobalGuide.WHITE;
               if(clipSize != 0 && compareClipSize != 0)
               {
                  this.myClipSizeGainArrow.visible = true;
                  this.myClipSizeGainArrow.setData(compareClipSize,clipSize - compareClipSize);
                  this.myClipSizeGainArrow.x = this.myClipSizeValue.x + (this.myClipSizeValue.width + this.myClipSizeValue.textWidth) / 2 + 6;
               }
            }
         }
         else
         {
            notApplicable = LocalizeUtil.localize(DictRoom.NOT_APPLICABLE);
            this.myFireRateValue.font = this.myClipSizeValue.font = GlobalGuide.FONT_FACE_MEDIUM;
            this.myClipSizeValue.text = this.myFireTypeValue.text = this.myFireRateValue.text = notApplicable;
         }
         var i:uint = 0;
         while(i < data.basicStats.length && i < this.myStatBar.length)
         {
            weaponStatObj = data.basicStats[i];
            weaponStatObj.image = MarketItemUtil.STAT_ICON_IMAGES[i];
            this.myStatBar[i].setData(weaponStatObj,Boolean(compareData) ? compareData.basicStats[i] : null,bCompareBase,bSimpleGraph);
            i++;
         }
      }
      
      override public function get height() : Number
      {
         return this.myFrame.height;
      }
   }
}

