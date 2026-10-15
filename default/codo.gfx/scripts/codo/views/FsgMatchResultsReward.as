package codo.views
{
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.objects.ResultObj;
   import codo.objects.VideoCuePointObject;
   import codo.utils.ScaleformUtil;
   import com.greensock.TimelineMax;
   import com.greensock.TweenLite;
   import com.greensock.easing.Bounce;
   import components.fsgmatchresult_part.FsgMatchResultsRewardItem;
   import components.fsgmatchresult_part.FsgMatchResultsUnlockList;
   import flash.geom.Point;
   import fsg.shared.BarDialogButton;
   import fsg.shared.VideoDisplayBaseView;
   
   public class FsgMatchResultsReward extends VideoDisplayBaseView
   {
      
      private static const UNLOCK_LIST_ANIM_TIME:Number = 2.25;
      
      private static const SLIDE_TIME:Number = 0.65;
      
      private static const FLY_IN_DURATION:Number = 0.75;
      
      private static const FLY_IN_START_SCALE:Number = 0.6;
      
      private static const FLY_IN_END_SCALE:Number = 1;
      
      private static const BOX_FADE_DURATION:Number = 0.1;
      
      private static const REWARD_ITEM_SLIDE_DURATION:Number = 0.5;
      
      private static const REWARD_ITEM_SLIDE_START_Y:Number = 440;
      
      private static const REWARD_ITEM_SLIDE_END_Y:Number = 300;
      
      public var myRewardItem:FsgMatchResultsRewardItem;
      
      public var myUnlocksList:FsgMatchResultsUnlockList;
      
      public var myContinueButton:BarDialogButton;
      
      public function FsgMatchResultsReward()
      {
         super();
         if(false == ScaleformUtil.isScaleform)
         {
            trace(this.myUnlocksList);
            this.myUnlocksList.setData(this.generateWeaponFakeData().data[0]);
         }
         this.myRewardItem.alpha = 0;
         this.myRewardItem.scaleX = FLY_IN_START_SCALE;
         this.myRewardItem.scaleY = FLY_IN_START_SCALE;
         this.myUnlocksList.alpha = 0;
         this.myContinueButton.setText("<CONTINUE>");
         this.myContinueButton.alpha = 0;
         this.myContinueButton.x = GameInfo.gameWidth * 0.5 - this.myContinueButton.width * 0.5;
      }
      
      private function closePopupView(data:Object) : void
      {
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":_pageID});
      }
      
      override protected function get videoCuePointCallbacks() : Vector.<VideoCuePointObject>
      {
         return new <VideoCuePointObject>[new VideoCuePointObject(2533,this.TriggerCard)];
      }
      
      private function startAnimation() : void
      {
         var timelineAnim:TimelineMax = null;
         timelineAnim = new TimelineMax();
         timelineAnim.append(new TweenLite(this.myRewardItem,BOX_FADE_DURATION,{"alpha":1}));
         timelineAnim.append(new TweenLite(this.myRewardItem,FLY_IN_DURATION,{
            "scaleX":FLY_IN_END_SCALE,
            "scaleY":FLY_IN_END_SCALE,
            "ease":Bounce.easeOut
         }));
         this.myRewardItem.y = REWARD_ITEM_SLIDE_START_Y;
         timelineAnim.append(new TweenLite(this.myRewardItem,REWARD_ITEM_SLIDE_DURATION,{"y":REWARD_ITEM_SLIDE_END_Y}),SLIDE_TIME);
         timelineAnim.append(new TweenLite(this.myUnlocksList,BOX_FADE_DURATION,{"alpha":1}));
         timelineAnim.append(new TweenLite(this.myContinueButton,BOX_FADE_DURATION,{
            "alpha":1,
            "onComplete":this.onAnimComplete
         }));
         timelineAnim.addCallback(this.myUnlocksList.startAnimation,UNLOCK_LIST_ANIM_TIME);
      }
      
      private function TriggerCard() : void
      {
         this.startAnimation();
      }
      
      private function onAnimComplete() : void
      {
         this.myContinueButton.registerClickEvent(this.closePopupView);
      }
      
      override protected function enableData() : void
      {
         super.enableData();
      }
      
      override protected function disableData() : void
      {
      }
      
      override protected function get videoFrameCount() : uint
      {
         return 150;
      }
      
      override protected function onVideoComplete() : void
      {
      }
      
      override protected function get videoPath() : String
      {
         return "Reward_box_fxComp_v15";
      }
      
      override protected function get videoPosition() : Point
      {
         return new Point(-213.5,0);
      }
      
      override protected function get videoSize() : Point
      {
         return new Point(1706,960);
      }
      
      private function generateWeaponFakeData() : ResultObj
      {
         var result:ResultObj = new ResultObj();
         result.data = new Array();
         result.data[0] = {
            "name":"AK-47",
            "imageURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png",
            "progressInfo":{
               "levelValue":[0,100,200,300,400,500,600],
               "currentLevel":4,
               "targetLevel":5,
               "srcExpValue":400,
               "desExpValue":550
            },
            "unlockAttachment":[{
               "name":"Att0",
               "imageURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png"
            },{
               "name":"Att1",
               "imageURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png"
            },{
               "name":"Att2",
               "imageURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png"
            },{
               "name":"Att3",
               "imageURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png"
            },{
               "name":"Att4",
               "imageURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png"
            },{
               "name":"Att5",
               "imageURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png"
            },{
               "name":"Att6",
               "imageURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png"
            },{
               "name":"Att7",
               "imageURL":"http://www.activision.com/content/dam/atvi/activision/atviLogo.png"
            }]
         };
         return result;
      }
   }
}

