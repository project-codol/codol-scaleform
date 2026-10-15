package components.fsgSocialPanel_part
{
   import codo.base.BaseSubElement;
   import codo.component.Button;
   import codo.component.ScrollGrid;
   import codo.component.core.UIInteractiveComponent;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.DictParty;
   import codo.objects.ScrollGridSettings;
   import codo.objects.ScrollListHeaderObj;
   import codo.objects.ScrollListSettings;
   import codo.views.party_parts.MemberItemForParty;
   import flash.utils.getDefinitionByName;
   
   public class FsgPartyStatusPanel extends BaseSubElement
   {
      
      private static const ITEM_LINKAGE:String = "codo.party.memberItemForParty";
      
      private static const ITEM_WIDTH:int = 520;
      
      public var myMemberList:ScrollGrid;
      
      public var myLeaveBtn:Button;
      
      public var myChatBtn:Button;
      
      private var mItemData:Vector.<Object> = new Vector.<Object>();
      
      private var mMembers:Array = [];
      
      private var mPendingMembers:Array = [];
      
      public function FsgPartyStatusPanel()
      {
         var gridSettings:ScrollGridSettings = null;
         super();
         gridSettings = new ScrollGridSettings();
         gridSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         gridSettings.buildGridItemRenderMethod = this.buildMemberItemRender;
         gridSettings.useNavArrows = false;
         gridSettings.barOffsetX = 4;
         this.myMemberList.initGrid(gridSettings,12,false,1);
         this.myLeaveBtn.label = DictParty.LEAVE_PARTY;
         this.myLeaveBtn.width = 138;
         this.myLeaveBtn.height = 30;
         this.myChatBtn.label = DictParty.PARTY_CHATTING;
         this.myChatBtn.width = 138;
         this.myChatBtn.height = 30;
         this.myLeaveBtn.registerClickEvent(this.onLeaveHandler);
         this.myChatBtn.registerClickEvent(this.myChatHandler);
         this.myChatBtn.x = this.myMemberList.x + ITEM_WIDTH - this.myChatBtn.width;
         this.myChatBtn.y = 552;
         this.myLeaveBtn.x = this.myMemberList.x;
         this.myLeaveBtn.y = 552;
      }
      
      override public function active() : void
      {
         super.active();
         bind(DataID.PARTY_INFO,this.bindPartyInfo);
         bind(DataID.PARTY_PENDING_MEMBER,this.bindPartyPendingMember);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         unbind(DataID.PARTY_INFO,this.bindPartyInfo);
         unbind(DataID.PARTY_PENDING_MEMBER,this.bindPartyPendingMember);
      }
      
      private function bindPartyInfo(cRes:Object) : void
      {
         this.data = cRes.data.members;
      }
      
      private function bindPartyPendingMember(cRes:Object) : void
      {
         this.mPendingMembers = cRes.data as Array;
         this.setItemData(this.mMembers,this.mPendingMembers);
      }
      
      public function set data(mData:Array) : void
      {
         for(var i:uint = 0; i < mData.length; i++)
         {
            if(mData[i].isHost == true)
            {
               mData[i].displayName = mData[i].name;
            }
            else
            {
               mData[i].displayName = mData[i].name;
            }
         }
         this.mMembers = mData;
         this.setItemData(this.mMembers,this.mPendingMembers);
      }
      
      private function setItemData(memberList:Array, pendingList:Array) : void
      {
         var header:ScrollListHeaderObj = null;
         var member:Object = null;
         var pendingMember:Object = null;
         var headers:Vector.<ScrollListHeaderObj> = new Vector.<ScrollListHeaderObj>(0);
         header = new ScrollListHeaderObj();
         header.beforeIndex = 0;
         header.count = memberList.length;
         header.label = DictParty.PARTY_MEMBER;
         headers.push(header);
         header = new ScrollListHeaderObj();
         header.beforeIndex = memberList.length;
         header.count = pendingList.length;
         header.label = DictParty.PARTY_PENDING_MEMBER;
         headers.push(header);
         var nowServerTime:uint = getDP(DataID.GET_SERVER_TIME_STAMP);
         this.mItemData.splice(0,this.mItemData.length);
         for each(member in memberList)
         {
            this.mItemData.push(member);
         }
         for each(pendingMember in pendingList)
         {
            pendingMember.serverTime = nowServerTime;
            this.mItemData.push(pendingMember);
         }
         this.myMemberList.setHeaders(headers);
         this.myMemberList.addItemsByVector(this.mItemData);
      }
      
      private function buildMemberItemRender() : UIInteractiveComponent
      {
         var cls:Class = getDefinitionByName(ITEM_LINKAGE) as Class;
         return new cls() as MemberItemForParty;
      }
      
      private function onLeaveHandler() : void
      {
         broadcast(BCEvent.PARTY_LEAVE);
      }
      
      private function myChatHandler() : void
      {
         broadcast(BCEvent.EVT_OPEN_CHAT_WINDOW,{"firstLevelIndex":2});
      }
   }
}

