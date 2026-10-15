package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.PlayerCard;
   import codo.component.social.SocialDropDown;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.objects.ChatMessageObj;
   import codo.objects.PlayerBasicInfoObj;
   import codo.objects.RightClickCustomData;
   import codo.objects.RightClickMenuItemObj;
   import codo.objects.UserObj;
   import codo.utils.LocalizeUtil;
   import codo.utils.PlayerBasicInfoQueryUtil;
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import fsg.util.FsgUtil;
   import scaleform.gfx.MouseEventEx;
   
   public class FloatingPlayerInfoView extends BaseView
   {
      
      private static const PLAYER_CARD_WIDTH:int = 400;
      
      private static const PLAYER_CARD_HEIGHT:int = 70;
      
      private static const PLAYER_CARD_X_MARGIN:int = 30;
      
      private static const CONTEXT_MENU_Y_MARGIN:int = 3;
      
      public var myHitPlace:MovieClip;
      
      public var myPlayerCard:PlayerCard;
      
      public var myDropDown:SocialDropDown;
      
      private var mBasicInfoUtil:PlayerBasicInfoQueryUtil;
      
      private var mRequestUID:String;
      
      private var mRequestName:String;
      
      private var mAnchor1:Point;
      
      private var mAnchor2:Point;
      
      private var mOverWriteBasicInfo:PlayerBasicInfoObj;
      
      public function FloatingPlayerInfoView()
      {
         super();
         this.mRequestUID = "";
         this.myPlayerCard.visible = false;
         this.myDropDown.visible = false;
         this.myPlayerCard.mouseEnabled = this.myPlayerCard.mouseChildren = false;
         this.myHitPlace.mouseEnabled = this.myHitPlace.mouseChildren = false;
         this.myHitPlace.alpha = 0;
         hitArea = this.myHitPlace;
         this.mBasicInfoUtil = new PlayerBasicInfoQueryUtil();
         this.mBasicInfoUtil.registerPlayerBasicInfoHandler(this.onQueryPlayerBasicInfo);
         this.mBasicInfoUtil.registerCompleteHandler(this.onQueryPlayerBasicInfoComplete);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
         if(Boolean(getDP(DataID.ENABLE_FLOATING_PLAYERCARD)))
         {
            listen(BCEvent.EVT_SHOW_PLAYER_CARD,this.onShowPlayerCardHandler);
            listen(BCEvent.EVT_HIDE_PLAYER_CARD,this.onHidePlayerCardHandler);
         }
         listen(BCEvent.EVT_SHOW_PLAYER_CONTEXT_MENU,this.onShowPlayerContextMenu);
         listen(BCEvent.EVT_HIDE_PLAYER_CONTEXT_MENU,this.onHidePlayerContextMenu);
         listen(BCEvent.EVT_PAGE_START_CHANGE,this.onPageChanged);
         stage.addEventListener(MouseEvent.CLICK,this.onStageClicked);
      }
      
      override protected function disableData() : void
      {
         super.disableData();
         if(Boolean(getDP(DataID.ENABLE_FLOATING_PLAYERCARD)))
         {
            unlisten(BCEvent.EVT_SHOW_PLAYER_CARD,this.onShowPlayerCardHandler);
            unlisten(BCEvent.EVT_HIDE_PLAYER_CARD,this.onHidePlayerCardHandler);
         }
         unlisten(BCEvent.EVT_PAGE_START_CHANGE,this.onPageChanged);
         stage.removeEventListener(MouseEvent.CLICK,this.onStageClicked);
      }
      
      private function onShowPlayerCardHandler(evt:ParaEvent) : void
      {
         this.mRequestUID = evt.myPara[0];
         this.mRequestName = evt.myPara[1];
         this.mAnchor1 = evt.myPara[2] as Point;
         this.mAnchor2 = evt.myPara[3] as Point;
         this.mOverWriteBasicInfo = evt.myPara[4] as PlayerBasicInfoObj;
         if(Boolean(this.mOverWriteBasicInfo))
         {
            this.onQueryPlayerBasicInfo(this.mOverWriteBasicInfo);
         }
         else
         {
            this.startQuery();
         }
      }
      
      private function onHidePlayerCardHandler(evt:ParaEvent) : void
      {
         this.mRequestUID = "";
         this.mRequestName = "";
         this.myPlayerCard.visible = false;
      }
      
      private function onShowPlayerContextMenu(evt:ParaEvent) : void
      {
         var positionY:Number = NaN;
         var type:String = evt.myPara[0];
         var id:String = evt.myPara[1];
         var name:String = evt.myPara[2];
         var anchor1:Point = evt.myPara[3] as Point;
         var anchor2:Point = evt.myPara[4] as Point;
         var customData:RightClickCustomData = evt.myPara[5] as RightClickCustomData;
         var userObj:UserObj = new UserObj();
         userObj.id = id;
         userObj.name = name;
         this.fillCustomDataToUser(userObj,customData);
         var options:Vector.<RightClickMenuItemObj> = getDP(DataID.RIGHT_CLICK_MENU,[type,userObj]);
         this.myDropDown.setOptionMenu(options,userObj);
         var positionX:Number = anchor1.x;
         positionY = anchor2.y + CONTEXT_MENU_Y_MARGIN;
         if(positionY + this.myDropDown.height > GameInfo.DEFAULT_HEIGHT)
         {
            positionY = anchor1.y - this.myDropDown.height - CONTEXT_MENU_Y_MARGIN;
         }
         this.myDropDown.x = positionX;
         this.myDropDown.y = positionY;
         this.myDropDown.visible = true;
      }
      
      private function onHidePlayerContextMenu(evt:ParaEvent) : void
      {
         this.myDropDown.visible = false;
      }
      
      private function onQueryPlayerBasicInfo(info:PlayerBasicInfoObj) : void
      {
         if(this.mRequestUID == info.entityID)
         {
            this.myPlayerCard.visible = info.available;
            if(info.available)
            {
               this.fillPlayerCard(info);
            }
            this.positionPlayerCard();
            this.mRequestUID = "";
            this.mRequestName = "";
         }
      }
      
      private function onQueryPlayerBasicInfoComplete() : void
      {
         if(this.mRequestUID != "")
         {
            this.startQuery();
         }
      }
      
      private function startQuery() : void
      {
         if(this.mRequestUID == "")
         {
            return;
         }
         this.mBasicInfoUtil.queryPlayerBasicInfo([this.mRequestUID]);
      }
      
      private function fillPlayerCard(info:PlayerBasicInfoObj) : void
      {
         this.myPlayerCard.setName(this.mRequestName);
         this.myPlayerCard.setClanName(info.clanName);
         this.myPlayerCard.setRank(String(info.level));
         this.myPlayerCard.setPrestige(info.prestige == 0 ? "" : String(info.prestige));
         this.myPlayerCard.setPrestigeIcon(FsgUtil.getPrestigeIcon(info.prestige));
         this.myPlayerCard.setBackground(CFunctionCommonContainer.GetItemInfo(info.playerCardBackground).imageURL);
         this.myPlayerCard.setEmblem(CFunctionCommonContainer.GetItemInfo(info.playerCardBadge).imageURL);
         this.myPlayerCard.setTitle(LocalizeUtil.localize("@" + CFunctionCommonContainer.GetItemInfo(info.playerCardTitle).name));
         this.myPlayerCard.setNameplate(CFunctionCommonContainer.GetItemInfo(info.playerCardNameplate).color);
         this.myPlayerCard.setFrame(CFunctionCommonContainer.GetItemInfo(info.playerCardFrame).imageURL);
      }
      
      private function positionPlayerCard() : void
      {
         var positionX:Number = this.mAnchor2.x + PLAYER_CARD_X_MARGIN;
         var positionY:Number = this.mAnchor1.y;
         if(positionX + PLAYER_CARD_WIDTH > GameInfo.DEFAULT_WIDTH)
         {
            positionX = this.mAnchor1.x - PLAYER_CARD_WIDTH - PLAYER_CARD_X_MARGIN;
         }
         if(positionY + PLAYER_CARD_HEIGHT > GameInfo.DEFAULT_HEIGHT)
         {
            positionY = GameInfo.DEFAULT_HEIGHT - PLAYER_CARD_HEIGHT;
         }
         this.myPlayerCard.x = positionX;
         this.myPlayerCard.y = positionY;
      }
      
      private function onStageClicked(e:MouseEvent) : void
      {
         var evtEx:MouseEventEx = null;
         if(ScaleformUtil.isScaleform)
         {
            evtEx = e as MouseEventEx;
            if(evtEx.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
               this.myDropDown.visible = false;
            }
         }
      }
      
      private function fillCustomDataToUser(userObj:UserObj, customData:RightClickCustomData) : void
      {
         if(customData == null)
         {
            return;
         }
         if(customData.type == RightClickCustomData.TYPE_CHAT_MESSAGE)
         {
            userObj.badLanguage = (customData.content as ChatMessageObj).message;
            userObj.recentChatMessage = getDP(DataID.GET_RECENT_CHAT_MESSAGES,[customData.content]);
         }
      }
      
      private function onPageChanged(cEvt:ParaEvent) : void
      {
         this.myDropDown.visible = false;
      }
   }
}

