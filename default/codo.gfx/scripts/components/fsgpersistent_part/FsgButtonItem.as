package components.fsgpersistent_part
{
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   import codo.manager.EventManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgBaseControl;
   
   public class FsgButtonItem extends FsgBaseControl
   {
      
      public var myMenuText:MovieClip;
      
      public var myTextTF:TextField;
      
      public var myHitArea:MovieClip;
      
      private var myTargetPageId:String;
      
      private var myIsHighlighted:Boolean;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_audio:BehaviourAudio;
      
      public function FsgButtonItem()
      {
         super();
         this.myTargetPageId = null;
         this.myIsHighlighted = false;
         this.m_clickable = new BehaviourClickable(this.myHitArea);
         this.m_clickable.addMouseOverCallback(this.onMouseOver);
         this.m_clickable.addMouseOutCallback(this.onMouseOut);
         EventManager.getInstance().listen(BCEvent.EVT_MAIN_PAGE_ID_CHANGED,this.onPageIDChangedHandle);
         this.m_audio = new BehaviourAudio(this.m_clickable);
      }
      
      public function get audio() : BehaviourAudio
      {
         return this.m_audio;
      }
      
      public function setTargetPageId(pageId:String) : void
      {
         this.myTargetPageId = pageId;
      }
      
      protected function onMouseOver() : void
      {
         if(!this.myIsHighlighted)
         {
            gotoAndStop(2);
            dispatchEvent(new Event(EVT_MOUSE_OVER));
         }
      }
      
      protected function onMouseOut() : void
      {
         if(!this.myIsHighlighted)
         {
            gotoAndStop(1);
         }
      }
      
      public function setItemObject(objItem:Object) : void
      {
         this.myMenuText.myTextTF.text = objItem.name;
      }
      
      private function onPageIDChangedHandle(cEvt:ParaEvent) : void
      {
         this.checkHighlight(cEvt.myPara.id);
      }
      
      private function checkHighlight(pageId:String) : void
      {
         if(this.myTargetPageId != null)
         {
            if(this.myTargetPageId == pageId)
            {
               this.myIsHighlighted = true;
               gotoAndStop(2);
            }
            else
            {
               this.myIsHighlighted = false;
               gotoAndStop(1);
            }
         }
      }
   }
}

