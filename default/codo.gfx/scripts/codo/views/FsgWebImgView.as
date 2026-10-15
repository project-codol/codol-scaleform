package codo.views
{
   import awesomium.DropDownList;
   import awesomium.MessageBox;
   import awesomium.MessageBoxObj;
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.shared.PopupCloseButton;
   import codo.theme.BaseTheme;
   import components.fsgpersistent_part.FsgWebReloadButton;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import fsg.util.FsgImageHolder;
   import scaleform.gfx.FocusManager;
   import scaleform.gfx.IMEEx;
   import scaleform.gfx.TextFieldEx;
   
   public class FsgWebImgView extends BaseView
   {
      
      public var myWebImg:FsgImageHolder;
      
      public var myWebImgFrame:Sprite;
      
      public var myWebImgCloseButton:PopupCloseButton;
      
      public var myWebImgReloadBtn:FsgWebReloadButton;
      
      public var myLayerMask:Sprite;
      
      public var myWebIcon:MovieClip;
      
      public var myWebTitle:TextField;
      
      public var myIMEText:TextField = new TextField();
      
      public var myDropDownMenu:DropDownList;
      
      public var myMessageBox:MessageBox;
      
      public var myMessageBoxMask:MovieClip;
      
      private var mQuitGameWhenClose:Boolean;
      
      public function FsgWebImgView()
      {
         super();
         this.myWebImg.mouseChildren = this.myWebImgFrame.mouseChildren = false;
         this.myWebImg.mouseEnabled = this.myWebImgFrame.mouseEnabled = false;
         visible = false;
         listen(BCEvent.EVT_SHOW_WEBIMG_CONTAINER,this.onShowWebImgContainerHandle);
         listen(BCEvent.ON_ROOM_JOINED,this.onRoomJoinedHandle);
         listen(BCEvent.EVT_HIDE_WEBIMG_CONTAINER,this.onHideWebImgContainerHandle);
         listen(BCEvent.EVT_WEBPAGE_INPUT_FOCUSCHANGE,this.onWebPageInputFocusChanged);
         listen(BCEvent.EVT_WEBPAGE_INPUT_START,this.onWebPageInputStart);
         listen(BCEvent.EVT_WEBPAGE_INPUT_POSCHANGE,this.onWebPageInputUpdatePosition);
         listen(BCEvent.EVT_WEBPAGE_INPUT_END,this.onWebPageInputEnd);
         listen(BCEvent.EVT_WEBPAGE_INPUT_COMPOSITE,this.onWebPageInputComposite);
         listen(BCEvent.EVT_WEBPAGE_TITLE_CHANGE,this.onWebPageTitleChange);
         listen(BCEvent.EVT_WEBPAGE_LOADING,this.onWebPageLoading);
         listen(BCEvent.EVT_WEBPAGE_OPEN_DROP_DOWN_MENU,this.onWebPageOpenDropDownMenu);
         listen(BCEvent.EVT_WEBPAGE_CLOSE_DROP_DOWN_MENU,this.onWebPageCloseDropDownMenu);
         listen(BCEvent.EVT_WEBPAGE_OPEN_MESSAGE_BOX,this.onWebPageOpenMessageBox);
         listen(BCEvent.EVT_WEBPAGE_OPEN_INGAME_URL,this.onWebPageOpenInGameUrl);
         this.myWebImgCloseButton.registerClickEvent(this.onCloseWebImgClickHandle);
         this.myWebImg.keepWHRatio = false;
         this.myWebImgReloadBtn.myHitArea.addEventListener(MouseEvent.CLICK,this.onReloadWebImgClickHandle);
         this.myIMEText.x = 0;
         this.myIMEText.y = 0;
         this.myIMEText.width = 0;
         this.myIMEText.height = 20;
         this.myIMEText.alpha = 0;
         this.myIMEText.type = TextFieldType.INPUT;
         var tf:TextFormat = new TextFormat();
         tf.font = GameInfo.GAME_FONT_S;
         this.myIMEText.defaultTextFormat = tf;
         this.myIMEText.setTextFormat(tf);
         this.myIMEText.embedFonts = true;
         this.myIMEText.addEventListener(FocusEvent.FOCUS_IN,this.onIMETextFocusChanged);
         this.myIMEText.addEventListener(FocusEvent.FOCUS_OUT,this.onIMETextFocusChanged);
         TextFieldEx.setIMEEnabled(this.myIMEText,true);
         addChild(this.myIMEText);
         this.createContextMenu();
         this.createWebPopup();
      }
      
      override protected function setupThemeVector() : void
      {
         super.setupThemeVector();
         mThemeSetNew.push({
            "clip":this.myWebImgFrame,
            "piece":BaseTheme.THEME_CONTENT_SIMPLE_BACKGROUND
         });
         mThemeSetNew.push({
            "clip":this.myWebImgReloadBtn,
            "piece":BaseTheme.THEME_WEB_IMAGE_REFRESH_BUTTON
         });
      }
      
      private function createContextMenu() : void
      {
         var rawAsset:MovieClip = new mcAwmDropDownList();
         this.myDropDownMenu = new DropDownList(rawAsset);
         this.myDropDownMenu.addEventListener(DropDownList.ITEM_SELECT_EVENT,this.onDropDownItemSelected);
         addChild(this.myDropDownMenu);
         this.myDropDownMenu.visible = false;
      }
      
      private function createWebPopup() : void
      {
         this.myMessageBoxMask = new mcAwmMask();
         addChild(this.myMessageBoxMask);
         this.myMessageBoxMask.visible = false;
         var rawAsset:MovieClip = new mcAwmMessageBox();
         this.myMessageBox = new MessageBox(rawAsset);
         this.myMessageBox.addEventListener(MessageBox.BUTTON_CLICKED,this.onButtonClicked);
         addChild(this.myMessageBox);
         this.myMessageBox.visible = false;
      }
      
      private function onDropDownItemSelected(e:Event) : void
      {
         var selectedIndex:int = this.myDropDownMenu.getSelectedIndex();
         CFunctionCommonContainer.DropDownMenuItemSelected(selectedIndex);
      }
      
      private function onButtonClicked(e:ParaEvent) : void
      {
         this.myMessageBox.visible = this.myMessageBoxMask.visible = false;
         var buttonIndex:int = MessageBox.BUTTON_INDEX_CANCEL;
         if(null != e)
         {
            buttonIndex = e.myPara as int;
         }
         CFunctionCommonContainer.WebPageMsgBoxClosed(buttonIndex);
      }
      
      override protected function showView() : void
      {
      }
      
      private function onWebPageTitleChange(cEvent:ParaEvent) : void
      {
         this.myWebTitle.text = cEvent.myPara.title;
      }
      
      private function onWebPageLoading(cEvent:ParaEvent) : void
      {
         if(Boolean(cEvent.myPara.loading))
         {
            this.myWebImgReloadBtn.StartAnimation();
         }
         else
         {
            this.myWebImgReloadBtn.StopAnimation();
         }
      }
      
      private function onWebPageOpenDropDownMenu(cEvt:ParaEvent) : void
      {
         var data:Array = null;
         var selectedIndex:int = 0;
         var h:int = 0;
         var fontSize:Number = NaN;
         var x:int = int(cEvt.myPara.posX);
         var y:int = int(cEvt.myPara.posY);
         data = cEvt.myPara.data;
         selectedIndex = int(cEvt.myPara.selected);
         var w:int = int(cEvt.myPara.width);
         h = int(cEvt.myPara.height);
         fontSize = Number(cEvt.myPara.fontSize);
         this.myDropDownMenu.x = x;
         this.myDropDownMenu.y = y;
         this.myDropDownMenu.setData(data,w,h,fontSize,selectedIndex);
         this.myDropDownMenu.visible = true;
      }
      
      private function onWebPageOpenMessageBox(cEvt:ParaEvent) : void
      {
         this.myMessageBox.x = this.myWebImg.x + (this.myWebImg.width - this.myMessageBox.width) / 2;
         this.myMessageBox.y = this.myWebImg.y + (this.myWebImg.height - this.myMessageBox.height) / 2;
         var msgBoxObj:MessageBoxObj = cEvt.myPara;
         this.myMessageBox.setData(msgBoxObj);
         var newWHRatio:Number = GameInfo.gameWidth / GameInfo.gameHeight;
         var oldWHRatio:Number = GameInfo.DEFAULT_WIDTH / GameInfo.DEFAULT_HEIGHT;
         if(newWHRatio > oldWHRatio)
         {
            this.myMessageBoxMask.width = GameInfo.gameWidth / (GameInfo.gameHeight / GameInfo.DEFAULT_HEIGHT);
            this.myMessageBoxMask.x = (GameInfo.DEFAULT_WIDTH - stage.stageWidth) / 2;
         }
         else
         {
            this.myMessageBoxMask.height = GameInfo.gameHeight / (GameInfo.gameWidth / GameInfo.DEFAULT_WIDTH);
            this.myMessageBoxMask.y = (GameInfo.DEFAULT_HEIGHT - stage.stageHeight) / 2;
         }
         this.myMessageBox.visible = this.myMessageBoxMask.visible = true;
      }
      
      private function onWebPageOpenInGameUrl(cEvt:ParaEvent) : void
      {
         broadcast(BCEvent.EVT_TRY_CLOSE_WEBIMG);
      }
      
      private function closeAllWebComponent() : void
      {
         this.onWebPageCloseDropDownMenu(null);
         this.onButtonClicked(null);
      }
      
      private function onWebPageCloseDropDownMenu(cEvt:ParaEvent) : void
      {
         this.myDropDownMenu.visible = false;
         this.myDropDownMenu.dispose();
      }
      
      private function onShowWebImgContainerHandle(cEvt:ParaEvent) : void
      {
         var tf:TextFormat = null;
         visible = true;
         var tempDat:Object = cEvt.myPara.data;
         var useSkinlessDisplay:Boolean = tempDat.useSkinlessDisplay != null && Boolean(tempDat.useSkinlessDisplay);
         var hideTitle:Boolean = Boolean(cEvt.myPara.hideTitle);
         this.mQuitGameWhenClose = Boolean(cEvt.myPara.hasOwnProperty("quitGameWhenClose")) && Boolean(cEvt.myPara.quitGameWhenClose);
         this.myWebImgFrame.visible = this.myLayerMask.visible = this.myWebImgCloseButton.enabled = this.myWebImgCloseButton.visible = !useSkinlessDisplay;
         this.myWebImg.x = tempDat.x;
         this.myWebImg.y = tempDat.y;
         this.myWebImg.width = tempDat.width;
         this.myWebImg.height = tempDat.height;
         this.myWebImgFrame.x = tempDat.x - 20;
         this.myWebImgFrame.y = tempDat.y - 60;
         this.myWebImgFrame.width = tempDat.width + 43;
         this.myWebImgFrame.height = tempDat.height + 80;
         var buttonTop:Number = this.myWebImgFrame.y;
         this.myWebImgCloseButton.x = this.myWebImgFrame.x + this.myWebImgFrame.width - this.myWebImgCloseButton.width;
         this.myWebImgCloseButton.y = buttonTop;
         this.myWebImgReloadBtn.x = this.myWebImg.x;
         this.myWebImgReloadBtn.y = buttonTop + 26;
         var newWHRatio:Number = GameInfo.gameWidth / GameInfo.gameHeight;
         var oldWHRatio:Number = GameInfo.DEFAULT_WIDTH / GameInfo.DEFAULT_HEIGHT;
         if(newWHRatio > oldWHRatio)
         {
            this.myLayerMask.width = GameInfo.gameWidth / (GameInfo.gameHeight / GameInfo.DEFAULT_HEIGHT);
            this.myLayerMask.x = (GameInfo.DEFAULT_WIDTH - stage.stageWidth) / 2;
         }
         else
         {
            this.myLayerMask.height = GameInfo.gameHeight / (GameInfo.gameWidth / GameInfo.DEFAULT_WIDTH);
            this.myLayerMask.y = (GameInfo.DEFAULT_HEIGHT - stage.stageHeight) / 2;
         }
         this.myWebImg.clearImage();
         this.myWebImg.keepWHRatio = false;
         this.myWebImg.setImage(GameInfo.WEB_IMG_ID);
         this.myWebTitle.y = this.myWebImgFrame.y - this.myWebTitle.height;
         this.myWebIcon.visible = false;
         this.myWebTitle.x = this.myWebImgFrame.x + 10;
         if(useSkinlessDisplay)
         {
            tf = new TextFormat();
            tf.size = 20;
            this.myWebTitle.x = this.myWebImg.x + 30;
            this.myWebTitle.y = this.myWebImg.y - 38;
            this.myWebTitle.width = 992;
            this.myWebTitle.defaultTextFormat = tf;
            this.myWebTitle.setTextFormat(tf);
            this.myWebTitle.filters = [];
         }
         this.myWebTitle.visible = !hideTitle;
      }
      
      private function onRoomJoinedHandle(cEvt:ParaEvent) : void
      {
         if(this.mQuitGameWhenClose)
         {
            CFunctionCommonContainer.execnow("quit");
            return;
         }
         broadcast(BCEvent.EVT_TRY_CLOSE_WEBIMG);
      }
      
      private function onHideWebImgContainerHandle(cEvt:ParaEvent) : void
      {
         this.closeAllWebComponent();
         visible = false;
      }
      
      private function onCloseWebImgClickHandle() : void
      {
         if(this.mQuitGameWhenClose)
         {
            CFunctionCommonContainer.execnow("quit");
            return;
         }
         broadcast(BCEvent.EVT_TRY_CLOSE_WEBIMG);
      }
      
      private function onReloadWebImgClickHandle(cEvt:MouseEvent) : void
      {
         CFunctionCommonContainer.ReloadWebPage();
         this.closeAllWebComponent();
      }
      
      private function onWebPageInputFocusChanged(cEvt:ParaEvent) : void
      {
         var obj:Object = null;
         if(Boolean(cEvt.myPara.focused))
         {
            FocusManager.setFocus(this.myIMEText);
         }
         else
         {
            obj = FocusManager.getFocus() as Object;
            if(obj == this.myIMEText)
            {
               FocusManager.setFocus(null);
            }
         }
      }
      
      private function onWebPageInputUpdatePosition(cEvt:ParaEvent) : void
      {
         this.myIMEText.x = cEvt.myPara.x;
         this.myIMEText.y = cEvt.myPara.y;
      }
      
      private function onWebPageInputStart(cEvt:ParaEvent) : void
      {
         this.myIMEText.text = "";
         this.myIMEText.width = 100;
      }
      
      private function onWebPageInputComposite(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.SetWebPageCompositionString(IMEEx.GetCompositionString());
         this.myIMEText.text = "";
      }
      
      private function onWebPageInputEnd(cEvt:ParaEvent) : void
      {
         CFunctionCommonContainer.SetWebPageInputString(this.myIMEText.text);
         this.myIMEText.text = "";
         this.myIMEText.width = 0;
      }
      
      private function onIMETextFocusChanged(evt:FocusEvent) : void
      {
         if(evt.type != FocusEvent.FOCUS_IN)
         {
            if(evt.type == FocusEvent.FOCUS_OUT)
            {
               if(Boolean(CFunctionCommonContainer.IsInInputField()))
               {
                  broadcast(BCEvent.EVT_WEBPAGE_INPUT_FOCUSCHANGE,{"focused":true});
               }
            }
         }
      }
   }
}

