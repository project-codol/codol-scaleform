package codo.constants
{
   import codo.localization.DictMarket;
   
   public class MarketSlots
   {
      
      public static const MARKET_LEVEL0:Object = {
         "label":"all",
         "nameid":"all"
      };
      
      public static const MARKET_LEVEL1:Object = {"all":[{
         "label":"WEAPON",
         "nameid":"weapon"
      },{
         "label":"WEAPON ATTACHMENT",
         "nameid":"weaponattach"
      },{
         "label":"AVATAR",
         "nameid":"avatar"
      },{
         "label":"ABILITY",
         "nameid":"ability"
      }]};
      
      public static var MARKET_LEVEL2:Object = new Object();
      
      public static var MARKET_LEVEL3:Object = new Object();
      
      public static var MARKET_CATEGORY_MAPPING:Object = new Object();
      
      public static const MARKET_DP_MAPPING:Object = {
         "ast":"weapon",
         "smg":"weapon",
         "lmg":"weapon",
         "snp":"weapon",
         "oth":"weapon",
         "pst":"weapon",
         "mps":"weapon",
         "sho":"weapon",
         "rkt":"weapon",
         "primary":"weapon",
         "secondary":"weapon",
         "sword":"sword",
         "swd":"sword",
         "mel":"sword",
         "pk1":"perk",
         "pk2":"perk",
         "pk3":"perk",
         "std":"killstreak",
         "pro":"killstreak",
         "des":"deathstreak",
         "func1":"weaponattach",
         "func2":"weaponattach",
         "func3":"weaponattach",
         "cosm1":"weaponattach",
         "cosm2":"weaponattach",
         "bas":"weaponattach",
         "gri":"weaponattach",
         "hbs":"weaponattach",
         "mag":"weaponattach",
         "muz":"weaponattach",
         "rai":"weaponattach",
         "sco":"weaponattach",
         "sto":"weaponattach",
         "sra":"weaponattach",
         "cam":"weaponattach",
         "dec":"weaponattach",
         "cha":"avatar",
         "hea":"avatar",
         "fja":"avatar",
         "fpa":"avatar",
         "ves":"avatar",
         "han":"avatar",
         "boo":"avatar",
         "heg":"avatar",
         "elp":"avatar",
         "knp":"avatar",
         "pat":"avatar",
         "eye":"avatar",
         "emo":"avatar",
         "let":"equipment",
         "spe":"equipment",
         "tac":"equipment",
         "tok":"item",
         "utl":"item",
         "asy":"item",
         "cac":"item",
         "sup":"item",
         "etk":"item",
         "wld":"item",
         "sha":"item",
         "pcb":"callsign",
         "pct":"callsign",
         "pci":"callsign",
         "pcn":"callsign",
         "pcf":"callsign",
         "bdg":"callsign",
         "cnc":"item",
         "coupon":"coupon",
         "oft":"bundle",
         "gbx":"bundle",
         "sdb":"bundle",
         "lob":"bundle"
      };
      
      public function MarketSlots()
      {
         super();
      }
      
      public static function init() : void
      {
         MARKET_LEVEL2["weapon"] = [{"nameid":"primaryweap"},{"nameid":"secondaryweap"},{"nameid":"equipment"}];
         MARKET_LEVEL2["weaponattach"] = [{
            "label":"FUNCTIONAL",
            "nameid":"func1"
         },{
            "label":"TECHNO",
            "nameid":"sra"
         },{
            "label":"COSMETIC",
            "nameid":"cosm1"
         },{
            "label":"CAMO",
            "nameid":"cam"
         }];
         MARKET_LEVEL2["avatar"] = [{
            "label":"JACKET",
            "nameid":"fja"
         },{
            "label":"PANT",
            "nameid":"fpa"
         },{
            "label":"VEST",
            "nameid":"ves"
         },{
            "label":"GLOVE",
            "nameid":"han"
         },{
            "label":"BOOTS",
            "nameid":"boo"
         },{
            "label":"HEAD GEAR",
            "nameid":"heg"
         },{
            "label":"ELBOW PAD",
            "nameid":"elp"
         },{
            "label":"KNEE PAD",
            "nameid":"knp"
         },{
            "label":"EYE",
            "nameid":"eye"
         }];
         MARKET_LEVEL2["ability"] = [{
            "label":"PERK",
            "nameid":"perk"
         },{
            "label":"KILLSTREAK",
            "nameid":"kis"
         },{
            "label":"DEATHSTREAK",
            "nameid":"des"
         }];
         MARKET_LEVEL2["itm"] = [{
            "label":"ROBOTS",
            "nameid":"asy"
         },{
            "label":"TOKEN",
            "nameid":"tok"
         },{
            "label":"LOADOUTS",
            "nameid":"cac"
         },{
            "label":"SHARDS",
            "nameid":"sha"
         }];
         MARKET_LEVEL3["primaryweap"] = [{
            "label":"ASSAULT RIFLE",
            "nameid":"ast"
         },{
            "label":"SUB MACHINEGUN",
            "nameid":"smg"
         },{
            "label":"LIGHT MACHINEGUN",
            "nameid":"lmg"
         },{
            "label":"SNIPER RIFLE",
            "nameid":"snp"
         },{
            "label":"SHOTGUNS",
            "nameid":"sho"
         },{
            "label":"OTHER",
            "nameid":"oth"
         }];
         MARKET_LEVEL3["secondaryweap"] = [{
            "label":"HAND GUN",
            "nameid":"pst"
         },{
            "label":"MACHINE PISTOL",
            "nameid":"mps"
         },{
            "label":"LAUNCHERS",
            "nameid":"rkt"
         }];
         MARKET_LEVEL3["equipment"] = [{
            "label":"LETHAL",
            "nameid":"let"
         },{
            "label":"SPECIAL",
            "nameid":"spe"
         },{
            "label":"TACTICAL",
            "nameid":"tac"
         }];
         MARKET_LEVEL3["perk"] = [{
            "label":"PERK1",
            "nameid":"pk1"
         },{
            "label":"PERK2",
            "nameid":"pk2"
         },{
            "label":"PERK3",
            "nameid":"pk3"
         }];
         MARKET_LEVEL3[MarketMenuData.TYPE_KILLSTREAK] = [{
            "nameid":"ks1",
            "label":DictMarket.CATEGORY_KILLSTREAK1
         },{
            "nameid":"ks2",
            "label":DictMarket.CATEGORY_KILLSTREAK2
         },{
            "nameid":"ks3",
            "label":DictMarket.CATEGORY_KILLSTREAK3
         }];
         addLevel3Mapping("perk");
         addLevel3Mapping("kis");
         addLevel2Mapping("itm");
         addLevel3Mapping("equipment");
         addLevel3Mapping("primaryweap");
         addLevel3Mapping("secondaryweap");
         addLevel2Mapping("ability");
         addLevel2Mapping("avatar");
         addLevel2Mapping("weapon");
         addLevel2Mapping("weaponattach");
      }
      
      private static function addLevel3Mapping(keyWord:String) : void
      {
         var item:* = undefined;
         MARKET_CATEGORY_MAPPING[keyWord] = new Array();
         for each(item in MARKET_LEVEL3[keyWord])
         {
            MARKET_CATEGORY_MAPPING[keyWord].push(item.nameid);
         }
      }
      
      private static function addLevel2Mapping(keyWord:String) : void
      {
         var item:* = undefined;
         var containednameid:* = undefined;
         MARKET_CATEGORY_MAPPING[keyWord] = new Array();
         for each(item in MARKET_LEVEL2[keyWord])
         {
            if(Boolean(MARKET_CATEGORY_MAPPING[item.nameid]))
            {
               for each(containednameid in MARKET_CATEGORY_MAPPING[item.nameid])
               {
                  MARKET_CATEGORY_MAPPING[keyWord].push(containednameid);
               }
            }
            else
            {
               MARKET_CATEGORY_MAPPING[keyWord].push(item.nameid);
            }
         }
      }
   }
}

