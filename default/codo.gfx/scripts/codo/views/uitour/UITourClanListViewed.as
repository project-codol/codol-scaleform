package codo.views.uitour
{
   import codo.component.marketplaceitem.parts.MarketplaceItemCard;
   import codo.constants.DataID;
   import codo.localization.Dict;
   import codo.localization.DictClan;
   import codo.localization.DictUITutorial;
   import codo.manager.DataManager;
   import codo.objects.ClanGlobalConfig;
   import codo.objects.ProductObj;
   import codo.services.TutorialService;
   import codo.style.TutorialGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import flash.utils.getDefinitionByName;
   
   public class UITourClanListViewed extends UITutorialTourBase
   {
      
      public var myRewardItem:MarketplaceItemCard;
      
      public function UITourClanListViewed()
      {
         super();
         myTitleTF.textStyle = TutorialGuide.styleTextTitle;
         myDescriptionTF.textStyle = TutorialGuide.styleTextDescriptionMedium;
         myTitleTF.width = myDescriptionTF.width = TEXT_BOX_WITH_DESCRIPTION_WIDTH;
         myTitleTF.text = DictUITutorial.UI_TOUR_CLAN_JOIN_TITLE;
         var itemClass:Class = getDefinitionByName("codo.shared.marketplace.MarketplaceItemCard") as Class;
         this.myRewardItem = new itemClass();
         var item:ProductObj = TutorialService.getInstance().getClanOnboardingReward();
         var itemName:String = LocalizeUtil.localize(item.name);
         myDescriptionTF.text = LocalizeUtil.param(DictClan.CLAN_BENEFIT4_LABEL,[itemName,(DataManager.getInstance().getDP(DataID.CLAN_GLOBAL_CONFIG) as ClanGlobalConfig).joinRewardItemDuration]);
         myCallToActionButton.label = Dict.CONTINUE;
         var prodObj:ProductObj = TutorialService.getInstance().getClanOnboardingReward();
         this.myRewardItem.setCardStyle(MarketItemUtil.ITEM_CARD_SMALL_FRAME,false);
         this.myRewardItem.withDiscountTag = false;
         this.myRewardItem.setData(prodObj);
         this.myRewardItem.visible = true;
         this.myRewardItem.x = 1234;
         this.myRewardItem.y = 210;
         addChild(this.myRewardItem);
      }
   }
}

