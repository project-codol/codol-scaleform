package codo.utils
{
   import codo.localization.DictMarket;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class MarketItemUtil
   {
      
      private static var _instance:MarketItemUtil;
      
      public static const ITEM_EXTENDED:String = "codo.shared.marketplaceItemExtended";
      
      public static const ITEM_EXTENDED_DETAIL:String = "codo.shared.marketplaceItemExtendedDetail";
      
      public static const TIER_BASIC:int = 0;
      
      public static const TIER_COMMON:int = 1;
      
      public static const TIER_RARE:int = 2;
      
      public static const TIER_EPIC:int = 3;
      
      public static const TIER_LEGENDARY:int = 4;
      
      public static const BUFF_DAMAGE:int = 0;
      
      public static const BUFF_RANGE:int = 1;
      
      public static const BUFF_ADS:int = 2;
      
      public static const BUFF_RECOIL:int = 3;
      
      public static const BUFF_HIPFIRE:int = 4;
      
      public static const BUFF_MOBILITY:int = 5;
      
      public static const BUFF_CLIPSIZE:int = 6;
      
      public static const BUFF_RATEOFFIRE:int = 7;
      
      public static const STAT_DAMAGE:int = 0;
      
      public static const STAT_RANGE:int = 1;
      
      public static const STAT_ADS:int = 2;
      
      public static const STAT_RECOIL:int = 3;
      
      public static const STAT_HIPFIRE:int = 4;
      
      public static const STAT_MOBILITY:int = 5;
      
      public static const ITEM_CARD_SMALL_FRAME:uint = 1;
      
      public static const ITEM_CARD_MEDIUM_FRAME:uint = 2;
      
      public static const ITEM_CARD_LARGE_FRAME:uint = 3;
      
      public static const ITEM_CARD_SMALL_REWARD_FRAME:uint = 4;
      
      public static const ITEM_CARD_TINY_FRAME:uint = 5;
      
      public static const ITEM_CARD_TINY_WIDTH:uint = 180;
      
      public static const ITEM_CARD_SMALL_WIDTH:uint = 222;
      
      public static const ITEM_CARD_MEDIUM_WIDTH:uint = 300;
      
      public static const ITEM_CARD_LARGE_WIDTH:uint = 390;
      
      public static const ITEM_CARD_TINY_HEIGHT:uint = 147;
      
      public static const ITEM_CARD_SMALL_HEIGHT:uint = 188;
      
      public static const ITEM_CARD_MEDIUM_HEIGHT:uint = 254;
      
      public static const ITEM_CARD_LARGE_HEIGHT:uint = 341;
      
      public static var STAT_ICON_IMAGES:Vector.<String> = new Vector.<String>();
      
      public static var ITEM_TIER_LABELS:Array = [DictMarket.TIER_LABEL_COMMON,DictMarket.TIER_LABEL_UNCOMMON,DictMarket.TIER_LABEL_RARE,DictMarket.TIER_LABEL_EPIC,DictMarket.TIER_LABEL_LEGENDARY];
      
      private static var ITEM_CATEGORY_LABEL_MAPPING:Object = {
         "ast":DictMarket.CATEGORY_ASSAULT_RIFLE,
         "smg":DictMarket.CATEGORY_SMG,
         "lmg":DictMarket.CATEGORY_LMG,
         "snp":DictMarket.CATEGORY_SNIPER,
         "sho":DictMarket.CATEGORY_SHOTGUN,
         "oth":DictMarket.CATEGORY_OTHER,
         "pst":DictMarket.CATEGORY_PISTOL,
         "mps":DictMarket.CATEGORY_MACHINE_PISTOL,
         "rkt":DictMarket.CATEGORY_LAUNCHER,
         "swd":DictMarket.CATEGORY_OTHER,
         "let":DictMarket.CATEGORY_LETHAL,
         "spe":DictMarket.CATEGORY_SPECIAL,
         "tac":DictMarket.CATEGORY_TACTICAL,
         "mel":DictMarket.CATEGORY_COMBAT_KNIFE,
         "fja":DictMarket.CATEGORY_JACKET,
         "fpa":DictMarket.CATEGORY_PANTS,
         "ves":DictMarket.CATEGORY_VEST,
         "han":DictMarket.CATEGORY_GLOVE,
         "boo":DictMarket.CATEGORY_BOOT,
         "heg":DictMarket.CATEGORY_HEADGEAR,
         "elp":DictMarket.CATEGORY_TATTOO,
         "knp":DictMarket.CATEGORY_KNEEPAD,
         "eye":DictMarket.CATEGORY_EYEWEAR,
         "oft":DictMarket.CATEGORY_OUTFIT,
         "cha":DictMarket.ITEM_MENU_AVATAR,
         "emo":DictMarket.ITEM_MENU_EMO,
         "wat":DictMarket.MARKETPLACE_DETAILS_ATTACHMENTS,
         "equ":DictMarket.ITEM_MENU_EQUIPMENT,
         "per":DictMarket.ITEM_MENU_PERK,
         "wld":DictMarket.ITEM_MENU_WILDCARD,
         "kis":DictMarket.ITEM_MENU_KILLSTREAK,
         "bdg":DictMarket.CATEGORY_CALLSIGN_BADGES,
         "cac":DictMarket.CATEGORY_CAC,
         "pcb":DictMarket.CATEGORY_CALLSIGN_PCB,
         "pci":DictMarket.CATEGORY_CALLSIGN_EMBLEM,
         "pct":DictMarket.CATEGORY_CALLSIGN_TITLE,
         "pcn":DictMarket.CATEGORY_CALLSIGN_NAMEPLATE
      };
      
      STAT_ICON_IMAGES[STAT_DAMAGE] = "codo.shared.marketplaceItem.statIconDamage";
      STAT_ICON_IMAGES[STAT_RANGE] = "codo.shared.marketplaceItem.statIconRange";
      STAT_ICON_IMAGES[STAT_ADS] = "codo.shared.marketplaceItem.statIconADS";
      STAT_ICON_IMAGES[STAT_RECOIL] = "codo.shared.marketplaceItem.statIconRecoil";
      STAT_ICON_IMAGES[STAT_HIPFIRE] = "codo.shared.marketplaceItem.statIconHipFire";
      STAT_ICON_IMAGES[STAT_MOBILITY] = "codo.shared.marketplaceItem.statIconMobility";
      
      public function MarketItemUtil()
      {
         super();
      }
      
      public static function getInstance() : MarketItemUtil
      {
         if(MarketItemUtil._instance == null)
         {
            MarketItemUtil._instance = new MarketItemUtil();
         }
         return MarketItemUtil._instance;
      }
      
      public static function GET_ITEM_CATEGORY_BY_GROUP(groupName:String) : String
      {
         return ITEM_CATEGORY_LABEL_MAPPING[groupName];
      }
      
      public function drawPieChart(mountClip:Sprite, radius:Number, percentFull:Number, fillColor:Number, lineColor:Number, bgFillColor:Number) : void
      {
         var backgroundCircle:Shape = new Shape();
         backgroundCircle.graphics.beginFill(bgFillColor);
         backgroundCircle.graphics.lineStyle(1,bgFillColor);
         backgroundCircle.graphics.drawCircle(0,0,radius);
         backgroundCircle.graphics.endFill();
         mountClip.addChild(backgroundCircle);
         var startDeg:Number = 0;
         var endDeg:Number = 360 * percentFull;
         var pieChart:Shape = new Shape();
         pieChart.graphics.lineStyle(1,lineColor);
         pieChart.graphics.beginFill(fillColor);
         pieChart.graphics.moveTo(0,0);
         pieChart.graphics.lineTo(radius * Math.cos(startDeg / 180 * Math.PI),radius * Math.sin(startDeg / 180 * Math.PI));
         for(var i:int = startDeg; i <= endDeg; i++)
         {
            pieChart.graphics.lineTo(radius * Math.cos(i / 180 * Math.PI),radius * Math.sin(i / 180 * Math.PI));
         }
         pieChart.graphics.lineTo(0,0);
         pieChart.graphics.endFill();
         pieChart.rotation = -90;
         mountClip.addChild(pieChart);
      }
   }
}

