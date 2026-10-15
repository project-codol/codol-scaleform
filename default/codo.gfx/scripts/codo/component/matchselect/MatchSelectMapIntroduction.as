package codo.component.matchselect
{
   import codo.component.IconButton;
   import codo.component.ScrollList;
   import codo.component.TextField;
   import codo.constants.BCEvent;
   import codo.manager.EventManager;
   import codo.objects.MapIllustrationObj;
   import codo.objects.ScrollListSettings;
   import codo.style.MatchSelectGuide;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class MatchSelectMapIntroduction extends MovieClip
   {
      
      public var myVideoMask:VideoMask;
      
      public var myBigImage:FsgImageHolder;
      
      public var myExpandButton:IconButton;
      
      public var myMapDesc:TextField;
      
      public var myMapDescBg:MovieClip;
      
      public var myMapList:ScrollList;
      
      private var mData:Vector.<Object>;
      
      private var mSelectedMap:MapIllustrationObj;
      
      public function MatchSelectMapIntroduction()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myMapDesc.textStyle = MatchSelectGuide.styleMapDesc;
         this.myMapDesc.width = 503;
         this.myMapDesc.height = 47;
         this.myMapDesc.x = 14;
         this.myMapDesc.y = 357;
         var listSetting:ScrollListSettings = new ScrollListSettings();
         listSetting.itemPadding = 5;
         listSetting.itemLinkage = "codo.matchselect.mapSmallIntroduction";
         listSetting.hideScrollBar = true;
         listSetting.autoSize = false;
         this.myMapList.settings = listSetting;
         this.myMapList.myNavArrowLeft.scaleX = this.myMapList.myNavArrowLeft.scaleY = 0.76;
         this.myMapList.myNavArrowRight.scaleX = -0.76;
         this.myMapList.myNavArrowRight.scaleY = 0.76;
         this.myMapList.width = 454;
         this.myMapList.height = 107;
         this.myMapList.selectionChangeCallback = this.onSelectionChangeCallback;
         this.myVideoMask.registerClickEvent(this.onStartPlayVideo);
         this.myExpandButton.setImage("expand_icon");
         this.myExpandButton.setMarketReadyMode(true);
         this.myExpandButton.x = 453;
         this.myExpandButton.y = 358;
         this.myExpandButton.registerClickEvent(this.onExpandButtonClicked);
         this.myExpandButton.visible = false;
      }
      
      public function setData(mapIllustrations:Vector.<Object>) : void
      {
         this.mData = mapIllustrations;
         this.myMapList.addItemsByVector(this.mData);
         if(this.mData.length > 0)
         {
            this.myMapList.selectedIndex = 0;
         }
      }
      
      private function onSelectionChangeCallback() : void
      {
         this.mSelectedMap = this.myMapList.selectedData as MapIllustrationObj;
         this.myBigImage.setImage(this.mSelectedMap.imageURL);
         this.myMapDesc.text = this.mSelectedMap.desc;
         this.myVideoMask.visible = this.mSelectedMap.videoURL != "";
      }
      
      private function onStartPlayVideo() : void
      {
         if(Boolean(this.mSelectedMap))
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_OPEN_GAME_MODE_TUTORIAL,this.mSelectedMap.mode);
         }
      }
      
      private function onExpandButtonClicked() : void
      {
         var isVideo:Boolean = this.mSelectedMap.videoURL != "";
         if(isVideo)
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_OPEN_GAME_MODE_TUTORIAL,this.mSelectedMap.mode);
         }
         else
         {
            EventManager.getInstance().broadcast(BCEvent.EVT_OPEN_GAME_MODE_IMAGE,this.mSelectedMap);
         }
      }
   }
}

