package components.marketplace_part
{
   import codo.component.TextField;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.objects.WeaponBasicStatObj;
   import codo.objects.WeaponStatsObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class MarketplaceCompareStatsPanel extends MovieClip
   {
      
      private static const NUM_STATS:int = 6;
      
      private static const HEADER_WIDTH:Number = 389;
      
      public var myStatIcon0:MovieClip;
      
      public var myStatIcon1:MovieClip;
      
      public var myStatIcon2:MovieClip;
      
      public var myStatIcon3:MovieClip;
      
      public var myStatIcon4:MovieClip;
      
      public var myStatIcon5:MovieClip;
      
      public var statName0:TextField;
      
      public var statName1:TextField;
      
      public var statName2:TextField;
      
      public var statName3:TextField;
      
      public var statName4:TextField;
      
      public var statName5:TextField;
      
      public var myHeader:TextField;
      
      private var mHeaders:Vector.<TextField>;
      
      public var weaponStatsLeft:WeaponStatBars;
      
      public var weaponStatsRight:WeaponStatBars;
      
      public function MarketplaceCompareStatsPanel()
      {
         var label:TextField = null;
         var numIcons:int = 0;
         var imageHolder:MovieClip = null;
         var icon:int = 0;
         var imageClass:Class = null;
         var bitmapData:BitmapData = null;
         var bitmap:Bitmap = null;
         super();
         this.myHeader.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHeader.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myHeader.alignment = TextStyle.HALIGN_CENTER;
         this.myHeader.width = HEADER_WIDTH;
         this.myHeader.text = LocalizeUtil.localize(DictMarket.COMPARE_ITEM).toUpperCase();
         this.mHeaders = new <TextField>[this.statName0,this.statName1,this.statName2,this.statName3,this.statName4,this.statName5];
         var len:int = int(this.mHeaders.length);
         for(var i:int = 0; i < len; i++)
         {
            label = this.mHeaders[i];
            label.alignment = TextStyle.HALIGN_CENTER;
            label.fontColor = GlobalGuide.GRAY_80;
            label.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
            label.width = HEADER_WIDTH;
         }
         if(false == ScaleformUtil.isScaleform)
         {
            this.statName0.text = "DAMAGE";
            this.statName1.text = "RANGE";
            this.statName2.text = "ADS STABILITY";
            this.statName3.text = "RECOIL RECOVERY";
            this.statName4.text = "HIPFIRE ACCURACY";
            this.statName5.text = "MOBILITY";
         }
         else
         {
            numIcons = int(MarketItemUtil.STAT_ICON_IMAGES.length);
            for(icon = 0; icon < numIcons; icon++)
            {
               imageHolder = this["myStatIcon" + icon];
               imageClass = getDefinitionByName(MarketItemUtil.STAT_ICON_IMAGES[icon]) as Class;
               bitmapData = new imageClass(width,height);
               bitmap = new Bitmap(bitmapData);
               imageHolder.addChild(bitmap);
            }
         }
         this.weaponStatsLeft.init(WeaponStatBars.LEFT_SIDE);
         this.weaponStatsRight.init(WeaponStatBars.RIGHT_SIDE);
      }
      
      public function setData(dataLeft:ProductObj, dataRight:ProductObj) : void
      {
         this.weaponStatsLeft.setData(dataLeft);
         this.weaponStatsRight.setData(dataRight);
         var stats:WeaponStatsObj = new WeaponStatsObj(dataLeft);
         this.setHeaders(stats.basicStats);
         this.setCompareData();
      }
      
      public function startAnimation() : void
      {
         this.weaponStatsLeft.startAnimation();
         this.weaponStatsRight.startAnimation();
      }
      
      private function setHeaders(basicStats:Vector.<WeaponBasicStatObj>) : void
      {
         var len:int = int(basicStats.length);
         for(var i:int = 0; i < len; i++)
         {
            if(Boolean(this.mHeaders[i]))
            {
               this.mHeaders[i].text = basicStats[i].name;
            }
         }
      }
      
      private function setCompareData() : void
      {
         var leftValue:Number = NaN;
         var rightValue:Number = NaN;
         for(var i:int = 0; i < NUM_STATS; i++)
         {
            leftValue = this.weaponStatsLeft.getStatValue(i);
            rightValue = this.weaponStatsRight.getStatValue(i);
            if(leftValue > rightValue)
            {
               this.weaponStatsLeft.setStatCompareValue(i,true);
               this.weaponStatsRight.setStatCompareValue(i,false);
            }
            else if(leftValue < rightValue)
            {
               this.weaponStatsLeft.setStatCompareValue(i,false);
               this.weaponStatsRight.setStatCompareValue(i,true);
            }
            else
            {
               this.weaponStatsLeft.setStatCompareValue(i,false);
               this.weaponStatsRight.setStatCompareValue(i,false);
            }
         }
      }
   }
}

