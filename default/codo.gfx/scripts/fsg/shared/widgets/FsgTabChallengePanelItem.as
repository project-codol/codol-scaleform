package fsg.shared.widgets
{
   import codo.interfaces.IDisposable;
   import codo.objects.ChallengeBaseObj;
   import codo.objects.ToolTipObject;
   import codo.objects.VetChallengeObj;
   import codo.utils.CursorUtil;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class FsgTabChallengePanelItem extends Sprite implements IDisposable
   {
      
      protected static const NUM_CHALLENGES:uint = 3;
      
      public var myProgressBar:FsgProgressBar;
      
      public var myProgressTF:TextField;
      
      public var myItemHeader:FsgTabChallengePanelItemHeader;
      
      public var myAnimOutline:Sprite;
      
      public var myChallengeComplete:FsgTabChallengeComplete;
      
      public var myHitArea:Sprite;
      
      private var m_clickCallback:Function;
      
      private var m_itemData:ChallengeBaseObj;
      
      private var m_isVeteranAward:Boolean = false;
      
      private var m_toolTipObject:ToolTipObject = null;
      
      private var m_index:int = 0;
      
      private var m_Clickable:BehaviourClickable;
      
      private var m_Audio:BehaviourAudio;
      
      public function FsgTabChallengePanelItem()
      {
         super();
         this.mouseChildren = this.myChallengeComplete.visible = false;
         this.myProgressBar.myBarOutline.visible = this.outlineIsVisible;
         this.myProgressTF.autoSize = TextFieldAutoSize.RIGHT;
         if(this.myAnimOutline != null)
         {
            this.myAnimOutline.visible = false;
         }
         this.m_Clickable = new BehaviourClickable(this);
         this.m_Clickable.addClickCallback(this.onItemClicked);
         this.m_Clickable.addMouseOverCallback(this.onItemRollOver);
         this.m_Clickable.addMouseOutCallback(this.onItemRollOut);
         this.m_Audio = new BehaviourAudio(this.m_Clickable);
      }
      
      public function get itemIndex() : int
      {
         return this.m_index;
      }
      
      public function set itemIndex(indexVal:int) : void
      {
         this.m_index = this.itemIndex;
      }
      
      public function setData(challengeData:ChallengeBaseObj, index:int = 0) : void
      {
         var endValue:uint = challengeData.target;
         this.itemIndex = index;
         this.m_itemData = challengeData;
         this.myItemHeader.titleText = challengeData.name;
         this.myProgressBar.setProgressBarFillScaleX(challengeData.progress / endValue);
         this.myProgressTF.text = challengeData.progress.toString().concat("/",endValue);
         var isXP:Boolean = true;
         var rewardValue:int = int(challengeData.rewardXP);
         this.myItemHeader.setDescriptionText(challengeData.description,endValue);
         if(challengeData.rewardXP == 0)
         {
            isXP = false;
            rewardValue = int(challengeData.rewardGP);
         }
         this.myItemHeader.setReward(rewardValue,isXP);
         var isVeteran:Boolean = challengeData is VetChallengeObj;
         this.setStyle(isVeteran);
         this.m_isVeteranAward = isVeteran;
         this.myChallengeComplete.visible = challengeData.getFinished();
      }
      
      public function setProgressBarOffsets(barFillHeight:int = -1, barFillX:uint = 0, barFillY:uint = 0) : void
      {
         this.myProgressBar.formatProgressBarFill(barFillHeight,barFillX,barFillY);
      }
      
      public function setWidth(widthVal:uint) : void
      {
         var OUTER_PADDING:uint = 0;
         OUTER_PADDING = 4;
         this.myAnimOutline.width = widthVal + OUTER_PADDING;
         this.myProgressTF.x = widthVal - this.myProgressTF.width;
         this.myProgressBar.width = widthVal - this.myProgressTF.width;
         this.myItemHeader.setWidth(widthVal);
         this.myChallengeComplete.setWidth(widthVal + OUTER_PADDING);
      }
      
      public function setBarWidthByProgressText(maxWidth:int) : void
      {
         this.myProgressBar.width = maxWidth - 10;
         this.myProgressTF.x = maxWidth;
      }
      
      protected function get outlineIsVisible() : Boolean
      {
         return false;
      }
      
      private function onItemRollOver() : void
      {
         this.myItemHeader.selectedState = this.myAnimOutline.visible = true;
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function onItemRollOut() : void
      {
         this.myItemHeader.selectedState = this.myAnimOutline.visible = false;
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
      }
      
      private function onItemClicked() : void
      {
         if(this.m_clickCallback != null)
         {
            this.m_clickCallback(this.m_itemData);
         }
      }
      
      public function get clickCallback() : Function
      {
         return this.m_clickCallback;
      }
      
      public function set clickCallback(callBack:Function) : void
      {
         this.m_clickCallback = callBack;
      }
      
      public function setStyle(isVeteranChallenge:Boolean = false) : void
      {
         this.myProgressBar.setProgressBarFillStyle(isVeteranChallenge ? FsgProgressBar.FRAME_STYLE_GREEN : FsgProgressBar.FRAME_STYLE_VIOLET);
      }
      
      public function returnToolTipConfig() : ToolTipObject
      {
         var TOOL_TIP_FONT:String = null;
         var toolTipFormat:TextFormat = null;
         if(this.m_toolTipObject == null)
         {
            TOOL_TIP_FONT = "$font_2";
            toolTipFormat = new TextFormat();
            toolTipFormat.font = TOOL_TIP_FONT;
            this.m_toolTipObject = new ToolTipObject(this.myHitArea);
            this.m_toolTipObject.textFormatting = toolTipFormat;
            this.m_toolTipObject.contents = this.m_itemData.description;
            this.m_toolTipObject.showArrow = true;
            this.m_toolTipObject.setWidth = this.width;
            this.m_toolTipObject.offsetPoint = new Point(0,this.height);
            this.m_toolTipObject.arrowPosition = ToolTipObject.ARROW_POSITION_TOP;
         }
         return this.m_toolTipObject;
      }
      
      protected function clearListeners() : void
      {
         this.m_Clickable.setEnabled(false);
      }
      
      public function dispose() : void
      {
         this.m_clickCallback = null;
         this.m_itemData = null;
         this.m_Clickable = null;
         this.m_Audio = null;
      }
   }
}

