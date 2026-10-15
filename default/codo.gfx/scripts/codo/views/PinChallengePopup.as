package codo.views
{
   import codo.base.PopupView;
   import codo.common.CFunctionCommonContainer;
   import codo.component.CheckBox;
   import codo.component.ScrollList;
   import codo.component.TextField;
   import codo.component.factory.GlobalFactory;
   import codo.localization.Dict;
   import codo.objects.ChallengeBaseObj;
   import codo.objects.ScrollListSettings;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import flash.display.Sprite;
   
   public class PinChallengePopup extends PopupView
   {
      
      private static const POPUP_WIDTH:Number = 500;
      
      private static const POPUP_HEIGHT:Number = 272;
      
      public var myScrollList:ScrollList;
      
      public var myDivider:Sprite;
      
      public var myBacking:Sprite;
      
      public var myDescription:TextField;
      
      private var mChallengeData:ChallengeBaseObj;
      
      private var mNeedReplace:Boolean;
      
      public function PinChallengePopup()
      {
         super();
         myPopup.header.title = LocalizeUtil.localize(Dict.PIN_CHALLENGE_POPUP_HEADER);
         myPopup.width = POPUP_WIDTH;
         myPopup.configConfirmButton(Dict.CONFIRM,this.onConfirm);
         var listSettings:ScrollListSettings = new ScrollListSettings();
         listSettings.useMask = false;
         listSettings.useNavArrows = false;
         listSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         listSettings.buildGridItemRenderMethod = GlobalFactory.BUILD_CHECKBOX;
         this.myScrollList.settings = listSettings;
         this.myDescription.textStyle = GlobalGuide.styleTextDescription;
         this.myDescription.width = POPUP_WIDTH - 60;
      }
      
      override protected function showView() : void
      {
         var pinned:ChallengeBaseObj = null;
         super.showView();
         var unpinID:int = -1;
         this.mNeedReplace = false;
         var freeSlot:uint = ChallengeBaseObj.MAX_PINNED;
         for(var i:uint = ChallengeBaseObj.MAX_PINNED - 1; i < ChallengeBaseObj.MAX_PINNED; i--)
         {
            pinned = CFunctionCommonContainer.GetPinnedChallenge(i);
            if(pinned == null)
            {
               freeSlot = i;
            }
            else if(pinned.profileID == this.mChallengeData.profileID)
            {
               unpinID = pinned.profileID;
            }
         }
         if(unpinID == -1)
         {
            if(freeSlot < ChallengeBaseObj.MAX_PINNED)
            {
               CFunctionCommonContainer.PinChallenge(freeSlot,this.mChallengeData);
            }
            else
            {
               this.mNeedReplace = true;
            }
         }
         this.refreshList(unpinID);
         this.myDivider.y = this.myDescription.y + this.myDescription.textHeight + 20;
         this.myBacking.y = this.myDivider.y + this.myDivider.height;
         this.myScrollList.y = this.myBacking.y + 20;
         this.myBacking.height = this.myScrollList.y + this.myScrollList.height - this.myBacking.y + 20;
         myPopup.height = this.myBacking.y + this.myBacking.height - 30;
      }
      
      override protected function hideView() : void
      {
         var i:uint = 0;
         var checkBox:CheckBox = null;
         var checkData:Object = null;
         var chall:ChallengeBaseObj = null;
         super.hideView();
         var pinned:Vector.<ChallengeBaseObj> = new Vector.<ChallengeBaseObj>(0);
         for(i = 0; i < this.myScrollList.listData.length; i++)
         {
            checkBox = this.myScrollList.getItem(i) as CheckBox;
            if(checkBox.checked)
            {
               checkData = checkBox.getData();
               pinned.push(checkData.challenge);
            }
         }
         for(i = 0; i < ChallengeBaseObj.MAX_PINNED; i++)
         {
            chall = i < pinned.length ? pinned[i] : null;
            CFunctionCommonContainer.PinChallenge(i,chall);
         }
      }
      
      override public function set routeData(data:*) : void
      {
         super.routeData = data;
         this.mChallengeData = data as ChallengeBaseObj;
      }
      
      private function onUnchecked(selectedOption:CheckBox) : void
      {
         if(!this.mNeedReplace)
         {
            return;
         }
         this.mNeedReplace = false;
         var checkData:Object = selectedOption.getData();
         CFunctionCommonContainer.PinChallenge(checkData.index,this.mChallengeData);
         this.refreshList();
      }
      
      private function refreshList(unpinID:int = -1) : void
      {
         var challenge:ChallengeBaseObj = null;
         var checkData:Object = null;
         var text:String = this.mNeedReplace ? "@SF_UI_PIN_CHALLENGE_REPLACE" : Dict.PIN_CHALLENGE_POPUP_INSTRUCTIONS;
         this.myDescription.text = LocalizeUtil.localize(text);
         var challengeList:Vector.<Object> = new Vector.<Object>(0);
         for(var i:uint = 0; i < ChallengeBaseObj.MAX_PINNED; i++)
         {
            challenge = CFunctionCommonContainer.GetPinnedChallenge(i);
            if(challenge != null)
            {
               checkData = {};
               checkData.index = challengeList.length;
               checkData.label = challenge.name;
               checkData.unCheckEvent = this.onUnchecked;
               checkData.canUnselectClick = true;
               checkData.checked = challenge.profileID != unpinID;
               checkData.challenge = challenge;
               challengeList.push(checkData);
            }
         }
         this.myScrollList.addItemsByVector(challengeList);
      }
      
      private function onConfirm() : void
      {
         closePopupView();
      }
   }
}

