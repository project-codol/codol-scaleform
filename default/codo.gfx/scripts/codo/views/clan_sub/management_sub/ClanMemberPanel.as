package codo.views.clan_sub.management_sub
{
   import codo.base.BaseSubElement;
   import codo.component.social.ClanMemberItem;
   import codo.component.social.ClanOptionButton;
   import codo.component.social.PageList;
   import codo.component.social.SocialDropDown;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.RightClickMenuType;
   import codo.event.ParaEvent;
   import codo.localization.Dict;
   import codo.localization.DictClan;
   import codo.objects.ClanGlobalConfig;
   import codo.objects.ClanMemberObj;
   import codo.objects.PageListSettings;
   import codo.objects.RightClickMenuItemObj;
   import codo.style.ClanGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.WarGodUtility;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class ClanMemberPanel extends BaseSubElement
   {
      
      private static const MEMBER_ITEM_RENDER:String = "codo.social.clanMemberItem";
      
      private static const DROP_DOWN_PANEL_LINK:String = "codo.social.socialDropDown";
      
      private static const ITEM_COUNT_PER_PAGE:int = 11;
      
      public var myPageList:PageList;
      
      public var myHeader:MovieClip;
      
      private var mOptionMenu:Vector.<RightClickMenuItemObj>;
      
      private var mPageListSetting:PageListSettings;
      
      private var mDropDownMenu:SocialDropDown;
      
      private var mDefaultSortHandler:Function;
      
      private var mClanMembers:Array;
      
      private var mHeaderArr:Array;
      
      private var mMeItemRender:ClanMemberItem;
      
      private var mGlobalConfig:ClanGlobalConfig;
      
      public function ClanMemberPanel()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.mDefaultSortHandler = this.onSortByCCPCurrent;
         this.mOptionMenu = new Vector.<RightClickMenuItemObj>();
         this.myHeader.myWargodTier.label = Dict.LEADERBOARD_WAR_GOD_RANKING;
         this.myHeader.myName.label = DictClan.LIST_TITLE_MEMBER_NAME;
         this.myHeader.myRank.label = DictClan.LIST_TITLE_RANK;
         this.myHeader.myContribution.label = DictClan.LIST_TITLE_CONTRIBUTION;
         this.myHeader.myTitle.label = DictClan.LIST_TITLE_TITLE;
         this.myHeader.myState.label = DictClan.LIST_TITLE_STATE;
         this.initHeaderSortOption();
         this.mPageListSetting = new PageListSettings();
         this.mPageListSetting.itemCountPerPage = ITEM_COUNT_PER_PAGE;
         this.mPageListSetting.itemPadding = 0;
         this.mPageListSetting.renderLinkName = MEMBER_ITEM_RENDER;
         this.mPageListSetting.itemClickHandler = this.invitationItemClicked;
         this.mPageListSetting.itemInteractiveHandler = this.memberItemInteractived;
         this.myPageList.settings = this.mPageListSetting;
         var cls:Class = getDefinitionByName(DROP_DOWN_PANEL_LINK) as Class;
         this.mDropDownMenu = new cls() as SocialDropDown;
      }
      
      private function initHeaderSortOption() : void
      {
         var option:RightClickMenuItemObj = null;
         this.mHeaderArr = [this.myHeader.myWargodTier,this.myHeader.myName,this.myHeader.myRank,this.myHeader.myContribution,this.myHeader.myTitle,this.myHeader.myState];
         var warGodOptions:Vector.<RightClickMenuItemObj> = new Vector.<RightClickMenuItemObj>();
         option = new RightClickMenuItemObj({
            "label":DictClan.MEMBER_SORT_BY_WARGOD,
            "handle":this.onSortByWarGod
         });
         warGodOptions.push(option);
         (this.myHeader.myWargodTier as ClanOptionButton).setOption(warGodOptions);
         var nameOptions:Vector.<RightClickMenuItemObj> = new Vector.<RightClickMenuItemObj>();
         option = new RightClickMenuItemObj({
            "label":DictClan.MEMBER_SORT_BY_NAME,
            "handle":this.onSortByName
         });
         nameOptions.push(option);
         (this.myHeader.myName as ClanOptionButton).setOption(nameOptions);
         var rankOptions:Vector.<RightClickMenuItemObj> = new Vector.<RightClickMenuItemObj>();
         option = new RightClickMenuItemObj({
            "label":DictClan.MEMBER_SORT_BY_RANK,
            "handle":this.onSortByRank
         });
         rankOptions.push(option);
         (this.myHeader.myRank as ClanOptionButton).setOption(rankOptions);
         var ccpOptions:Vector.<RightClickMenuItemObj> = new Vector.<RightClickMenuItemObj>();
         option = new RightClickMenuItemObj({
            "label":DictClan.MEMBER_SORT_BY_CCP_CURRENT,
            "handle":this.onSortByCCPCurrent
         });
         ccpOptions.push(option);
         option = new RightClickMenuItemObj({
            "label":DictClan.MEMBER_SORT_BY_CCP_DAILY,
            "handle":this.onSortByCCPDaily
         });
         ccpOptions.push(option);
         option = new RightClickMenuItemObj({
            "label":DictClan.MEMBER_SORT_BY_CCP_WEEKLY,
            "handle":this.onSortByCCPWeekly
         });
         ccpOptions.push(option);
         (this.myHeader.myContribution as ClanOptionButton).setOption(ccpOptions);
         var titleOptions:Vector.<RightClickMenuItemObj> = new Vector.<RightClickMenuItemObj>();
         option = new RightClickMenuItemObj({
            "label":DictClan.MEMBER_SORT_BY_TITLE,
            "handle":this.onSortByTitle
         });
         titleOptions.push(option);
         (this.myHeader.myTitle as ClanOptionButton).setOption(titleOptions);
         var stateOptions:Vector.<RightClickMenuItemObj> = new Vector.<RightClickMenuItemObj>();
         option = new RightClickMenuItemObj({
            "label":DictClan.MEMBER_SORT_BY_STATE,
            "handle":this.onSortByState
         });
         stateOptions.push(option);
         (this.myHeader.myState as ClanOptionButton).setOption(stateOptions);
      }
      
      override public function active() : void
      {
         super.active();
         bind(DataID.CLAN_MEMBER,this.bind_clanMember);
         bind(DataID.CLAN_MEMBER_INFO,this.bind_clanMemberInfo);
         listen(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodOpenStateChanged);
         this.mGlobalConfig = getDP(DataID.CLAN_GLOBAL_CONFIG);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unbind(DataID.CLAN_MEMBER,this.bind_clanMember);
         unbind(DataID.CLAN_MEMBER_INFO,this.bind_clanMemberInfo);
         unlisten(BCEvent.EVT_WARGOD_OPENING_STATE_CHANGED,this.onWarGodOpenStateChanged);
      }
      
      private function onWarGodOpenStateChanged(cEvt:ParaEvent) : void
      {
         this.myPageList.refresh();
      }
      
      private function bind_clanMember(cRes:Object) : void
      {
         this.mClanMembers = cRes.data;
         this.mDefaultSortHandler();
         this.myPageList.dataProvider = this.mClanMembers;
      }
      
      private function bind_clanMemberInfo(cRes:Object) : void
      {
         this.mDefaultSortHandler();
         this.myPageList.refresh();
      }
      
      private function invitationItemClicked(item:ClanMemberItem, whichButtonClicked:int) : void
      {
         switch(whichButtonClicked)
         {
            case ClanMemberItem.DETAIL_BUTTON_INDEX:
               broadcast(BCEvent.VIEW_PLAYER_DETAIL_INFO,{
                  "id":item.getData().id,
                  "name":item.getData().name
               });
               break;
            case ClanMemberItem.OPTION_BUTTON_INDEX:
               this.showOptionMenu(item);
         }
      }
      
      private function showOptionMenu(item:ClanMemberItem) : void
      {
         var localX:Number;
         var localY:Number;
         var gPoint:Point;
         var lPoint:Point;
         var onStageClicked:Function = null;
         onStageClicked = function(evt:MouseEvent):void
         {
            if(evt.target != item.myOptionBtn.myHitArea)
            {
               removeChild(mDropDownMenu);
               stage.removeEventListener(MouseEvent.CLICK,onStageClicked);
            }
         };
         this.mOptionMenu = getDP(DataID.RIGHT_CLICK_MENU,[RightClickMenuType.FULL,item.getData()]);
         this.mDropDownMenu.setOptionMenu(this.mOptionMenu,item.getData());
         localX = item.myOptionBtn.x + item.myOptionBtn.width - ClanGuide.TOOL_TIP_ITEM_WIDTH;
         localY = item.myOptionBtn.y + item.myOptionBtn.height;
         gPoint = item.localToGlobal(new Point(localX,localY));
         lPoint = globalToLocal(gPoint);
         this.mDropDownMenu.visible = true;
         this.mDropDownMenu.x = lPoint.x;
         this.mDropDownMenu.y = lPoint.y;
         addChild(this.mDropDownMenu);
         stage.addEventListener(MouseEvent.CLICK,onStageClicked);
      }
      
      private function setButtonToggled(toggledButton:ClanOptionButton) : void
      {
         for(var i:int = 0; i < this.mHeaderArr.length; i++)
         {
            (this.mHeaderArr[i] as ClanOptionButton).setToggled(false);
         }
         toggledButton.setToggled(true);
      }
      
      private function onSortByWarGod() : void
      {
         this.mDefaultSortHandler = this.onSortByWarGod;
         if(!this.mClanMembers)
         {
            return;
         }
         this.mClanMembers.sort(this.sortByWarGod);
         this.myPageList.dataProvider = this.mClanMembers;
         this.setButtonToggled(this.myHeader.myWargodTier);
      }
      
      private function onSortByName() : void
      {
         this.mDefaultSortHandler = this.onSortByName;
         if(!this.mClanMembers)
         {
            return;
         }
         this.mClanMembers.sort(this.sortByName);
         this.myPageList.dataProvider = this.mClanMembers;
         this.setButtonToggled(this.myHeader.myName);
      }
      
      private function onSortByRank() : void
      {
         this.mDefaultSortHandler = this.onSortByRank;
         if(!this.mClanMembers)
         {
            return;
         }
         this.mClanMembers.sort(this.sortByRank);
         this.myPageList.dataProvider = this.mClanMembers;
         this.setButtonToggled(this.myHeader.myRank);
      }
      
      private function onSortByCCPCurrent() : void
      {
         var member:ClanMemberObj = null;
         var label:String = null;
         this.mDefaultSortHandler = this.onSortByCCPCurrent;
         if(!this.mClanMembers)
         {
            return;
         }
         for each(member in this.mClanMembers)
         {
            member.selectedCCPValue = member.ccpCurrent;
         }
         this.mClanMembers.sort(this.sortByCCPCurrent);
         this.myPageList.dataProvider = this.mClanMembers;
         this.setButtonToggled(this.myHeader.myContribution);
         label = LocalizeUtil.localize(DictClan.LIST_TITLE_CONTRIBUTION) + LocalizeUtil.localize(DictClan.CCP_SORT_BY_CURRENT);
         (this.myHeader.myContribution as ClanOptionButton).label = label;
      }
      
      private function onSortByCCPDaily() : void
      {
         var member:ClanMemberObj = null;
         var label:String = null;
         this.mDefaultSortHandler = this.onSortByCCPDaily;
         if(!this.mClanMembers)
         {
            return;
         }
         for each(member in this.mClanMembers)
         {
            member.selectedCCPValue = member.ccpDaily;
         }
         this.mClanMembers.sort(this.sortByCCPDaily);
         this.myPageList.dataProvider = this.mClanMembers;
         this.setButtonToggled(this.myHeader.myContribution);
         label = LocalizeUtil.localize(DictClan.LIST_TITLE_CONTRIBUTION) + LocalizeUtil.localize(DictClan.CCP_SORT_BY_DAILY);
         (this.myHeader.myContribution as ClanOptionButton).label = label;
      }
      
      private function onSortByCCPWeekly() : void
      {
         var member:ClanMemberObj = null;
         var label:String = null;
         this.mDefaultSortHandler = this.onSortByCCPWeekly;
         if(!this.mClanMembers)
         {
            return;
         }
         for each(member in this.mClanMembers)
         {
            member.selectedCCPValue = member.ccpWeekly;
         }
         this.mClanMembers.sort(this.sortByCCPWeekly);
         this.myPageList.dataProvider = this.mClanMembers;
         this.setButtonToggled(this.myHeader.myContribution);
         label = LocalizeUtil.localize(DictClan.LIST_TITLE_CONTRIBUTION) + LocalizeUtil.localize(DictClan.CCP_SORT_BY_WEEKLY);
         (this.myHeader.myContribution as ClanOptionButton).label = label;
      }
      
      private function onSortByTitle() : void
      {
         this.mDefaultSortHandler = this.onSortByTitle;
         if(!this.mClanMembers)
         {
            return;
         }
         this.mClanMembers.sort(this.sortByTitle);
         this.myPageList.dataProvider = this.mClanMembers;
         this.setButtonToggled(this.myHeader.myTitle);
      }
      
      private function onSortByState() : void
      {
         this.mDefaultSortHandler = this.onSortByState;
         if(!this.mClanMembers)
         {
            return;
         }
         this.mClanMembers.sort(this.sortByState);
         this.myPageList.dataProvider = this.mClanMembers;
         this.setButtonToggled(this.myHeader.myState);
      }
      
      private function sortByWarGod(memberA:ClanMemberObj, memberB:ClanMemberObj) : Number
      {
         var memberAIndex:int = WarGodUtility.getWarGodTierIndex(memberA);
         var memberBIndex:int = WarGodUtility.getWarGodTierIndex(memberB);
         if(memberAIndex > memberBIndex)
         {
            return -1;
         }
         if(memberAIndex < memberBIndex)
         {
            return 1;
         }
         return this.sortByName(memberA,memberB);
      }
      
      private function sortByName(memberA:ClanMemberObj, memberB:ClanMemberObj) : Number
      {
         if(memberA.name > memberB.name)
         {
            return 1;
         }
         if(memberA.name < memberB.name)
         {
            return -1;
         }
         return 0;
      }
      
      private function sortByRank(memberA:ClanMemberObj, memberB:ClanMemberObj) : Number
      {
         var memberALevel:int = memberA.level == 0 ? 0 : int(memberA.prestige * 100 + memberA.level);
         var memberBLevel:int = memberB.level == 0 ? 0 : int(memberB.prestige * 100 + memberB.level);
         if(memberALevel > memberBLevel)
         {
            return -1;
         }
         if(memberALevel < memberBLevel)
         {
            return 1;
         }
         return this.sortByName(memberA,memberB);
      }
      
      private function sortByCCPCurrent(memberA:ClanMemberObj, memberB:ClanMemberObj) : Number
      {
         if(memberA.ccpCurrent > memberB.ccpCurrent)
         {
            return -1;
         }
         if(memberA.ccpCurrent < memberB.ccpCurrent)
         {
            return 1;
         }
         return this.sortByName(memberA,memberB);
      }
      
      private function sortByCCPDaily(memberA:ClanMemberObj, memberB:ClanMemberObj) : Number
      {
         if(memberA.ccpDaily > memberB.ccpDaily)
         {
            return -1;
         }
         if(memberA.ccpDaily < memberB.ccpDaily)
         {
            return 1;
         }
         return this.sortByName(memberA,memberB);
      }
      
      private function sortByCCPWeekly(memberA:ClanMemberObj, memberB:ClanMemberObj) : Number
      {
         if(memberA.ccpWeekly > memberB.ccpWeekly)
         {
            return -1;
         }
         if(memberA.ccpWeekly < memberB.ccpWeekly)
         {
            return 1;
         }
         return this.sortByName(memberA,memberB);
      }
      
      private function sortByTitle(memberA:ClanMemberObj, memberB:ClanMemberObj) : Number
      {
         if(memberA.clanPos > memberB.clanPos)
         {
            return -1;
         }
         if(memberA.clanPos < memberB.clanPos)
         {
            return 1;
         }
         return this.sortByName(memberA,memberB);
      }
      
      private function sortByState(memberA:ClanMemberObj, memberB:ClanMemberObj) : Number
      {
         if(memberA.friendStatus > memberB.friendStatus)
         {
            return -1;
         }
         if(memberA.friendStatus < memberB.friendStatus)
         {
            return 1;
         }
         return this.sortByName(memberA,memberB);
      }
      
      private function memberItemInteractived(data:Object, whichBehaviour:int) : void
      {
         if(Boolean(data.isMe) && whichBehaviour == ClanMemberItem.ROLL_OVER_INDEX)
         {
            broadcast(BCEvent.SHOW_MY_CCP_STATE,data);
         }
         else
         {
            broadcast(BCEvent.HIDE_MY_CCP_STATE,data);
         }
      }
   }
}

