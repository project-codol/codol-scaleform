package codo.views.friend_parts
{
   import codo.base.BaseSubElement;
   import codo.component.Button;
   import codo.component.ScrollGrid;
   import codo.component.TextField;
   import codo.component.social.InputBox;
   import codo.component.social.SocialMainTab;
   import codo.component.social.SocialTabButton;
   import codo.constants.BCEvent;
   import codo.localization.Dict;
   import codo.localization.DictClan;
   import codo.localization.DictInvitation;
   import codo.localization.DictRightClick;
   import codo.objects.InputBoxSettings;
   import codo.objects.ScrollListSettings;
   import codo.objects.SocialTabSetting;
   import codo.style.FriendGuide;
   import codo.style.GlobalGuide;
   import codo.utils.StringUtil;
   import codo.views.FriendView;
   
   public class SelectorPanel extends BaseSubElement
   {
      
      private static const ITEM_LINKAGE:String = "codo.friend.relationSelector";
      
      private static const GAME_FRIEND_INDEX:int = 0;
      
      private static const QQ_FRIEND_INDEX:int = 1;
      
      public var myMainTab:SocialMainTab;
      
      public var mySelectorList:ScrollGrid;
      
      public var myFriendInviteLabel:TextField;
      
      public var myInviteBtn:Button;
      
      public var myInput:InputBox;
      
      private var mMainTabSelectedIndex:int = -1;
      
      private var mFriendSelectedIndex:int = -1;
      
      private var mQQSelectedIndex:int = -1;
      
      private var mSelectChangeCallback:Function;
      
      private var mGameFriendChannels:Vector.<Object> = new Vector.<Object>();
      
      private var mQQFriendChannels:Vector.<Object> = new Vector.<Object>();
      
      public function SelectorPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         var mainTabSetting:SocialTabSetting = new SocialTabSetting();
         mainTabSetting.needBg = false;
         mainTabSetting.tabSelectedCallback = this.onTabSelectedHandler;
         mainTabSetting.labels = [Dict.FRIEND_CATEGORY_GAME,Dict.FRIEND_CATEGORY_QQ];
         mainTabSetting.padding = 10;
         this.myMainTab.setTabType(SocialTabButton.TYPE_SMALL);
         this.myMainTab.setData(mainTabSetting);
         var inputSetting:InputBoxSettings = new InputBoxSettings();
         inputSetting.hasBg = false;
         inputSetting.showClearButton = false;
         inputSetting.showSearchIcon = false;
         inputSetting.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.myInput.settings = inputSetting;
         var scrollListSetting:ScrollListSettings = new ScrollListSettings();
         scrollListSetting.orientation = ScrollListSettings.SCROLL_VERTICAL;
         scrollListSetting.itemLinkage = ITEM_LINKAGE;
         scrollListSetting.itemPadding = 2;
         this.mySelectorList.initGrid(scrollListSetting,4,false,1);
         this.mGameFriendChannels.push(Dict.CONTACT_FRIEND);
         this.mGameFriendChannels.push(Dict.CONTACT_RECENT);
         this.mGameFriendChannels.push(DictClan.CLAN);
         this.mGameFriendChannels.push(Dict.CONTACT_BLACK_LIST);
         this.mQQFriendChannels.push(Dict.CONTACT_QQ_FRIEND);
         this.mQQFriendChannels.push(Dict.CONTACT_NEARBY);
         this.mySelectorList.selectionChangeCallback = this.onSelectionChangeHandler;
         this.myInviteBtn.width = 160;
         this.myInviteBtn.height = 32;
         this.myInviteBtn.label = DictRightClick.ADD_TO_FRIEND;
         this.myInviteBtn.registerClickEvent(this.onInviteBtnClicked);
         this.myFriendInviteLabel.textStyle = FriendGuide.styleFriendInviteLabel;
         this.myFriendInviteLabel.text = DictInvitation.INVITE_ADD_FRIEND;
      }
      
      override public function active() : void
      {
         super.active();
         this.myMainTab.selectTab(0);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         this.myMainTab.clearSelectedTab();
         this.mySelectorList.resetIndex();
         this.mMainTabSelectedIndex = -1;
      }
      
      private function onTabSelectedHandler(index:int) : void
      {
         if(this.mMainTabSelectedIndex == index)
         {
            return;
         }
         this.mMainTabSelectedIndex = index;
         this.mySelectorList.resetList();
         if(this.mMainTabSelectedIndex == GAME_FRIEND_INDEX)
         {
            this.mySelectorList.addItemsByVector(this.mGameFriendChannels);
            if(this.mFriendSelectedIndex == -1)
            {
               this.mFriendSelectedIndex = this.getSelectorIndexByFriendType(FriendView.FRIEND_INDEX);
            }
            this.mySelectorList.selectedIndex = this.mFriendSelectedIndex;
         }
         else if(this.mMainTabSelectedIndex == QQ_FRIEND_INDEX)
         {
            this.mySelectorList.addItemsByVector(this.mQQFriendChannels);
            if(this.mQQSelectedIndex == -1)
            {
               this.mQQSelectedIndex = this.getSelectorIndexByFriendType(FriendView.QQ_FRIEND_INDEX);
            }
            this.mySelectorList.selectedIndex = this.mQQSelectedIndex;
         }
      }
      
      private function onSelectionChangeHandler() : void
      {
         var selectedIndex:int = int(this.mySelectorList.selectedIndex);
         if(this.mMainTabSelectedIndex == GAME_FRIEND_INDEX)
         {
            this.mFriendSelectedIndex = selectedIndex;
         }
         else
         {
            this.mQQSelectedIndex = selectedIndex;
         }
         if(this.mSelectChangeCallback != null)
         {
            this.mSelectChangeCallback(this.getFriendTypeByIndex(this.mySelectorList.selectedIndex));
         }
      }
      
      private function onInviteBtnClicked() : void
      {
         var name:String = StringUtil.trim(this.myInput.text);
         if(name.length > 0)
         {
            broadcast(BCEvent.EVT_ADD_FRIEND,{
               "isName":true,
               "value":name
            });
         }
      }
      
      public function registerCategoryChangedCallback(callback:Function) : void
      {
         this.mSelectChangeCallback = callback;
      }
      
      private function getSelectorIndexByFriendType(type:int) : int
      {
         if(type < FriendView.MAX_GAME_RELATION)
         {
            return type;
         }
         return type - FriendView.MAX_GAME_RELATION;
      }
      
      private function getFriendTypeByIndex(index:int) : int
      {
         if(this.mMainTabSelectedIndex == GAME_FRIEND_INDEX)
         {
            return index;
         }
         return index + FriendView.MAX_GAME_RELATION;
      }
   }
}

