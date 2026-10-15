package components.fsgmatchresult_part.panels
{
   import codo.objects.ResultObj;
   import codo.utils.ScaleformUtil;
   import com.greensock.TimelineMax;
   import com.greensock.TweenLite;
   import components.fsgmatchresult_part.FsgMatchResultPopupPanelBase;
   import components.fsgmatchresult_part.FsgWeaponProgressRow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import fsg.shared.BehaviourScrollPane;
   import fsg.shared.ScrollBar;
   import fsg.util.FsgAudioUtil;
   
   public class FsgMatchResultWeaponPopupPanel extends FsgMatchResultPopupPanelBase
   {
      
      private static const ROW_HEIGHT:int = 155;
      
      private static const ROW_PADDING:int = 10;
      
      private static const ROW_FADE_DURATION:Number = 0.3;
      
      private static const MOUSE_WHEEL_TIMEOUT:Number = 300;
      
      public var myRowMount:MovieClip;
      
      public var myMask:MovieClip;
      
      public var myMouseWheelScrollArea:MovieClip;
      
      public var myScrollbar:ScrollBar;
      
      private var mScrolling:Boolean = false;
      
      private var mAnimationHasPlayed:Boolean = false;
      
      private var mRows:Vector.<FsgWeaponProgressRow>;
      
      protected var m_scrollPaneBehaviour:BehaviourScrollPane;
      
      public function FsgMatchResultWeaponPopupPanel()
      {
         super();
         this.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         this.m_scrollPaneBehaviour = new BehaviourScrollPane(this.myScrollbar,this.myMask,this.myRowMount,this.myMouseWheelScrollArea,true,0);
         if(false == ScaleformUtil.isScaleform)
         {
            this.injectFakeData();
         }
      }
      
      override public function setData(data:*) : void
      {
         var result:ResultObj = null;
         result = new ResultObj();
         result.data = data;
         this.bindWeaponProgress(result);
      }
      
      override public function deactive() : void
      {
         super.deactive();
         this.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      override public function active() : void
      {
         super.active();
         if(false == this.mAnimationHasPlayed)
         {
            this.startAnimation();
            FsgAudioUtil.getInstance().playSound("ui_weaponupgrades_appear");
         }
      }
      
      private function bindWeaponProgress(cResult:ResultObj) : void
      {
         var row:FsgWeaponProgressRow = null;
         var currentY:int = 0;
         this.mRows = new Vector.<FsgWeaponProgressRow>();
         for(var clipIDX:int = 0; clipIDX < this.myRowMount.numChildren; clipIDX++)
         {
            this.myRowMount.removeChildAt(clipIDX);
         }
         var weapons:Array = cResult.data;
         var rowClass:Class = getDefinitionByName("fsg.matchresults.fsgWeaponProgressRow") as Class;
         currentY = 0;
         for(var i:int = 0; i < weapons.length; i++)
         {
            row = new rowClass() as FsgWeaponProgressRow;
            this.mRows.push(row);
            this.myRowMount.addChild(row);
            row.setData(weapons[i]);
            row.alpha = 0;
            row.x = 0;
            row.y = currentY;
            currentY += ROW_HEIGHT + ROW_PADDING;
         }
         this.m_scrollPaneBehaviour.refreshScrollBar();
         this.m_scrollPaneBehaviour.setScrollRatio(0);
      }
      
      public function startAnimation() : void
      {
         var timelineAnim:TimelineMax = null;
         var row:FsgWeaponProgressRow = null;
         timelineAnim = new TimelineMax();
         for(var i:int = 0; i < this.mRows.length; i++)
         {
            row = this.mRows[i];
            row.alpha = 0;
            row.x = -30;
            timelineAnim.append(new TweenLite(row,ROW_FADE_DURATION,{
               "delay":i * 0.1,
               "alpha":1,
               "x":0,
               "onComplete":row.startAnimation
            }));
         }
         this.mAnimationHasPlayed = true;
      }
      
      private function onMouseWheel(event:MouseEvent) : void
      {
         if(Math.abs(event.delta) > 0 && !this.mScrolling)
         {
            this.mScrolling = true;
            swapChildren(this.myMouseWheelScrollArea,this.myRowMount);
            setTimeout(this.swapScrollAreaBack,MOUSE_WHEEL_TIMEOUT);
         }
      }
      
      private function swapScrollAreaBack() : void
      {
         swapChildren(this.myMouseWheelScrollArea,this.myRowMount);
         this.mScrolling = false;
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
         result.data[1] = {
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
         result.data[2] = {
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
         result.data[3] = {
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
         result.data[4] = {
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
         result.data[5] = {
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
      
      private function injectFakeData() : void
      {
         this.visible = true;
         var result:ResultObj = this.generateWeaponFakeData();
         this.bindWeaponProgress(result);
         this.startAnimation();
      }
   }
}

