package codo.views
{
   import codo.base.BaseView;
   import codo.component.social.BaseNotification;
   import codo.component.social.PartyInvitationNotification;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.constants.SystemMsgPriority;
   import codo.localization.Dict;
   import codo.localization.DictParty;
   import codo.localization.DictSystem;
   import codo.objects.PartyInvitationObj;
   import codo.utils.Logger;
   import com.greensock.TimelineLite;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class NotificationStackView extends BaseView
   {
      
      private static const MAX_NOTIFICATION_CAP:int = 4;
      
      private static const ITEM_SHOW_X:int = 1414;
      
      private static const ITEM_SHOW_Y:int = 783;
      
      private static const ITEM_SHOW_Y_OFFSET:int = 200;
      
      private static const ITEM_HIDE_X:int = 1970;
      
      private var mFreeItemPool:Vector.<BaseNotification>;
      
      private var mPartyInvitation:Array;
      
      private var mPendingData:Array;
      
      private var mUsedPartyInvitationList:Vector.<PartyInvitationNotification>;
      
      private var mAnimationSchedule:Vector.<AnimationPlanNode>;
      
      private var mProcessing:Boolean;
      
      private var mTimeline:TimelineLite;
      
      public function NotificationStackView()
      {
         super();
         this.mFreeItemPool = new Vector.<BaseNotification>();
         this.mAnimationSchedule = new Vector.<AnimationPlanNode>();
         this.mUsedPartyInvitationList = new Vector.<PartyInvitationNotification>();
         this.mProcessing = false;
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         bind(DataID.PARTY_INVITATION,this.bindPartyInvitation);
         listen(BCEvent.EVT_MATCH_RESULTS_OPEN,this.matchResultOpening);
         listen(BCEvent.EVT_CLOSE_MATCH_RESULTS,this.matchResultClosing);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         unbind(DataID.PARTY_INVITATION,this.bindPartyInvitation);
         unlisten(BCEvent.EVT_MATCH_RESULTS_OPEN,this.matchResultOpening);
         unlisten(BCEvent.EVT_CLOSE_MATCH_RESULTS,this.matchResultClosing);
      }
      
      private function bindPartyInvitation(cRes:Object) : void
      {
         if(this.mProcessing)
         {
            this.mPendingData = cRes.data as Array;
            return;
         }
         this.mPartyInvitation = cRes.data as Array;
         this.processPartyNotifications();
      }
      
      private function processPartyNotifications() : void
      {
         this.mProcessing = true;
         this.mAnimationSchedule.splice(0,this.mAnimationSchedule.length);
         this.getItemListGoingToShow();
         this.getItemListGoingToHide();
         this.playAnimation();
      }
      
      private function getItemListGoingToShow() : void
      {
         var foundItem:PartyInvitationNotification = null;
         var j:int = 0;
         var pos:Point = null;
         var aniNode:AnimationPlanNode = null;
         var numItemToBeShown:int = 0;
         for(var i:int = 0; i < this.mPartyInvitation.length; i++)
         {
            if(numItemToBeShown == MAX_NOTIFICATION_CAP)
            {
               break;
            }
            foundItem = null;
            for(j = 0; j < this.mUsedPartyInvitationList.length; j++)
            {
               if(Boolean(this.mPartyInvitation[i].equals(this.mUsedPartyInvitationList[j].getData())))
               {
                  foundItem = this.mUsedPartyInvitationList[j];
                  break;
               }
            }
            pos = this.getItemPosition(numItemToBeShown);
            if(!foundItem)
            {
               foundItem = this.buildPartyInvitationNotification();
               this.mUsedPartyInvitationList.push(foundItem);
               foundItem.setData(this.mPartyInvitation[i]);
               foundItem.x = ITEM_HIDE_X;
               foundItem.y = pos.y;
               foundItem.visible = true;
               addChild(foundItem);
            }
            aniNode = new AnimationPlanNode();
            aniNode.targetX = pos.x;
            aniNode.targetY = pos.y;
            aniNode.item = foundItem;
            aniNode.isGoingToShow = true;
            this.mAnimationSchedule.push(aniNode);
            numItemToBeShown++;
         }
      }
      
      private function getItemListGoingToHide() : void
      {
         var isFound:Boolean = false;
         var j:int = 0;
         var target:PartyInvitationNotification = null;
         var aniNode:AnimationPlanNode = null;
         for(var i:int = 0; i < this.mUsedPartyInvitationList.length; i++)
         {
            isFound = false;
            for(j = 0; j < this.mPartyInvitation.length; j++)
            {
               if(Boolean(this.mPartyInvitation[j].equals(this.mUsedPartyInvitationList[i].getData())))
               {
                  isFound = true;
                  break;
               }
            }
            if(!isFound)
            {
               target = this.mUsedPartyInvitationList[i];
               aniNode = new AnimationPlanNode();
               aniNode.targetX = ITEM_HIDE_X;
               aniNode.targetY = target.y;
               aniNode.item = target;
               aniNode.isGoingToShow = false;
               aniNode.animationCompleteHandler = this.onHideAnimationComplete;
               this.mAnimationSchedule.push(aniNode);
            }
         }
      }
      
      private function playAnimation() : void
      {
         if(this.mTimeline != null)
         {
            this.mTimeline.clear();
            this.mTimeline = null;
         }
         this.mTimeline = new TimelineLite({"onComplete":this.playAnimationComplete});
         for(var i:int = 0; i < this.mAnimationSchedule.length; i++)
         {
            this.mTimeline.insert(this.mAnimationSchedule[i].playAnimation());
         }
         this.mTimeline.play();
      }
      
      private function playAnimationComplete() : void
      {
         this.mProcessing = false;
         if(this.mPendingData != null)
         {
            this.mPartyInvitation = this.mPendingData;
            this.processPartyNotifications();
         }
      }
      
      private function onHideAnimationComplete(item:BaseNotification) : void
      {
         if(item.parent == this)
         {
            removeChild(item);
         }
         var index:int = this.mUsedPartyInvitationList.indexOf(item);
         if(index != -1)
         {
            this.mUsedPartyInvitationList.splice(index,1);
         }
         this.mFreeItemPool.push(item);
      }
      
      private function getItemPosition(index:int) : Point
      {
         var pos:Point = new Point();
         pos.x = ITEM_SHOW_X;
         pos.y = ITEM_SHOW_Y - index * ITEM_SHOW_Y_OFFSET;
         return pos;
      }
      
      private function getNotificationFromPool(itemClass:Class) : BaseNotification
      {
         var target:BaseNotification = null;
         var poolSize:int = int(this.mFreeItemPool.length);
         for(var i:int = 0; i < poolSize; i++)
         {
            target = this.mFreeItemPool[i];
            if(target is itemClass)
            {
               this.mFreeItemPool.splice(i,1);
               return target;
            }
         }
         return null;
      }
      
      private function buildPartyInvitationNotification() : PartyInvitationNotification
      {
         var targetItem:BaseNotification = null;
         var definitionClass:Class = null;
         targetItem = this.getNotificationFromPool(PartyInvitationNotification);
         if(targetItem == null)
         {
            definitionClass = getDefinitionByName("codo.notification.partyNotification") as Class;
            Logger.print("NotificationStackView, new a partyNotification.");
            targetItem = new definitionClass() as PartyInvitationNotification;
            targetItem.registerAcceptHandler(this.onAcceptClicked);
            targetItem.registerRejectHandler(this.onRejectClicked);
            targetItem.registerBlockHandler(this.onBlockClicked);
         }
         return targetItem as PartyInvitationNotification;
      }
      
      private function onAcceptClicked(data:Object) : void
      {
         var invitation:PartyInvitationObj = null;
         var acceptHighLatency:Boolean = false;
         var doAccept:Function = null;
         doAccept = function():void
         {
            if(acceptHighLatency)
            {
               broadcast(BCEvent.BOOK_HIGH_LATENCY_TICKET,invitation.ticketID);
            }
            broadcast(BCEvent.EVT_ACCEPT_PARTY_MEMBERSHIP,data);
         };
         invitation = data as PartyInvitationObj;
         acceptHighLatency = false;
         broadcast(BCEvent.BOOK_HIGH_LATENCY_TICKET,"0");
         if(Boolean(getDP(DataID.IS_IN_CROSSZONE)) && (invitation.joinableZones & getDP(DataID.JOINABLE_ZONES)) == 0)
         {
            acceptHighLatency = true;
            showMsg(DictParty.PARTY_ACCEPT_INVITATION_CROSS_ZONE_WARNING,MsgBtnCount.TWO,0,doAccept);
         }
         else
         {
            doAccept();
         }
      }
      
      private function onRejectClicked(data:Object) : void
      {
         broadcast(BCEvent.EVT_REJECT_PARTY_MEMBERSHIP,data);
      }
      
      private function onBlockClicked(data:Object) : void
      {
         var onConfirmBlacklist:Function = null;
         onConfirmBlacklist = function():void
         {
            broadcast(BCEvent.EVT_REJECT_PARTY_MEMBERSHIP,data);
            broadcast(BCEvent.EVT_MOVE_FRIEND_TO_BLACKLIST,{
               "id":data.senderID,
               "name":data.senderName
            });
         };
         showMsg(Dict.BLACKLIST_CONFIRM,MsgBtnCount.TWO,SystemMsgPriority.NORMAL,onConfirmBlacklist,DictSystem.CONFIRM);
      }
      
      private function matchResultOpening() : void
      {
         hideView();
      }
      
      private function matchResultClosing() : void
      {
         showView();
      }
   }
}

import codo.component.social.BaseNotification;
import com.greensock.TweenLite;
import com.greensock.easing.Linear;

class AnimationPlanNode
{
   
   private static const ANIMATION_DURATION:Number = 0.3;
   
   public var item:BaseNotification;
   
   public var targetX:Number;
   
   public var targetY:Number;
   
   public var isGoingToShow:Boolean;
   
   public var animationCompleteHandler:Function;
   
   public function AnimationPlanNode()
   {
      super();
   }
   
   public function playAnimation() : TweenLite
   {
      if(this.isGoingToShow)
      {
         this.item.visible = true;
      }
      return TweenLite.to(this.item,ANIMATION_DURATION,{
         "x":this.targetX,
         "y":this.targetY,
         "ease":Linear.easeNone,
         "onComplete":this.onAnimationComplete
      });
   }
   
   private function onAnimationComplete() : void
   {
      if(!this.isGoingToShow)
      {
         this.item.visible = false;
      }
      if(this.animationCompleteHandler != null)
      {
         this.animationCompleteHandler(this.item);
      }
      this.clean();
   }
   
   private function clean() : void
   {
      this.item = null;
      this.animationCompleteHandler = null;
   }
}
