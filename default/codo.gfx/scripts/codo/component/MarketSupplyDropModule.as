package codo.component
{
   import codo.component.factory.ButtonFactory;
   import codo.localization.DictMarket;
   import codo.objects.ProductObj;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   
   public class MarketSupplyDropModule extends MovieClip
   {
      
      private static const NAME_WIDTH:Number = 800;
      
      private static const DESCRIPTION_WIDTH:Number = 507;
      
      private static const DESCRIPTION_HEIGHT:Number = 124;
      
      public var myItemName:TextField;
      
      public var myPossibleRewardsLabel:TextField;
      
      public var myItemDescription:TextField;
      
      public var mySupplyDropRewards:ScrollGrid;
      
      private var mRewardDataSetup:Boolean = false;
      
      public function MarketSupplyDropModule()
      {
         super();
         this.myItemName.textStyle = MarketGuide.styleMarketItemDetailsHeader;
         this.myItemName.width = NAME_WIDTH;
         this.myItemDescription.width = DESCRIPTION_WIDTH;
         this.myItemDescription.height = DESCRIPTION_HEIGHT;
         this.myItemDescription.textStyle = GlobalGuide.styleTextSmall;
         this.myItemDescription.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myItemDescription.wordWrap = true;
         this.myPossibleRewardsLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myPossibleRewardsLabel.width = DESCRIPTION_WIDTH;
         this.myPossibleRewardsLabel.text = LocalizeUtil.localize(DictMarket.MARKET_SUPPLY_DROP_POSSIBLE_REWARDS).toUpperCase();
         var gridSettings:ScrollGridSettings = new ScrollGridSettings();
         gridSettings.useNavArrows = false;
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.buildGridItemRenderMethod = ButtonFactory.BUILD_SUPPLY_DROP_REWARD_DETAILS_BUTTON;
         this.mySupplyDropRewards.initGrid(gridSettings,3,false,2);
      }
      
      public function setData(prodData:ProductObj) : void
      {
         this.myItemName.text = LocalizeUtil.localize(prodData.name).toUpperCase();
         this.myItemDescription.text = prodData.description;
         if(ScaleformUtil.isScaleform && false == this.mRewardDataSetup)
         {
            this.setupRewardData();
         }
      }
      
      private function setupRewardData() : void
      {
         var data:Vector.<Object> = new Vector.<Object>();
         var dataObj:Object = new Object();
         dataObj.label = "Weapons";
         dataObj.description = "FROM ASSAULT RIFLES TO SWORDS, ALL NEW RANGED AND MELEE WEAPONS ARE AVAILABLE TO CHANGE THE WAY YOU PLAY.";
         dataObj.index = 0;
         data.push(dataObj);
         dataObj = new Object();
         dataObj.label = "Gear";
         dataObj.description = "PLACEHOLDER DESCRIPTION";
         dataObj.index = 1;
         data.push(dataObj);
         dataObj = new Object();
         dataObj.label = "Emotes";
         dataObj.description = "PLACEHOLDER DESCRIPTION";
         dataObj.index = 2;
         data.push(dataObj);
         dataObj = new Object();
         dataObj.label = "Gameplay Tokens";
         dataObj.description = "PLACEHOLDER DESCRIPTION";
         dataObj.index = 3;
         data.push(dataObj);
         dataObj = new Object();
         dataObj.label = "Avatars";
         dataObj.description = "PLACEHOLDER DESCRIPTION";
         dataObj.index = 4;
         data.push(dataObj);
         dataObj = new Object();
         dataObj.label = "Scrap";
         dataObj.description = "PLACEHOLDER DESCRIPTION";
         dataObj.index = 5;
         data.push(dataObj);
         this.mySupplyDropRewards.addItemsByVector(data);
         this.mRewardDataSetup = true;
      }
   }
}

