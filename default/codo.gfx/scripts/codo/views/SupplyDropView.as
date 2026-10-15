package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.CallToActionButton;
   import codo.component.LoadingSpinner;
   import codo.constants.BCEvent;
   import codo.constants.ButtonTLog;
   import codo.constants.DataID;
   import codo.constants.MarketMenuData;
   import codo.constants.UIAnimScheduleFlag;
   import codo.constants.UIViewerAnimType;
   import codo.constants.WebImgData;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.objects.ProductObj;
   import codo.objects.VideoPlayerObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.ScaleformUtil;
   import codo.utils.TLogUtil;
   import codo.views.persistentView_parts.GameOptionBtn;
   import codo.views.supplyDrop_parts.FeaturedSupplyDropRewardItemPanelDecorator;
   import codo.views.supplyDrop_parts.GuaranteedSupplyDropRewardPanelDecorator;
   import codo.views.supplyDrop_parts.SupplyDropOpenPanel;
   import codo.views.supplyDrop_parts.SupplyDropRewardItemPanel;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.Timer;
   import fsg.shared.BehaviourClickable;
   
   public class SupplyDropView extends BaseView
   {
      
      public var mySupplyDropRewardItemPanel:SupplyDropRewardItemPanel;
      
      public var mySupplyDropOpenPanel:SupplyDropOpenPanel;
      
      public var mySupplyDropFeaturedItemPanel:SupplyDropRewardItemPanel;
      
      public var myBackButton:CallToActionButton;
      
      public var myLoadingSpinner:LoadingSpinner;
      
      public var myTitleTF:TextField;
      
      public var myQuitBtn:GameOptionBtn;
      
      public var myOptionBtn:GameOptionBtn;
      
      public var myLapTopScreenArea:MovieClip;
      
      private var mIdleTimer:Timer;
      
      private var mIdleCuesPlayed:int;
      
      private var mMaxIdleCues:int;
      
      private var mSpecialNagCue:int;
      
      private var mSupplyDropCount:int;
      
      private var mIntroPlayCounter:int;
      
      private var mLoopIdle:Boolean;
      
      private var mLapTopScreenClickBehavior:BehaviourClickable;
      
      public function SupplyDropView()
      {
         super();
         this.myBackButton.registerClickEvent(this.onBackButtonClicked);
         this.myBackButton.label = LocalizeUtil.localize(Dict.BACK_WITH_ESCAPE);
         this.myQuitBtn.addClickCallback(this.onQuit,"ui_exitgame_button_click_01");
         this.myOptionBtn.addClickCallback(this.onDisplayOptions,"ui_settingsgear_button_click_01");
         this.mIdleTimer = new Timer(30000,1);
         this.myLoadingSpinner.visible = false;
         this.myTitleTF.text = ScaleformUtil.isScaleform ? Dict.MAIN_MENU_LABEL_SUPPLY_DROPS : "军火黑市";
         this.mIntroPlayCounter = 0;
         this.mMaxIdleCues = 3;
         this.mySupplyDropOpenPanel.registerToggleItemPreviewBoxHandler(this.togglePreviewItemBox);
         this.mLapTopScreenClickBehavior = new BehaviourClickable(this.myLapTopScreenArea);
         this.mLapTopScreenClickBehavior.addClickCallback(this.onPlayVideo);
         this.mLoopIdle = false;
      }
      
      private function onQuit() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_EXIT_GAME);
         this.broadcast(BCEvent.TRYOPEN_QUESTIONNAIRE);
      }
      
      private function onDisplayOptions() : void
      {
         TLogUtil.TLog_UserInput(ButtonTLog.BUTTON_SETTINGS);
         this.broadcast(BCEvent.EVT_GOTO_OPTION);
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.mySupplyDropRewardItemPanel.decorator = new GuaranteedSupplyDropRewardPanelDecorator(this.mySupplyDropRewardItemPanel);
         this.mySupplyDropFeaturedItemPanel.decorator = new FeaturedSupplyDropRewardItemPanelDecorator(this.mySupplyDropFeaturedItemPanel);
         this.mySupplyDropOpenPanel.active();
         if(Boolean(CFunctionCommonContainer.IsInRoom()))
         {
            listen(BCEvent.ALL_READY,this.onBackButtonClicked);
         }
         listen(BCEvent.EVT_UIVIEWER_MODEL_LOAD_STATE_UPDATE,this.onUiViewerModelLoadStateUpdate);
         listen(BCEvent.EVT_UIVIEWER_ANIM_TYPE_END,this.onUiViewerAnimTypeEnd);
         listen(BCEvent.EVT_MARKET_PURCHASE_POPUP_CLOSE_SUCCESS,this.onPurchaseSuccess);
         listen(BCEvent.EVT_MARKET_PURCHASE_TASK_FAIL,this.onPurchaseFail);
         listen(BCEvent.EVT_MARKET_PURCHASE_POPUP,this.onMarketPurchasePopup);
         listen(BCEvent.EVT_MARKET_PURCHASE_CANCEL,this.onMarketPurchaseCancel);
         listen(BCEvent.EVT_FORCE_REFRESH_SUPPLY_DROP_VIEW,this.onRefreshSupplyDropView);
         this.onRefreshSupplyDropView(null);
         this.mLoopIdle = false;
         this.mIdleTimer.start();
         this.mIdleTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.cueIdleAnimation);
         this.mIdleCuesPlayed = 0;
         var min:int = 1;
         var max:int = this.mMaxIdleCues + 1;
         this.mSpecialNagCue = min + (max - min) * Math.random();
         bind(DataID.SUPPLY_DROP_COUNT,this.checkResetIdleTimer);
      }
      
      private function onRefreshSupplyDropView(evt:ParaEvent) : void
      {
         this.initRewardItemDisplay();
         this.mySupplyDropOpenPanel.forceRefresh();
         broadcast(BCEvent.EVT_REFRESH_UI_AFTER_INVENTORY_CHANGE);
      }
      
      private function initRewardItemDisplay() : void
      {
         var featureItemsEnabled:Boolean = false;
         if(!this.inDebugMode)
         {
            featureItemsEnabled = CFunctionContainer.AS_SupplyDropFeaturedItemEnabled(MarketMenuData.SUPPLY_DROP_ADVANCED) as Boolean;
            if(featureItemsEnabled)
            {
               this.mySupplyDropFeaturedItemPanel.items = this.getFeatureAdvancedItems(true);
            }
            else
            {
               this.mySupplyDropFeaturedItemPanel.items = new Vector.<ProductObj>(0);
            }
            this.mySupplyDropRewardItemPanel.items = this.getFeatureAdvancedItems();
         }
         this.mySupplyDropRewardItemPanel.active();
         this.mySupplyDropFeaturedItemPanel.active();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.mySupplyDropOpenPanel.deactive();
         this.mySupplyDropFeaturedItemPanel.deactive();
         this.mySupplyDropRewardItemPanel.deactive();
         broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
         unlisten(BCEvent.ALL_READY,this.onBackButtonClicked);
         unlisten(BCEvent.EVT_UIVIEWER_MODEL_LOAD_STATE_UPDATE,this.onUiViewerModelLoadStateUpdate);
         unlisten(BCEvent.EVT_UIVIEWER_ANIM_TYPE_END,this.onUiViewerAnimTypeEnd);
         unlisten(BCEvent.EVT_MARKET_PURCHASE_POPUP_CLOSE_SUCCESS,this.onPurchaseSuccess);
         unlisten(BCEvent.EVT_MARKET_PURCHASE_TASK_FAIL,this.onPurchaseFail);
         unlisten(BCEvent.EVT_MARKET_PURCHASE_POPUP,this.onMarketPurchasePopup);
         unlisten(BCEvent.EVT_MARKET_PURCHASE_CANCEL,this.onMarketPurchaseCancel);
         unlisten(BCEvent.EVT_FORCE_REFRESH_SUPPLY_DROP_VIEW,this.onRefreshSupplyDropView);
         this.myLoadingSpinner.visible = false;
         this.mIdleTimer.reset();
         this.mIdleTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.cueIdleAnimation);
         this.mIdleCuesPlayed = 0;
         unbind(DataID.SUPPLY_DROP_COUNT,this.checkResetIdleTimer);
         this.mLoopIdle = true;
         CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimIdle,uint(UIAnimScheduleFlag.PLAY_AFTER_CURRENT | UIAnimScheduleFlag.LOOP));
      }
      
      protected function onBackButtonClicked() : void
      {
         broadcast(BCEvent.GOTO_PREV_MAIN_PAGE);
      }
      
      private function onUiViewerModelLoadStateUpdate(e:ParaEvent) : void
      {
         var isLoading:Boolean = false;
         isLoading = e.myPara;
         this.myLoadingSpinner.visible = isLoading;
         if(!isLoading)
         {
            if(this.mIntroPlayCounter == 0)
            {
               CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimFirstIntro,UIAnimScheduleFlag.NO_BLEND_IN);
            }
            else if(this.mIntroPlayCounter < 5)
            {
               CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimIntro,UIAnimScheduleFlag.NO_BLEND_IN);
            }
            else
            {
               CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimIdle,UIAnimScheduleFlag.NO_BLEND_IN);
            }
            this.mIntroPlayCounter += 1;
         }
      }
      
      private function onUiViewerAnimTypeEnd(e:ParaEvent) : void
      {
         var animType:uint = e.myPara;
         if(animType == UIViewerAnimType.kAnimFirstIntro)
         {
            if(!this.mLoopIdle && Boolean(CFunctionContainer.AS_IsSupplyDropForSale(MarketMenuData.SUPPLY_DROP_EVENT)))
            {
               CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimFidgetSpecial,UIAnimScheduleFlag.WAIT_FOR_IDLE);
            }
         }
         else if(animType == UIViewerAnimType.kAnimFidgetNag || animType == UIViewerAnimType.kAnimFidgetSpecial)
         {
            if(!this.mLoopIdle && this.mIdleCuesPlayed < this.mMaxIdleCues)
            {
               this.mIdleTimer.start();
            }
         }
      }
      
      private function cueIdleAnimation(e:TimerEvent) : void
      {
         ++this.mIdleCuesPlayed;
         if(Boolean(CFunctionContainer.AS_IsSupplyDropForSale(MarketMenuData.SUPPLY_DROP_EVENT)) && this.mIdleCuesPlayed == this.mSpecialNagCue)
         {
            CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimFidgetSpecial,UIAnimScheduleFlag.WAIT_FOR_IDLE);
         }
         else
         {
            CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimFidgetNag,UIAnimScheduleFlag.WAIT_FOR_IDLE);
         }
         this.mIdleTimer.reset();
      }
      
      private function checkResetIdleTimer(cRes:Object) : void
      {
         var min:int = 0;
         var max:int = 0;
         var supplyDropCount:int = int(cRes.data.total);
         if(supplyDropCount != this.mSupplyDropCount)
         {
            this.mSupplyDropCount = supplyDropCount;
            this.mIdleCuesPlayed = 0;
            min = 1;
            max = this.mMaxIdleCues + 1;
            this.mSpecialNagCue = min + (max - min) * Math.random();
            this.mIdleTimer.reset();
            this.mIdleTimer.start();
         }
      }
      
      private function get inDebugMode() : Boolean
      {
         return !ScaleformUtil.isScaleform;
      }
      
      private function getFeatureAdvancedItems(getGuaranteed:Boolean = false) : Vector.<ProductObj>
      {
         var item:ProductObj = null;
         var sampleItems:Array = null;
         var featuredItem:Object = null;
         var sampleItem:Object = null;
         var GET_ITEM_INFO:Function = CFunctionCommonContainer.GetItemInfo;
         var GET_BUNDLE_INFO:Function = CFunctionCommonContainer.GetBundleInfo;
         var items:Vector.<ProductObj> = new Vector.<ProductObj>(0);
         if(getGuaranteed)
         {
            sampleItems = CFunctionContainer.AS_GetSupplyDropFeaturedItems(MarketMenuData.SUPPLY_DROP_ADVANCED);
            for each(featuredItem in sampleItems)
            {
               if(featuredItem.item != 0)
               {
                  item = GET_ITEM_INFO(featuredItem.item);
               }
               else
               {
                  item = GET_BUNDLE_INFO(featuredItem.product);
               }
               items.push(item);
            }
         }
         else
         {
            sampleItems = CFunctionContainer.AS_GetSupplyDropSampleItems(MarketMenuData.SUPPLY_DROP_ADVANCED);
            for each(sampleItem in sampleItems)
            {
               if(sampleItem.isRecommended)
               {
                  if(sampleItem.item != 0)
                  {
                     item = GET_ITEM_INFO(sampleItem.item);
                  }
                  else
                  {
                     item = GET_BUNDLE_INFO(sampleItem.product);
                  }
                  items.push(item);
               }
            }
         }
         return items;
      }
      
      private function onMarketPurchasePopup(evt:ParaEvent) : void
      {
         this.mLoopIdle = true;
         this.mIdleTimer.reset();
         CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimIdle,uint(UIAnimScheduleFlag.PLAY_AFTER_CURRENT | UIAnimScheduleFlag.LOOP));
      }
      
      private function onMarketPurchaseCancel(evt:ParaEvent) : void
      {
         this.mLoopIdle = false;
         this.mIdleTimer.start();
         CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimIdle,UIAnimScheduleFlag.PLAY_AFTER_CURRENT);
      }
      
      private function onPurchaseSuccess(evt:ParaEvent) : void
      {
         this.mLoopIdle = false;
         this.mIdleTimer.reset();
         this.mIdleTimer.start();
         CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimPurchaseSuccess,UIAnimScheduleFlag.ONLY_BLEND_IN_FROM_IDLE);
      }
      
      private function onPurchaseFail(evt:ParaEvent) : void
      {
         this.mLoopIdle = false;
         this.mIdleTimer.reset();
         this.mIdleTimer.start();
         CFunctionContainer.CL_PlayAnimation(UIViewerAnimType.kAnimPurchaseFailure,UIAnimScheduleFlag.ONLY_BLEND_IN_FROM_IDLE);
      }
      
      private function togglePreviewItemBox(isShow:Boolean, data:ProductObj) : void
      {
         if(isShow)
         {
            if(data != null)
            {
               broadcast(BCEvent.EVT_SHOW_ITEM_INFO_PREVIEW,{
                  "product":data,
                  "compare":false
               });
            }
         }
         else
         {
            broadcast(BCEvent.EVT_HIDE_ITEM_INFO_PREVIEW);
         }
      }
      
      private function onPlayVideo() : void
      {
         var ret:Object = null;
         var param:VideoPlayerObj = null;
         var videoUrl:String = CFunctionCommonContainer.Dvar_GetString("ui_awesome_supply_drop_video_url");
         if(videoUrl != null && videoUrl != "")
         {
            ret = CFunctionCommonContainer.OpenWebPageCustom(videoUrl,WebImgData.SUPPLY_DROP_ITEMS.x,WebImgData.SUPPLY_DROP_ITEMS.y,WebImgData.SUPPLY_DROP_ITEMS.width,WebImgData.SUPPLY_DROP_ITEMS.height) as Object;
            if(Boolean(ret.succeed))
            {
               this.broadcast(BCEvent.EVT_SHOW_WEBIMG_CONTAINER,{
                  "data":WebImgData.SUPPLY_DROP_ITEMS,
                  "hideTitle":ret.hideTitle
               });
               return;
            }
         }
         var videoPath:String = CFunctionCommonContainer.Dvar_GetString("ui_awesome_supply_drop_video_path");
         if(videoPath != null && videoPath != "")
         {
            param = new VideoPlayerObj(videoPath,new Point(1024,768));
            broadcast(BCEvent.EVT_GOTO_VIDEO_PLAYER_VIEW,param);
            return;
         }
      }
   }
}

