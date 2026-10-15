package codo.views
{
   import codo.base.BaseView;
   import codo.component.CloseButton;
   import codo.constants.BCEvent;
   import codo.constants.GameInfo;
   import codo.objects.MapIllustrationObj;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class GameModeImagePopupView extends BaseView
   {
      
      private static const PADDING:Number = 20;
      
      public var myCloseButton:CloseButton;
      
      public var myWhiteBg:MovieClip;
      
      public var myDescription:TextField;
      
      private var m_data:MapIllustrationObj;
      
      private var m_loader:GameModeImageLoader;
      
      public function GameModeImagePopupView()
      {
         super();
         this.m_loader = new GameModeImageLoader();
         addChild(this.m_loader);
         swapChildren(this.m_loader,this.myCloseButton);
      }
      
      override public function set routeData(data:*) : void
      {
         this.m_data = data as MapIllustrationObj;
         this.m_loader.clearImage();
         this.m_loader.addEventListener(Event.COMPLETE,this.onImageLoaded);
         this.m_loader.setImage(this.m_data.imageURL);
         this.myDescription.text = "";
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myCloseButton.registerClickEvent(this.onCloseButtonClicked);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.myCloseButton.unRegisterClickEvent(this.onCloseButtonClicked);
      }
      
      private function onImageLoaded(e:Event) : void
      {
         this.m_loader.removeEventListener(Event.COMPLETE,this.onImageLoaded);
         this.m_loader.x = (GameInfo.DEFAULT_WIDTH - this.m_loader.width) / 2;
         this.m_loader.y = (GameInfo.DEFAULT_HEIGHT - this.m_loader.height) / 2;
         this.myWhiteBg.width = this.m_loader.width + PADDING;
         this.myWhiteBg.height = this.m_loader.height + PADDING;
         this.myWhiteBg.x = this.m_loader.x - PADDING / 2;
         this.myWhiteBg.y = this.m_loader.y - PADDING / 2;
         this.myCloseButton.x = this.m_loader.x + this.m_loader.width - this.myCloseButton.width / 2 + PADDING / 2;
         this.myCloseButton.y = this.m_loader.y - this.myCloseButton.width / 2 - PADDING / 2;
         this.myDescription.width = this.m_loader.width - PADDING;
         this.myDescription.text = this.m_data.desc;
         this.myDescription.x = this.m_loader.x + PADDING / 2;
         this.myDescription.y = this.m_loader.y + this.m_loader.height - this.myDescription.textHeight - PADDING;
      }
      
      private function onCloseButtonClicked() : void
      {
         broadcast(BCEvent.EVT_CLOSE_POPUP_PAGE,{"pageID":_pageID});
      }
   }
}

import codo.event.ImageLoaderEvent;
import flash.display.DisplayObject;
import fsg.util.FsgImageHolder;

class GameModeImageLoader extends FsgImageHolder
{
   
   public function GameModeImageLoader()
   {
      super();
   }
   
   override protected function onImageLoaded(e:ImageLoaderEvent) : void
   {
      var bmpImage:DisplayObject = e.m_displayObject;
      addChild(bmpImage);
      displatchLoadComplete(e.m_status);
   }
}
