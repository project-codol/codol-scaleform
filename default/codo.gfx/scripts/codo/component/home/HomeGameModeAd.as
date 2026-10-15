package codo.component.home
{
   import codo.component.CallToActionButton;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.PlayListType;
   import codo.localization.Dict;
   import codo.localization.DictMarket;
   import codo.manager.EventManager;
   import codo.objects.PlayListObj;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   import fsg.util.FsgImageHolder;
   
   public class HomeGameModeAd extends UIInteractiveComponent
   {
      
      public var myPlayButton:CallToActionButton;
      
      public var myImage:FsgImageHolder;
      
      public var myBackground:Sprite;
      
      public var myModeName:TextField;
      
      public var myModeType:TextField;
      
      public var myModeDescription:TextField;
      
      private var mModeData:PlayListObj;
      
      public function HomeGameModeAd()
      {
         super();
         this.myModeName.width = this.myBackground.width;
         this.myModeName.font = GlobalGuide.FONT_FACE_BOLD;
         this.myModeName.fontSize = GlobalGuide.FONT_SIZE_GIGANTIC;
         this.myModeName.height = 75;
         this.myModeType.width = this.myBackground.width;
         this.myModeType.font = GlobalGuide.FONT_FACE_BOLD;
         this.myModeType.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myModeDescription.wordWrap = true;
         this.myModeDescription.fontSize = GlobalGuide.FONT_SIZE_MEDIUM_SMALL;
         this.myModeDescription.width = 324;
         this.myModeDescription.height = 75;
         this.myModeDescription.maxLines = 3;
         this.myPlayButton.label = LocalizeUtil.localize(Dict.LANDING_AD_BUTTON_LABEL);
         this.myPlayButton.registerClickEvent(this.onPlayClicked);
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.mModeData = data as PlayListObj;
         this.myModeType.text = PlayListType.isPveType(this.mModeData.type) ? DictMarket.MARKET_ITEM_PVE : DictMarket.MARKET_ITEM_PVP;
         this.myImage.setImage(this.mModeData.getImage());
         this.myModeName.text = LocalizeUtil.localize(this.mModeData.overridename != "" ? this.mModeData.overridename : this.mModeData.name).toUpperCase();
         this.myModeDescription.text = LocalizeUtil.localize(this.mModeData.overridedescription != "" ? this.mModeData.overridedescription : this.mModeData.description);
      }
      
      override public function get width() : Number
      {
         return 740;
      }
      
      override public function get height() : Number
      {
         return 331;
      }
      
      private function onPlayClicked() : void
      {
         if(Boolean(this.mModeData))
         {
            EventManager.getInstance().broadcast(this.mModeData.getGotoMatchMainPageEvent(),{"playlist":this.mModeData});
         }
      }
   }
}

