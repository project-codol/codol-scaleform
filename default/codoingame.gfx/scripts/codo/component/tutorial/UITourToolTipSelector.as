package codo.component.tutorial
{
   import codo.component.ScrollList;
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.factory.GlobalFactory;
   import codo.component.filter.FilterOption;
   import codo.constants.SE_ID;
   import codo.event.ParaEvent;
   import codo.objects.ScrollListSettings;
   import codo.objects.uitour.UITourToolTipObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import com.greensock.TimelineLite;
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import fsg.util.FsgAudioUtil;
   
   public class UITourToolTipSelector extends MovieClip
   {
      
      public static const EVT_CHANGE:String = "evt_change";
      
      public static const LIST_WIDTH:Number = 214;
      
      public static const LIST_HEIGHT:Number = 143;
      
      public static const BUTTON_WIDTH:Number = 204;
      
      public var myScrollList:ScrollList;
      
      public var myInnerCorners:Sprite;
      
      public var myOuterCorners:Sprite;
      
      public var myMask:MovieClip;
      
      public var myHeader:TextField;
      
      private var mShowing:Boolean;
      
      private var mTimelineAnim:TimelineLite;
      
      private var mListData:Vector.<UITourToolTipObj>;
      
      public function UITourToolTipSelector()
      {
         super();
         this.myHeader.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myHeader.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHeader.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myHeader.alignment = TextStyle.HALIGN_CENTER;
         this.myHeader.width = 226;
         this.myHeader.text = LocalizeUtil.localize("@UI_TUTORIAL_TOURS_HEADER");
         var listSettings:ScrollListSettings = new ScrollListSettings();
         listSettings.orientation = ScrollListSettings.SCROLL_VERTICAL;
         listSettings.useNavArrows = false;
         listSettings.itemLinkage = GlobalFactory.FILTER_OPTION_LINKAGE;
         listSettings.itemPadding = 0;
         listSettings.autoSize = false;
         this.myScrollList.settings = listSettings;
         this.myScrollList.width = LIST_WIDTH;
         this.myScrollList.height = LIST_HEIGHT;
         this.myScrollList.selectionChangeCallback = this.onOptionSelected;
         visible = false;
         this.prepForAnim();
      }
      
      public function setTours(tourList:Vector.<UITourToolTipObj>) : void
      {
         if(this.mListData == tourList)
         {
            return;
         }
         this.mListData = tourList;
         this.myScrollList.resetList();
         var len:int = int(tourList.length);
         for(var i:int = 0; i < len; i++)
         {
            this.addOption(tourList[i]);
         }
         this.myScrollList.refreshVisuals();
      }
      
      public function get showing() : Boolean
      {
         return this.mShowing;
      }
      
      public function show() : void
      {
         if(this.mShowing)
         {
            return;
         }
         this.mShowing = true;
         visible = true;
         this.killTween();
         this.mTimelineAnim = new TimelineLite();
         this.mTimelineAnim.append(new TweenLite(this.myMask,0.2,{"width":242}));
         this.mTimelineAnim.append(new TweenLite(this.myMask,0.2,{"height":224}));
         this.mTimelineAnim.append(new TweenLite(this.myInnerCorners,0.2,{"alpha":1}));
         this.mTimelineAnim.append(new TweenLite(this.myOuterCorners,0.2,{"alpha":1}));
         this.mTimelineAnim.play();
         stage.addEventListener(MouseEvent.CLICK,this.onStageClickHandle);
      }
      
      public function hide() : void
      {
         if(!this.mShowing)
         {
            return;
         }
         this.mShowing = false;
         this.killTween();
         this.mTimelineAnim = new TimelineLite();
         this.mTimelineAnim.append(new TweenLite(this.myOuterCorners,0.2,{"alpha":0}));
         this.mTimelineAnim.append(new TweenLite(this.myInnerCorners,0.2,{"alpha":0}));
         this.mTimelineAnim.append(new TweenLite(this.myMask,0.2,{"height":49}));
         this.mTimelineAnim.append(new TweenLite(this.myMask,0.2,{
            "width":0,
            "onComplete":this.onHideComplete
         }));
         this.mTimelineAnim.play();
         if(this.stage != null)
         {
            stage.removeEventListener(MouseEvent.CLICK,this.onStageClickHandle);
         }
      }
      
      public function onHideComplete() : void
      {
         visible = false;
      }
      
      private function killTween() : void
      {
         TweenLite.killTweensOf(this.myMask);
         TweenLite.killTweensOf(this.myInnerCorners);
         TweenLite.killTweensOf(this.myOuterCorners);
      }
      
      private function prepForAnim() : void
      {
         this.myMask.width = 0;
         this.myMask.height = 49;
         this.myInnerCorners.alpha = 0;
         this.myOuterCorners.alpha = 0;
      }
      
      private function addOption(data:UITourToolTipObj) : UIInteractiveComponent
      {
         var item:FilterOption = this.myScrollList.addItem(data,GlobalFactory.FILTER_OPTION_LINKAGE) as FilterOption;
         item.highlightBackground = true;
         item.width = BUTTON_WIDTH;
         item.label = data.title;
         item.index = this.myScrollList.numberOfItems - 1;
         item.allowReselect = false;
         return item;
      }
      
      private function onStageClickHandle(cEvt:MouseEvent) : void
      {
         if(this.hitTestPoint(stage.mouseX,stage.mouseY) == false)
         {
            this.hide();
         }
      }
      
      private function onOptionSelected() : void
      {
         var option:FilterOption = null;
         FsgAudioUtil.getInstance().playSound(SE_ID.UI_MENU_ROLLOUT_PROCEED);
         var len:int = this.myScrollList.numberOfItems;
         for(var i:int = 0; i < len; i++)
         {
            option = this.myScrollList.getItem(i) as FilterOption;
            option.checked = false;
         }
         this.hide();
         dispatchEvent(new ParaEvent(EVT_CHANGE,this));
      }
   }
}

