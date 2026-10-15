package codo.views.matchResults_parts
{
   import codo.base.BaseSubElement;
   import codo.component.IconButton;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.localization.DictMatchResults;
   import codo.localization.DictRightClick;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.text.TextField;
   import fsg.shared.BehaviourClickable;
   import fsg.shared.BehaviourTooltip;
   
   public class MatchResultBuddyName extends BaseSubElement
   {
      
      private static const ADD_BUTTON_WIDTH:int = 40;
      
      private static const ADD_BUTTON_HEIGHT:int = 35;
      
      private static const ADD_BUTTON_X:int = 438;
      
      private static const ADD_BUTTON_Y:int = 36;
      
      public var myName:TextField;
      
      public var myTitle:TextField;
      
      public var myAddButton:IconButton;
      
      public var myBg:MovieClip;
      
      private var mUserID:String;
      
      private var mUserName:String;
      
      private var mToolTip:BehaviourTooltip;
      
      public function MatchResultBuddyName()
      {
         super();
         this.myTitle.text = DictMatchResults.DMZ_BUDDY_TITLE;
         this.myAddButton.setImage("plus_icon");
         this.myAddButton.setMarketReadyMode(true);
         this.myAddButton.customIconButtonSize = new Point(ADD_BUTTON_WIDTH,ADD_BUTTON_HEIGHT);
         this.myAddButton.registerClickEvent(this.onAddFriendButtonClicked);
         this.addTooltip();
         this.myAddButton.x = ADD_BUTTON_X;
         this.myAddButton.y = ADD_BUTTON_Y;
      }
      
      public function setBuddy(userID:String, userName:String) : void
      {
         this.mUserID = userID;
         this.mUserName = userName;
         this.myName.text = this.mUserName;
         var isFriend:Boolean = getDP(DataID.IS_FRIEND,[{"id":userID}]);
         this.myAddButton.visible = !isFriend;
      }
      
      private function onAddFriendButtonClicked() : void
      {
         broadcast(BCEvent.EVT_ADD_FRIEND,{
            "isName":false,
            "value":this.mUserID
         });
      }
      
      private function addTooltip() : void
      {
         var clickable:BehaviourClickable = new BehaviourClickable(this.myAddButton);
         this.mToolTip = new BehaviourTooltip(clickable,DictRightClick.ADD_TO_FRIEND,this.myAddButton.myHitArea);
      }
   }
}

