package components.asym
{
   import codo.event.ListEvent;
   import components.BaseButton;
   import components.CodoList;
   import components.interfaces.IAsymMonsterLoadoutListItem;
   import flash.events.Event;
   
   public class AsymRobotsList extends CodoList
   {
      
      public function AsymRobotsList()
      {
         super();
      }
      
      override protected function onLineEvtHandle(cEvt:Event) : void
      {
         var rendererIndex:int = 0;
         var type:String = null;
         var renderer:IAsymMonsterLoadoutListItem = cEvt.currentTarget as IAsymMonsterLoadoutListItem;
         if(renderer != null)
         {
            rendererIndex = int(renderer.index);
         }
         else
         {
            rendererIndex = -1;
         }
         switch(cEvt.type)
         {
            case BaseButton.EVT_CLICK:
               if(!renderer.isLocked)
               {
                  this.selectedIndex = rendererIndex;
               }
               type = EVT_LINE_CLICK;
               break;
            case BaseButton.EVT_MOUSE_OVER:
               this.focusIndex = rendererIndex;
               type = EVT_LINE_ROLLOVER;
               break;
            case BaseButton.EVT_MOUSE_OUT:
               this.focusIndex = -1;
               type = EVT_LINE_ROLLOUT;
               break;
            case BaseButton.EVT_DOUBLE_CLICK:
               if(!renderer.isLocked)
               {
                  this.selectedIndex = rendererIndex;
               }
               type = EVT_LINE_DOUBLE_CLICK;
         }
         if(type != "" && type != null && renderer != null)
         {
            this.dispatchEvent(new ListEvent(type,renderer,{"targetLine":renderer}));
         }
      }
   }
}

