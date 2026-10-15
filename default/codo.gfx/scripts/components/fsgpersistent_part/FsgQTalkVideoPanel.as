package components.fsgpersistent_part
{
   import codo.base.BaseView;
   import codo.constants.BCEvent;
   import codo.event.ParaEvent;
   
   public class FsgQTalkVideoPanel extends BaseView
   {
      
      private var mPlanedClose:Boolean = false;
      
      public function FsgQTalkVideoPanel()
      {
         super();
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.listen(BCEvent.QT_VIDEO_STATE_CHANGE,this.onQTVideoStateChanged,1);
      }
      
      private function onQTVideoStateChanged(e:ParaEvent) : void
      {
         var isOpen:Boolean = e.myPara;
         if(!isOpen)
         {
            this.mPlanedClose = true;
         }
      }
      
      override protected function hideView() : void
      {
         this.unlisten(BCEvent.QT_VIDEO_STATE_CHANGE,this.onQTVideoStateChanged);
         if(this.mPlanedClose)
         {
            this.mPlanedClose = false;
         }
         super.hideView();
      }
   }
}

