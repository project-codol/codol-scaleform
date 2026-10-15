package codo.component.matchselect
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.component.marketplaceitem.MarketplaceNewTag;
   import codo.interfaces.ISelectable;
   import codo.localization.Dict;
   import codo.objects.MatchSelectModeObj;
   import codo.objects.PlayListObj;
   import codo.style.GlobalGuide;
   import codo.utils.CursorUtil;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   
   public class MatchSelectTheatreOption extends UIInteractiveComponent implements ISelectable
   {
      
      public var myVideoLength:TextField;
      
      public var myGameType:TextField;
      
      public var myMapName:TextField;
      
      public var myDateStamp:TextField;
      
      public var myTimeStamp:TextField;
      
      public var myNewTag:MarketplaceNewTag;
      
      public var myFocusBackground:Sprite;
      
      public var myBackground:MovieClip;
      
      public var myLine:MovieClip;
      
      protected var mWidth:Number;
      
      protected var mHeight:Number;
      
      protected var mSelected:Boolean = false;
      
      protected var mTextFocusColor:uint = 16777215;
      
      protected var mTextUnfocusColor:uint = 3576790;
      
      protected var mTextClickColor:uint = 16777215;
      
      protected var mDivider:String = " - ";
      
      public var myName:String;
      
      public function MatchSelectTheatreOption()
      {
         super();
         isInteractiveEnabled = true;
         this.myGameType.fontSize = this.myMapName.fontSize = this.myDateStamp.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myVideoLength.fontSize = this.myTimeStamp.fontSize = GlobalGuide.FONT_SIZE_EXTRA_SMALL;
         this.myVideoLength.font = this.myGameType.font = this.myMapName.font = this.myDateStamp.font = this.myTimeStamp.font = GlobalGuide.FONT_FACE_BOLD;
         this.myVideoLength.multiline = this.myGameType.multiline = this.myMapName.multiline = this.myDateStamp.multiline = this.myTimeStamp.multiline = false;
         this.myVideoLength.wordWrap = this.myGameType.wordWrap = this.myMapName.wordWrap = this.myDateStamp.wordWrap = this.myTimeStamp.wordWrap = false;
         this.myVideoLength.autoSize = this.myGameType.autoSize = this.myMapName.autoSize = this.myDateStamp.autoSize = this.myTimeStamp.autoSize = TextFieldAutoSize.LEFT;
         this.myVideoLength.allCaps = this.myGameType.allCaps = this.myMapName.allCaps = this.myDateStamp.allCaps = this.myTimeStamp.allCaps = true;
         this.myVideoLength.fontColor = this.myGameType.fontColor = this.myMapName.fontColor = this.myDateStamp.fontColor = this.myTimeStamp.fontColor = this.mTextUnfocusColor;
         this.width = myHitArea.width;
         this.height = myHitArea.height;
         this.myBackground.visible = false;
         this.myFocusBackground.visible = false;
         this.myNewTag.visible = false;
         this.myNewTag.updateLabelSize(true);
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         if(Boolean(data))
         {
            this.myVideoLength.text = data.length;
            this.myGameType.text = data.gameTypeLoc + this.mDivider;
            this.myMapName.text = data.mapLoc;
            this.myDateStamp.text = data.date;
            this.myTimeStamp.text = data.time;
         }
         this.refreshTag();
         this.updateLabelPosition();
      }
      
      public function refreshTag() : void
      {
         var isNew:Boolean = false;
         var isFeatured:Boolean = false;
         var modeObj:MatchSelectModeObj = null;
         var playListObj:PlayListObj = getData() as PlayListObj;
         if(playListObj != null)
         {
            isNew = playListObj.isNew;
            isFeatured = playListObj.isFeatured;
         }
         else
         {
            modeObj = getData() as MatchSelectModeObj;
            if(modeObj != null)
            {
               isNew = modeObj.isNew;
               isFeatured = modeObj.isFeatured;
            }
         }
         this.myNewTag.visible = isNew || isFeatured;
         if(isFeatured)
         {
            this.myNewTag.myLabelTF.text = Dict.FEATURED;
         }
         else if(isNew)
         {
            this.myNewTag.myLabelTF.text = Dict.NEW;
         }
      }
      
      public function set selected(sel:Boolean) : void
      {
         this.mSelected = sel;
         if(this.mSelected)
         {
            this.myGameType.fontColor = this.myDateStamp.fontColor = this.mTextFocusColor;
            this.myVideoLength.fontColor = this.myMapName.fontColor = this.myTimeStamp.fontColor = this.mTextFocusColor;
            this.myBackground.visible = true;
            this.myFocusBackground.visible = false;
         }
         else
         {
            this.myGameType.fontColor = this.myDateStamp.fontColor = this.mTextUnfocusColor;
            this.myVideoLength.fontColor = this.myMapName.fontColor = this.myTimeStamp.fontColor = this.mTextUnfocusColor;
            this.myBackground.visible = false;
         }
      }
      
      public function get selected() : Boolean
      {
         return this.mSelected;
      }
      
      override public function set width(w:Number) : void
      {
         this.mWidth = w;
         this.draw();
      }
      
      override public function set height(h:Number) : void
      {
         this.mHeight = h;
         this.draw();
      }
      
      override public function get height() : Number
      {
         return this.mHeight;
      }
      
      public function draw() : void
      {
         myHitArea.width = this.mWidth;
         myHitArea.height = this.mHeight;
         this.myFocusBackground.width = this.myBackground.width = this.myLine.width = myHitArea.width;
         this.myFocusBackground.height = this.myBackground.height = myHitArea.height;
         this.myNewTag.x = this.mWidth - this.myNewTag.width;
         this.updateLabelPosition();
      }
      
      protected function updateLabelPosition() : void
      {
         this.myGameType.y = this.myMapName.y = this.myDateStamp.y;
         this.myMapName.x = this.myGameType.x + this.myGameType.textWidth - 1;
         this.myTimeStamp.x = myHitArea.width - (this.myTimeStamp.myTextClip.width + 18);
         this.myDateStamp.x = this.myTimeStamp.x - (this.myDateStamp.myTextClip.width + 1);
         this.myVideoLength.x = this.myMapName.x + this.myMapName.textWidth + 5;
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         CursorUtil.BeginCursor(CursorUtil.CURSOR_OVER_BUTTON);
         if(!this.mSelected)
         {
            this.myGameType.fontColor = this.myDateStamp.fontColor = this.mTextFocusColor;
            this.myVideoLength.fontColor = this.myMapName.fontColor = this.myTimeStamp.fontColor = this.mTextFocusColor;
            this.myFocusBackground.visible = true;
         }
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         CursorUtil.EndCursor(CursorUtil.CURSOR_OVER_BUTTON);
         if(!this.mSelected)
         {
            this.myGameType.fontColor = this.myDateStamp.fontColor = this.mTextUnfocusColor;
            this.myVideoLength.fontColor = this.myMapName.fontColor = this.myTimeStamp.fontColor = this.mTextUnfocusColor;
            this.myFocusBackground.visible = false;
         }
      }
      
      override protected function onMouseClick() : void
      {
         super.onMouseClick();
         if(!this.mSelected)
         {
            this.myGameType.fontColor = this.myDateStamp.fontColor = this.mTextClickColor;
            this.myVideoLength.fontColor = this.myMapName.fontColor = this.myTimeStamp.fontColor = this.mTextClickColor;
         }
      }
      
      override protected function onMouseClickUp() : void
      {
         super.onMouseClickUp();
         if(!this.mSelected)
         {
            this.myGameType.fontColor = this.myDateStamp.fontColor = this.mTextFocusColor;
            this.myVideoLength.fontColor = this.myMapName.fontColor = this.myTimeStamp.fontColor = this.mTextFocusColor;
            this.myFocusBackground.visible = true;
         }
      }
   }
}

