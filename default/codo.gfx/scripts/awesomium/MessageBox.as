package awesomium
{
   import codo.event.ParaEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class MessageBox extends BaseMc
   {
      
      public static const BUTTON_INDEX_OK:int = 0;
      
      public static const BUTTON_INDEX_CANCEL:int = 1;
      
      public static const BUTTON_CLICKED:String = "button_clicked";
      
      private var myOKButton:MessageBoxButton;
      
      private var myCancelButton:MessageBoxButton;
      
      private var myTextBox:TextField;
      
      private var myBg:MovieClip;
      
      private var mData:MessageBoxObj;
      
      public function MessageBox(asset:MovieClip)
      {
         super(asset);
      }
      
      override protected function assembleAsset() : void
      {
         this.myOKButton = new MessageBoxButton(m_rawAsset["myOKButton"]);
         this.myCancelButton = new MessageBoxButton(m_rawAsset["myCancelButton"]);
         this.myTextBox = m_rawAsset["myTextBox"];
         this.myBg = m_rawAsset["myBg"];
         addChild(m_rawAsset);
         addChild(this.myOKButton);
         addChild(this.myCancelButton);
      }
      
      override protected function registerListener() : void
      {
         this.myOKButton.addEventListener(MessageBoxButton.CLICK_EVENT,this.onOKButtonClicked);
         this.myCancelButton.addEventListener(MessageBoxButton.CLICK_EVENT,this.onCancelButtonClicked);
      }
      
      private function onOKButtonClicked(e:Event) : void
      {
         dispatchEvent(new ParaEvent(BUTTON_CLICKED,BUTTON_INDEX_OK));
      }
      
      private function onCancelButtonClicked(e:Event) : void
      {
         dispatchEvent(new ParaEvent(BUTTON_CLICKED,BUTTON_INDEX_CANCEL));
      }
      
      override protected function unregisterListener() : void
      {
         this.myOKButton.removeEventListener(MessageBoxButton.CLICK_EVENT,this.onOKButtonClicked);
      }
      
      public function setData(data:MessageBoxObj) : void
      {
         this.mData = data;
         if(data.type == MessageBoxObj.TYPE_ALERT)
         {
            this.myOKButton.visible = true;
            this.myCancelButton.visible = false;
            this.myOKButton.setLabel(data.buttonLabels[0]);
         }
         else if(data.type == MessageBoxObj.TYPE_CONFIRM)
         {
            this.myOKButton.visible = true;
            this.myCancelButton.visible = true;
            this.myOKButton.setLabel(data.buttonLabels[0]);
            this.myCancelButton.setLabel(data.buttonLabels[1]);
         }
         this.myTextBox.text = data.label;
      }
      
      public function getMessageBoxType() : int
      {
         return this.mData.type;
      }
   }
}

