package codo.views
{
   import codo.common.CFunctionCommonContainer;
   import codo.common.CFunctionContainer;
   import codo.component.Button;
   import codo.component.LoadingSpinner;
   import codo.component.filter.FilterCategoryButton;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.localization.DictMOTD;
   import codo.objects.FilterObj;
   import codo.objects.MOTDMessageObj;
   import codo.services.ChallengeService;
   import codo.theme.BaseTheme;
   import codo.theme.ITheme;
   import codo.utils.DataUtil;
   import codo.utils.TimeUtil;
   import codo.views.motd_parts.MOTDFilterCategoryButton;
   import codo.views.motd_parts.MOTDNotificationsContractsPanel;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   
   public class MOTDNotificationsPopup extends MOTDPopupBaseView
   {
      
      public static const CATEGORY_INDEX_ANNOUNCEMENTS:int = 0;
      
      public static const CATEGORY_INDEX_EVENTS:int = 1;
      
      public static const CATEGORY_INDEX_SYSTEM_NEWS:int = 2;
      
      public static const CATEGORY_INDEX_WELFARE:int = 3;
      
      public static const CATEGORY_INDEX_CONTRACTS:int = 4;
      
      public static const MUTABLE_CATEGORY_COUNT:int = 4;
      
      public static const MAX_VISIBLE_ITEM_COUNT_PER_CATEGORY:int = 10;
      
      private static var mNotificationFilters:Vector.<FilterObj> = new <FilterObj>[new FilterObj(CATEGORY_INDEX_ANNOUNCEMENTS,DictMOTD.NOTIFICATIONS_CATEGORY_ACTIVITY),new FilterObj(CATEGORY_INDEX_EVENTS,DictMOTD.NOTIFICATIONS_CATEGORY_EVENTS),new FilterObj(CATEGORY_INDEX_SYSTEM_NEWS,DictMOTD.NOTIFICATIONS_CATEGORY_ANNOUNCEMENT),new FilterObj(CATEGORY_INDEX_WELFARE,DictMOTD.NOTIFICATIONS_CATEGORY_WELFARE),new FilterObj(CATEGORY_INDEX_CONTRACTS,DictMOTD.NOTIFICATIONS_CATEGORY_OBJECTIVE)];
      
      private var mNotificationData:Array;
      
      private var mContinueButton:Button;
      
      private var mCurrentCategory:MOTDFilterCategoryButton;
      
      private var mDefaultCategory:int = 0;
      
      private var mDefaultIndex:int = 0;
      
      private var mCategoryDirtyFlags:int = 0;
      
      public var myContractStatusDisplay:MOTDNotificationsContractsPanel;
      
      public var myLoadingSpinner:LoadingSpinner;
      
      public function MOTDNotificationsPopup()
      {
         super();
         myPopup.setStyleNoFrame();
         myContentBodyTF.alpha = 0.7;
         myPopup.x = myFilter.x + myFilter.width;
         myPopupHeaderTF.x = myFilter.x;
         this.myContractStatusDisplay.x = 470;
         this.myContractStatusDisplay.y = 77;
         myContentImageHolder.x = 20;
         this.myLoadingSpinner.x = (GameInfo.DEFAULT_WIDTH - this.myLoadingSpinner.width) * 0.5 - 200;
         this.myLoadingSpinner.y = (GameInfo.DEFAULT_HEIGHT - this.myLoadingSpinner.height) * 0.5 - 200;
         this.myLoadingSpinner.visible = false;
      }
      
      override protected function setupThemeVector() : void
      {
         super.setupThemeVector();
         mThemeSetNew.push({
            "clip":myPopup,
            "piece":BaseTheme.THEME_PIECE_POPUP
         });
      }
      
      override protected function onImageLoaded(e:Event) : void
      {
         super.onImageLoaded(e);
         var data:MOTDMessageObj = MOTDFilterCategoryButton(myFilter.currentCategory).selectedItemData;
         if(data.format == MOTDMessageObj.MOTD_FORMAT_TEXT_IMAGE)
         {
            motdTitle = data.caption;
            motdBody = data.message;
            motdDate = data.formattedTime;
            myPopup.visible = true;
            this.positionAssets();
         }
         this.myLoadingSpinner.visible = false;
      }
      
      override protected function initTheme() : void
      {
         super.initTheme();
         myPopupHeaderTF.filters = null;
         var themeSuite:ITheme = getDP(DataID.GET_THEME_SUITE);
         var headerFilters:Array = [new DropShadowFilter(5,113,0,1,15,15),new GlowFilter(themeSuite.getThemeColor(),1,5,5)];
         myPopupHeaderTF.filters = headerFilters;
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         var defaultSelect:Object = data.defaultSelect;
         this.mDefaultCategory = data.category;
         this.mDefaultIndex = data.index;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         this.mNotificationData = CFunctionContainer.AS_GetMOTDMessages();
         this.fillFilterData(this.mDefaultCategory,this.mDefaultIndex);
         headerTitle = LOCALIZE(DictMOTD.NOTIFICATIONS_TITLE_NO_COUNT);
         addEventListener(BCEvent.EVT_CLOSE_MOTD_DASHBOARD,this.hideView);
         this.listen(BCEvent.EVT_MOTD_REFRESH_CATEGORY_DATA,this.onRefreshCategoryData);
      }
      
      override protected function onCategoryCheckedCallback() : void
      {
         this.refreshDirtyCategories(this.mCategoryDirtyFlags);
         this.onSubCategoryCheckedCallback();
      }
      
      override protected function onSubCategoryCheckedCallback() : void
      {
         var isOnboarding:Boolean = false;
         var selectedCategoryIndex:int = myFilter.getSelectedIndex();
         this.mCurrentCategory = myFilter.currentCategory as MOTDFilterCategoryButton;
         if(selectedCategoryIndex != CATEGORY_INDEX_CONTRACTS)
         {
            this.setContent();
            this.myContractStatusDisplay.deactive();
         }
         else
         {
            isOnboarding = ChallengeService.getInstance().showOnboardingChecklist;
            myPopup.width = 955;
            myPopup.height = !isOnboarding ? 831 : 487;
            this.mContinueButton.x = 955 - this.mContinueButton.width;
            this.clearContent();
            this.mCurrentCategory.newItemCount = 0;
            this.myContractStatusDisplay.isOnboarding = isOnboarding;
            this.myContractStatusDisplay.active();
         }
      }
      
      public function onRefreshCategoryData(cEvt:ParaEvent) : void
      {
         var dirtyFlags:int = cEvt.myPara as int;
         this.mCategoryDirtyFlags |= dirtyFlags;
         var selectedCategoryIndex:int = myFilter.getSelectedIndex();
         var refreshFlags:int = this.mCategoryDirtyFlags;
         if(selectedCategoryIndex >= 0)
         {
            refreshFlags &= ~(1 << selectedCategoryIndex);
         }
         this.refreshDirtyCategories(refreshFlags);
      }
      
      override protected function positionView() : void
      {
      }
      
      override protected function transitionInComplete() : void
      {
         this.onSubCategoryCheckedCallback();
      }
      
      override protected function clearContent() : void
      {
         super.clearContent();
         this.myLoadingSpinner.visible = false;
         broadcast(BCEvent.EVT_TRY_CLOSE_WEBIMG);
      }
      
      private function setContent() : void
      {
         var webObj:Object = null;
         var ret:Object = null;
         var WEB_INDEX:int = 0;
         var data:MOTDMessageObj = this.mCurrentCategory.selectedItemData;
         if(data == null)
         {
            return;
         }
         this.clearContent();
         if(this.mContinueButton == null)
         {
            this.mContinueButton = myPopup.getButtonByIndex(0);
         }
         this.mCurrentCategory.setSelectedItemViewed();
         this.mCurrentCategory.updateMessageCount();
         if(data.format == MOTDMessageObj.MOTD_FORMAT_TEXT || data.format == MOTDMessageObj.MOTD_FORMAT_TEXT_IMAGE)
         {
            if(data.imageURL != null)
            {
               this.myLoadingSpinner.visible = true;
               myPopup.visible = false;
               motdImage = data.imageURL;
            }
            else
            {
               motdImage = "";
               myContentDateTF.width = myContentTitleTF.width = myContentBodyTF.width = MAX_POPUP_CONTENT_WIDTH - CONTENT_GUTTER * 2;
               myPopup.width = MAX_POPUP_CONTENT_WIDTH;
               myPopup.visible = true;
               this.mContinueButton.x = MAX_POPUP_CONTENT_WIDTH - this.mContinueButton.width;
               motdTitle = data.caption;
               motdBody = data.message;
               motdDate = data.formattedTime;
               this.positionAssets();
            }
         }
         else
         {
            webObj = data.webData;
            motdImage = "";
            if(!data.beViewed)
            {
               data.beViewed = true;
            }
            myPopup.width = webObj.width + 52;
            myPopup.height = webObj.height + 71;
            myPopup.visible = true;
            this.mContinueButton.x = myPopup.width - this.mContinueButton.width;
            if(data.isFeaturedHomeAd && CFunctionCommonContainer.IsUrlValid(data.id,0) == true)
            {
               WEB_INDEX = 0;
               ret = CFunctionCommonContainer.OpenWebPage(webObj.id,WEB_INDEX,webObj.x,webObj.y,webObj.width,webObj.height);
            }
            else
            {
               ret = CFunctionCommonContainer.OpenWebPageCustom(data.message,webObj.x,webObj.y,webObj.width,webObj.height);
            }
            if(Boolean(ret.succeed))
            {
               webObj.useSkinlessDisplay = true;
               this.broadcast(BCEvent.EVT_SHOW_WEBIMG_CONTAINER,{
                  "data":webObj,
                  "hideTitle":ret.hideTitle
               });
            }
         }
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.clearContent();
         this.mCategoryDirtyFlags = 0;
         this.mNotificationData.length = 0;
         myFilter.overrideIndex = -1;
         myFilter.reset();
         this.myContractStatusDisplay.deactive();
         removeEventListener(BCEvent.EVT_CLOSE_MOTD_DASHBOARD,this.hideView);
         this.unlisten(BCEvent.EVT_MOTD_REFRESH_CATEGORY_DATA,this.onRefreshCategoryData);
         broadcast(BCEvent.EVT_MOTD_CLOSED);
      }
      
      override protected function positionAssets() : void
      {
         var wrapDescription:Boolean = false;
         var scale:Number = NaN;
         var imgHeight:int = 0;
         var widthToSet:int = 0;
         var PADDING:int = 0;
         var remainingWidth:int = 0;
         var heightSet:int = 0;
         super.positionAssets();
         var hasBodyCopy:Boolean = myContentBodyTF.visible;
         var bodyHeight:int = hasBodyCopy ? int(myContentBodyTF.textHeight) : 0;
         var baseHeight:int = myContentDateTF.textHeight + myContentTitleTF.textHeight;
         if(myContentImageHolder.visible)
         {
            wrapDescription = myContentImageHolder.width + CONTENT_PADDING > MAX_POPUP_CONTENT_WIDTH * 0.5;
            if(myContentImageHolder.width > MAX_POPUP_WEB_WIDTH)
            {
               myContentImageHolder.width = myContentBodyTF.width = MAX_POPUP_WEB_WIDTH - CONTENT_GUTTER;
            }
            bodyHeight = myPopupHeaderTF.textHeight + baseHeight + this.mContinueButton.height + CONTENT_GUTTER * 2;
            if(myContentImageHolder.height > MAX_POPUP_WEB_HEIGHT - bodyHeight)
            {
               myContentImageHolder.height = MAX_POPUP_WEB_HEIGHT - bodyHeight;
            }
            scale = Math.min(myContentImageHolder.scaleX,myContentImageHolder.scaleY);
            myContentImageHolder.scaleY = myContentImageHolder.scaleX = scale;
            myContentImageHolder.y = myContentTitleTF.y + myContentTitleTF.textHeight + CONTENT_PADDING * 2;
            imgHeight = myContentImageHolder.height;
            if(hasBodyCopy)
            {
               if(wrapDescription)
               {
                  myContentTitleTF.width = myContentImageHolder.width;
                  myContentBodyTF.y = myContentImageHolder.y + imgHeight + CONTENT_GUTTER;
                  bodyHeight = myContentBodyTF.y + myContentBodyTF.textHeight;
                  widthToSet = Math.max(myContentImageHolder.width + 57,myContentTitleTF.textWidth + 57);
                  myContentBodyTF.width = widthToSet - 57;
                  myPopup.width = widthToSet;
                  this.mContinueButton.x = widthToSet - this.mContinueButton.width;
                  myPopup.height = bodyHeight - 40;
               }
               else
               {
                  PADDING = 60;
                  remainingWidth = MAX_POPUP_WEB_WIDTH - myContentImageHolder.width - PADDING;
                  myContentDateTF.width = myContentTitleTF.width = myContentBodyTF.width = remainingWidth;
                  myContentBodyTF.y = myContentImageHolder.y;
                  myContentBodyTF.x = myContentImageHolder.x + myContentImageHolder.width + CONTENT_PADDING;
                  heightSet = Math.max(myContentImageHolder.height,myContentBodyTF.textHeight + 4);
                  bodyHeight = heightSet;
                  myPopup.width = MAX_POPUP_WEB_WIDTH;
                  myPopup.height = baseHeight + bodyHeight + PADDING;
                  this.mContinueButton.x = MAX_POPUP_WEB_WIDTH - this.mContinueButton.width;
               }
            }
            else
            {
               bodyHeight = imgHeight;
               myPopup.height = baseHeight + bodyHeight;
            }
         }
         else
         {
            myPopup.height = myContentBodyTF.y + myContentBodyTF.textHeight - 50;
         }
      }
      
      override protected function get transitionTargetPoint() : Point
      {
         var pointX:int = (GameInfo.DEFAULT_WIDTH - (myFilter.width + MAX_POPUP_WEB_WIDTH)) * 0.5;
         var pointY:int = 80;
         return new Point(pointX,pointY);
      }
      
      private function returnFilterData() : Array
      {
         var j:int = 0;
         var msgLen:int = 0;
         var notifications:Array = null;
         var notificationItems:Array = null;
         var notificationItem:MOTDMessageObj = null;
         var filter:FilterObj = null;
         var WEB_INDEX:int = 0;
         var ret:Object = null;
         var MIN:Function = Math.min;
         var i:int = 0;
         var len:int = mNotificationFilters.length - 1;
         for(var isFilterEnabled:Boolean = true; i < len; )
         {
            filter = mNotificationFilters[i];
            notifications = this.mNotificationData[i];
            msgLen = MIN(notifications.length,MAX_VISIBLE_ITEM_COUNT_PER_CATEGORY);
            isFilterEnabled = msgLen > 0;
            filter.child = [];
            if(isFilterEnabled)
            {
               notificationItems = [];
               for(j = 0; j < msgLen; j++)
               {
                  notificationItem = new MOTDMessageObj(notifications[j]);
                  notificationItems[j] = notificationItem;
               }
               filter.child = notificationItems;
            }
            filter.enabled = isFilterEnabled || i == CATEGORY_INDEX_CONTRACTS;
            i++;
         }
         notificationItem = new MOTDMessageObj();
         notificationItem.beViewed = true;
         notificationItem.sender = MOTDMessageObj.MOTD_SENDER_TENCENT;
         notificationItem.caption = LOCALIZE(DictMOTD.FEATURE_ANNOUNCEMENT);
         notificationItem.timestamp = TimeUtil.convertToUnix(new Date());
         notificationItem.format = MOTDMessageObj.MOTD_FORMAT_URL;
         notificationItem.isFeaturedHomeAd = true;
         var webObj:Object = notificationItem.webData;
         if(CFunctionCommonContainer.IsUrlValid(webObj.id,0) == true)
         {
            WEB_INDEX = 0;
            ret = CFunctionCommonContainer.OpenWebPage(webObj.id,WEB_INDEX,webObj.x,webObj.y,webObj.width,webObj.height);
            if(Boolean(ret.succeed))
            {
               CFunctionCommonContainer.CloseCurrentWebPage();
               webObj.useSkinlessDisplay = true;
               this.mNotificationData[CATEGORY_INDEX_ANNOUNCEMENTS].unshift(notificationItem);
               mNotificationFilters[CATEGORY_INDEX_ANNOUNCEMENTS].child.unshift(notificationItem);
               mNotificationFilters[CATEGORY_INDEX_ANNOUNCEMENTS].enabled = true;
            }
         }
         return DataUtil.VectorToArray(mNotificationFilters);
      }
      
      private function fillFilterData(category:int, index:int) : void
      {
         var filterData:Array = this.returnFilterData();
         myFilter.setData(filterData,category);
         myFilter.currentCategory.selectIndex(index);
         this.mCategoryDirtyFlags = 0;
      }
      
      private function refreshDirtyCategories(flags:int) : void
      {
         var categoryMark:int = 0;
         var notifications:Array = null;
         var notificationItemData:Array = null;
         var j:int = 0;
         var listData:Array = null;
         var categoryBtn:FilterCategoryButton = null;
         var notificationItem:MOTDMessageObj = null;
         if(flags == 0)
         {
            return;
         }
         for(var i:int = 0; i < MUTABLE_CATEGORY_COUNT; i++)
         {
            categoryMark = 1 << i;
            if((categoryMark & flags) != 0)
            {
               notifications = CFunctionContainer.AS_GetMOTDCategoryMessages(i);
               this.mNotificationData[i] = notifications;
               notificationItemData = [];
               for(j = 0; j < notifications.length; j++)
               {
                  notificationItem = new MOTDMessageObj(notifications[j]);
                  notificationItemData[j] = notificationItem;
               }
               listData = myFilter.getListData();
               listData[i].child = notificationItemData;
               listData[i].enabled = notificationItemData.length > 0;
               categoryBtn = myFilter.getCategoryByIndex(i);
               categoryBtn.setData(listData[i]);
               this.mCategoryDirtyFlags &= ~categoryMark;
            }
         }
      }
   }
}

