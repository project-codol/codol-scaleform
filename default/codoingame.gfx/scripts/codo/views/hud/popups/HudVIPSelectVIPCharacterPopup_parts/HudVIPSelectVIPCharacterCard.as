package codo.views.hud.popups.HudVIPSelectVIPCharacterPopup_parts
{
   import codo.constants.DataInGameID;
   import codo.localization.DictVIP;
   import codo.manager.DataManager;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import codo.views.hud.popups.HudVIPSelectVIPCharacterPopup_parts.HudVIPSelectVIPCharacterCard_parts.HudVIPSelectVIPCharacterCardSlot;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HudVIPSelectVIPCharacterCard extends MovieClip
   {
      
      public var myName:TextField;
      
      public var myType:TextField;
      
      public var myArmorTitle:TextField;
      
      public var myHealthTitle:TextField;
      
      public var myArmorValue:TextField;
      
      public var myHealthValue:TextField;
      
      public var myArmorBar:MovieClip;
      
      public var myHealthBar:MovieClip;
      
      public var myLethal:HudVIPSelectVIPCharacterCardSlot;
      
      public var myTactical:HudVIPSelectVIPCharacterCardSlot;
      
      public var mySiderollPerkIcon:FsgImageHolder;
      
      public var myPerk1:HudVIPSelectVIPCharacterCardSlot;
      
      public var myPerk2:HudVIPSelectVIPCharacterCardSlot;
      
      public var myPerk3:HudVIPSelectVIPCharacterCardSlot;
      
      public var myPerk4:HudVIPSelectVIPCharacterCardSlot;
      
      public var myPerk5:HudVIPSelectVIPCharacterCardSlot;
      
      public var myPerk6:HudVIPSelectVIPCharacterCardSlot;
      
      public var myPerkTitle1:TextField;
      
      public var myPerkTitle2:TextField;
      
      public var myPerkTitle3:TextField;
      
      public var myPerkTitle4:TextField;
      
      public var myPerkTitle5:TextField;
      
      public var myPerkTitle6:TextField;
      
      public var myWeaponTierCornerFill:MovieClip;
      
      public var myWeaponCategoryTF:TextField;
      
      public var myWeaponCategoryBg:MovieClip;
      
      public var myWeaponNameTF:TextField;
      
      public var myWeaponNameBg:MovieClip;
      
      public var myWeaponIcon:FsgImageHolder;
      
      public var myCharacterIcon:MovieClip;
      
      private var mPerks:Vector.<HudVIPSelectVIPCharacterCardSlot>;
      
      private var mPerkTitles:Vector.<TextField>;
      
      public function HudVIPSelectVIPCharacterCard()
      {
         var i:int = 0;
         super();
         if(!DataManager.getInstance().getDP(DataInGameID.IS_VIP))
         {
            return;
         }
         this.mPerks = new <HudVIPSelectVIPCharacterCardSlot>[this.myPerk1,this.myPerk2,this.myPerk3,this.myPerk4,this.myPerk5,this.myPerk6];
         this.mPerkTitles = new <TextField>[this.myPerkTitle1,this.myPerkTitle2,this.myPerkTitle3,this.myPerkTitle4,this.myPerkTitle5,this.myPerkTitle6];
         for(i = 0; i < this.mPerks.length; i++)
         {
            this.mPerks[i].visible = false;
            this.mPerkTitles[i].visible = false;
            this.mPerkTitles[i].text = LocalizeUtil.param(DictVIP.SKILL,[(i + 1).toString()]);
         }
         this.myArmorTitle.text = DictVIP.ARMOR_TITLE;
         this.myHealthTitle.text = DictVIP.HEALTH_TITLE;
         this.myLethal.visible = false;
         this.myTactical.visible = false;
      }
      
      public function setData(data:*) : void
      {
         var i:int = 0;
         this.myName.text = "@" + data.characterName;
         this.myType.text = "@" + data.characterType;
         this.myArmorValue.text = data.armor.toString();
         this.myHealthValue.text = data.health.toString();
         this.myArmorBar.scaleX = data.armor / Number(data.maxArmor);
         this.myHealthBar.scaleX = data.health / Number(data.maxHealth);
         var noneSiderollPerks:Array = [];
         var siderollPerk:Object = null;
         for(i = 0; i < data.perks.length; i++)
         {
            if(data.perks[i].nameid == "specialty_siderolling")
            {
               siderollPerk = data.perks[i];
            }
            else
            {
               noneSiderollPerks.push(data.perks[i]);
            }
         }
         for(i = 0; i < noneSiderollPerks.length; i++)
         {
            if(i >= this.mPerks.length)
            {
               break;
            }
            this.mPerks[i].setData(noneSiderollPerks[i]);
            this.mPerks[i].visible = true;
            this.mPerkTitles[i].visible = true;
         }
         this.mySiderollPerkIcon.setImage("");
         if(Boolean(siderollPerk))
         {
            this.mySiderollPerkIcon.setImage(siderollPerk.imageURL);
         }
         if(Boolean(data.lethal))
         {
            this.myLethal.setData(data.lethal);
            this.myLethal.visible = true;
         }
         if(Boolean(data.tactical))
         {
            this.myTactical.setData(data.tactical);
            this.myTactical.visible = true;
         }
         var weapon:ProductObj = data.weapon;
         GlobalGuide.formatComponentsByTier(MarketGuide.COLOR_BY_TIER[weapon.tier],new <DisplayObject>[this.myWeaponTierCornerFill,this.myWeaponNameBg]);
         var categoryStr:String = LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(weapon.group));
         if(!categoryStr)
         {
            categoryStr = LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(weapon.type));
         }
         this.myWeaponCategoryTF.text = categoryStr;
         this.myWeaponCategoryBg.width = this.myWeaponCategoryTF.textWidth + 20;
         this.myWeaponNameTF.text = weapon.name;
         this.myWeaponNameBg.width = this.myWeaponNameTF.textWidth + 20;
         this.myWeaponIcon.setImage(weapon.imageURL);
         this.myCharacterIcon.gotoAndStop(data.characterIndex);
      }
   }
}

