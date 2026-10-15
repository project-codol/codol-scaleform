package codo.component
{
   import codo.component.onboarding.CharacterSelectModuleStatPanel;
   import codo.event.ParaEvent;
   import codo.localization.DictOnBoard;
   import codo.objects.OnboardCharacterOptionObj;
   import codo.objects.ProductObj;
   import codo.style.GlobalGuide;
   import codo.style.MarketGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import codo.utils.MarketItemUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextFieldAutoSize;
   import fsg.util.FsgImageHolder;
   
   public class MarketCharacterModule extends MovieClip
   {
      
      private static const HEADER_PADDING:uint = 35;
      
      private static const NAME_WIDTH:uint = 450;
      
      private static const NICK_NAME_WIDTH:uint = 450;
      
      private static const MODULE_HEIGHT:uint = 467;
      
      private static const FRAME_WIDTH:uint = 514;
      
      private static const FRAME_HEIGHT:uint = 766;
      
      private static const WITH_BIO_STATS_FRAME_HEIGHT:uint = 766;
      
      private static const TIER_WIDTH:uint = 450;
      
      private static const DESCRIPTION_WIDTH:uint = 444;
      
      private static const DEFAULT_DESCRIPTION_HEIGHT:uint = 220;
      
      private static const ONBOARDING_DESCRIPTION_HEIGHT:uint = 120;
      
      private static const NICKNAME_HEIGHT:uint = 42;
      
      private static const DIVIDER_Y:uint = 783;
      
      private static const WITH_BIO_STATS_DIVIDER_Y:uint = 783;
      
      public var myItemName:TextField;
      
      public var myItemDescription:ScrollingTextField;
      
      public var myTierLabel:TextField;
      
      public var myImage:FsgImageHolder;
      
      public var myTopTierColor:Sprite;
      
      public var myLowerDivider:Sprite;
      
      public var myFrame:MovieClip;
      
      public var myCharacterStatPanel:CharacterSelectModuleStatPanel;
      
      public var myMottoValue:TextField;
      
      public var myMottoLabel:TextField;
      
      public var myNicknameValue:TextField;
      
      public var myNicknameLabel:TextField;
      
      public function MarketCharacterModule()
      {
         super();
         this.myFrame.width = FRAME_WIDTH;
         this.myFrame.height = FRAME_HEIGHT;
         this.myFrame.gotoAndStop(3);
         this.myItemName.textStyle = MarketGuide.styleMarketItemDetailsHeader;
         this.myItemName.width = NAME_WIDTH;
         this.myItemDescription.width = DESCRIPTION_WIDTH;
         this.myItemDescription.height = DEFAULT_DESCRIPTION_HEIGHT;
         this.myTierLabel.alignment = TextStyle.HALIGN_RIGHT;
         this.myTierLabel.fontColor = GlobalGuide.BLACK;
         this.myTierLabel.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myTierLabel.width = TIER_WIDTH;
         this.myCharacterStatPanel.visible = false;
         this.myNicknameValue.width = this.myNicknameLabel.width = this.myMottoValue.width = this.myMottoLabel.width = NICK_NAME_WIDTH;
         var labelStyle:TextStyle = new TextStyle();
         labelStyle.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         labelStyle.alignment = TextStyle.HALIGN_RIGHT;
         labelStyle.autoSize = TextFieldAutoSize.RIGHT;
         this.myMottoLabel.textStyle = labelStyle;
         this.myNicknameLabel.textStyle = labelStyle;
         this.myMottoValue.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myMottoValue.alignment = TextStyle.HALIGN_RIGHT;
         this.myNicknameValue.font = GlobalGuide.FONT_FACE_BOLD;
         this.myNicknameValue.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myNicknameValue.alignment = TextStyle.HALIGN_RIGHT;
         this.myNicknameValue.height = NICKNAME_HEIGHT;
         this.myMottoLabel.text = LocalizeUtil.localize(DictOnBoard.ONBOARDING_CHARACTER_SELECT_MOTTO).toUpperCase();
         this.myNicknameLabel.text = LocalizeUtil.localize(DictOnBoard.ONBOARDING_CHARACTER_SELECT_NICKNAME).toUpperCase();
         this.myLowerDivider.y = DIVIDER_Y;
         this.myMottoLabel.visible = this.myNicknameLabel.visible = this.myMottoValue.visible = this.myNicknameValue.visible = false;
      }
      
      public function setData(prodData:ProductObj) : void
      {
         if(prodData == null)
         {
            return;
         }
         this.myItemName.text = LocalizeUtil.localize(prodData.name).toUpperCase();
         this.myItemDescription.text = prodData.description;
         this.myImage.setImage(prodData.imageURL);
         this.myImage.addEventListener(Event.COMPLETE,this.onImageLoaded);
         this.myTierLabel.text = LocalizeUtil.localize(MarketItemUtil.ITEM_TIER_LABELS[prodData.tier]).toUpperCase() + " " + LocalizeUtil.localize(MarketItemUtil.GET_ITEM_CATEGORY_BY_GROUP(prodData.group));
         var tierColor:uint = uint(MarketGuide.COLOR_BY_TIER[prodData.tier]);
         GlobalGuide.formatComponentsByTier(tierColor,new <DisplayObject>[this.myTopTierColor]);
         this.myCharacterStatPanel.visible = false;
         this.myItemName.x = this.myFrame.x + this.myFrame.width - (this.myItemName.textWidth + HEADER_PADDING);
         this.myItemDescription.height = DEFAULT_DESCRIPTION_HEIGHT;
      }
      
      public function setCharBioStats(charSelectObj:OnboardCharacterOptionObj) : void
      {
         trace("SETTING BIO STATS");
         this.myCharacterStatPanel.visible = true;
         this.myCharacterStatPanel.setData(charSelectObj);
         this.myMottoValue.text = LocalizeUtil.localize(charSelectObj.characterSlogan).toUpperCase();
         this.myNicknameValue.text = LocalizeUtil.localize(charSelectObj.characterCodeName).toUpperCase();
         this.myMottoLabel.visible = this.myNicknameLabel.visible = this.myMottoValue.visible = this.myNicknameValue.visible = true;
         this.myFrame.height = WITH_BIO_STATS_FRAME_HEIGHT;
         this.myLowerDivider.y = WITH_BIO_STATS_DIVIDER_Y;
         this.myItemDescription.height = ONBOARDING_DESCRIPTION_HEIGHT;
      }
      
      override public function get height() : Number
      {
         return MODULE_HEIGHT;
      }
      
      private function onImageLoaded(e:ParaEvent) : void
      {
         this.myImage.removeEventListener(Event.COMPLETE,this.onImageLoaded);
      }
   }
}

