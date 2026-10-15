package codo.component.social
{
   import codo.component.Button;
   import codo.component.core.UIInteractiveComponent;
   
   public class BaseNotification extends UIInteractiveComponent
   {
      
      public var myRejectBtn:Button;
      
      public var myAcceptBtn:Button;
      
      public var myBlockBtn:Button;
      
      private var mAcceptHandler:Function;
      
      private var mRejectHandler:Function;
      
      private var myBlockHandler:Function;
      
      public function BaseNotification()
      {
         super();
         this.myAcceptBtn.registerClickEvent(this.onAcceptButtonClicked);
         this.myRejectBtn.registerClickEvent(this.onRejectButtonClicked);
         this.myBlockBtn.registerClickEvent(this.onBlockButtonClicked);
      }
      
      public function registerAcceptHandler(handler:Function) : void
      {
         this.mAcceptHandler = handler;
      }
      
      public function registerRejectHandler(handler:Function) : void
      {
         this.mRejectHandler = handler;
      }
      
      public function registerBlockHandler(handler:Function) : void
      {
         this.myBlockHandler = handler;
      }
      
      public function onAcceptButtonClicked() : void
      {
         if(this.mAcceptHandler != null)
         {
            this.mAcceptHandler(mData);
         }
      }
      
      public function onRejectButtonClicked() : void
      {
         if(this.mRejectHandler != null)
         {
            this.mRejectHandler(mData);
         }
      }
      
      public function onBlockButtonClicked() : void
      {
         if(this.myBlockHandler != null)
         {
            this.myBlockHandler(mData);
         }
      }
   }
}

