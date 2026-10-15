package codo.views
{
   import codo.component.tutorial.UITourToolTip;
   import codo.component.video.VideoPanel;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.constants.PageID;
   import codo.constants.UITutorialFlags;
   import codo.objects.uitour.UITourToolTipObj;
   import codo.style.TutorialGuide;
   import codo.utils.ScaleformUtil;
   import codo.views.uitour.UITourInventoryNewUserEquipAttachment;
   import codo.views.uitour.UITourInventoryNewUserEquipPrimarySecondary;
   import codo.views.uitour.UITourInventoryNewUserGoToPlay;
   import codo.views.uitour.UITourInventoryPick10EquipPerks;
   import codo.views.uitour.UITourInventoryPick10Intro;
   import codo.views.uitour.UITourInventoryPick10WildcardIntro;
   import flash.display.Bitmap;
   import flash.geom.Point;
   
   public class UITutorialInventoryView extends UITutorialBaseView
   {
      
      public var myNewUserEquipPrimarySecondaryWeapon:UITourInventoryNewUserEquipPrimarySecondary;
      
      public var myNewUserEquipAttachment:UITourInventoryNewUserEquipAttachment;
      
      public var myNewUserGoToPlay:UITourInventoryNewUserGoToPlay;
      
      public var myNewUserGoToPlay_cn:UITourInventoryNewUserGoToPlay;
      
      public var myPick10Intro:UITourInventoryPick10Intro;
      
      public var myPick10EquipPerks:UITourInventoryPick10EquipPerks;
      
      public var myPick10WildcardIntro:UITourInventoryPick10WildcardIntro;
      
      public var myVideoPlayerPanel:VideoPanel;
      
      private var mVideoInited:Boolean = false;
      
      private var mInventoryTips:Vector.<UITourToolTipObj>;
      
      public function UITutorialInventoryView()
      {
         super();
         this.myVideoPlayerPanel.visible = false;
         this.mInventoryTips = new <UITourToolTipObj>[new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_INVENTORY_LOADOUT_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_INVENTORY_LOADOUT_DESC",new Point(1270,340),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_LEFT),new UITourToolTipObj(null,UITutorialFlags.NULL,"@UI_TUTORIAL_UI_TOUR_TOOL_TIP_PICK_10_TITLE","@UI_TUTORIAL_UI_TOUR_TOOL_TIP_PICK_10_DESC",new Point(1145,172),true,null,null,null,UITourToolTip.STYLE_1_BTN,UITourToolTip.ARROW_LEFT)];
      }
      
      override protected function showView() : void
      {
         super.showView();
         if(!ScaleformUtil.isScaleform)
         {
            this.myNewUserEquipAttachment.setCallToActionToSecondAttachment();
            return;
         }
         switch(flagID)
         {
            case UITutorialFlags.UI_TOUR_INVENTORY_PICK10_INTRO_VIEWED:
               this.myPick10Intro.myCancelBtn.registerClickEvent(this.onTourCancel);
               this.myPick10Intro.myPlayTourVideoButton.registerClickEvent(this.viewVideoTour);
               this.myPick10Intro.registerCallToActionEvent(this.nextTutorialStep);
               this.myPick10Intro.setToStepIntro();
               break;
            case UITutorialFlags.UI_TOUR_INVENTORY_PICK10_EQUIP_PERK1_VIEWED:
               this.myPick10EquipPerks.equipSlot1();
               break;
            case UITutorialFlags.UI_TOUR_INVENTORY_PICK10_EQUIP_PERK1_SHOW_BAR_VIEWED:
               this.myPick10EquipPerks.equipSlot1CompleteShowPick10Bar(this.nextTutorialStep);
               break;
            case UITutorialFlags.UI_TOUR_INVENTORY_PICK10_WILDCARD_INTRO_VIEWED:
               this.myPick10WildcardIntro.show();
               break;
            case UITutorialFlags.UI_TOUR_INVENTORY_PICK10_WILDCARD_EQUIPPED_VIEWED:
               this.myPick10EquipPerks.equipSlot1CompleteShowPick10Bar(this.nextTutorialStep,true);
               break;
            case UITutorialFlags.UI_TOUR_INVENTORY_PICK10_EQUIP_PERK1_SLOT2_VIEWED:
               this.myPick10EquipPerks.equipSlot2();
               break;
            case UITutorialFlags.UI_TOUR_INVENTORY_PICK10_COMPLETE_VIEWED:
               this.myPick10EquipPerks.equipSlotComplete(this.onTourCancel);
         }
      }
      
      override protected function getToolTips() : Vector.<UITourToolTipObj>
      {
         switch(flagID)
         {
            case UITutorialFlags.UI_TOUR_INVENTORY:
               return this.mInventoryTips;
            default:
               return super.getToolTips();
         }
      }
      
      private function viewVideoTour() : void
      {
         var cover:Bitmap = null;
         if(!this.mVideoInited)
         {
            this.myVideoPlayerPanel.x = GameInfo.stagePosition.x + (GameInfo.stageSize.x - 1280) * 0.5;
            this.myVideoPlayerPanel.initVideoPanel(new Point(1280,720),TutorialGuide.OVERLAY_ALPHA);
            this.myVideoPlayerPanel.fullscreenOffsetPoint = new Point(GameInfo.stagePosition.x,GameInfo.stagePosition.y);
            this.myVideoPlayerPanel.videoPath = "tutorial_pick10";
            this.myVideoPlayerPanel.useLetterBox(false);
            cover = new Bitmap(new uiPick10TutorialOverlay());
            this.myVideoPlayerPanel.videoCoverImage = cover;
            this.myVideoPlayerPanel.onVideoClosedCallback = this.onVideoTourClosed;
            this.mVideoInited = true;
         }
         videoTourOpened = true;
         this.myVideoPlayerPanel.active();
      }
      
      private function onVideoTourClosed() : void
      {
         videoTourOpened = false;
      }
      
      private function onTourCancel() : void
      {
         hideAllTours();
         hideView();
         UITutorialFlags.setNextPick10Step(UITutorialFlags.NULL);
         videoTourOpened = false;
      }
      
      private function nextTutorialStep() : void
      {
         broadcast(BCEvent.EVT_NEXT_TUTORIAL_STEP,PageID.FSG_LOADOUT);
      }
   }
}

