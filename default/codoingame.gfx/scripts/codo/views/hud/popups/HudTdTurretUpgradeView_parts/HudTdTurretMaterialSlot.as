package codo.views.hud.popups.HudTdTurretUpgradeView_parts
{
   import codo.constants.BCInGameEvent;
   import codo.manager.EventManager;
   import codo.views.hud.popups.hudTdLoadoutView_parts.HudTdLoadoutViewTiedSlotBase;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import fsg.util.FsgImageHolder;
   
   public class HudTdTurretMaterialSlot extends MovieClip
   {
      
      public var myHitArea:MovieClip;
      
      public var myAmount:TextField;
      
      public var myImage:FsgImageHolder;
      
      public var myOutline:MovieClip;
      
      public var myColorBg:MovieClip;
      
      private var mData:Object;
      
      public function HudTdTurretMaterialSlot()
      {
         super();
         if(this.myHitArea != null)
         {
            this.myHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandle);
            this.myHitArea.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandle);
            this.myHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutHandle);
         }
      }
      
      public function set data(obj:Object) : void
      {
         var colorTransform:ColorTransform = null;
         this.mData = obj;
         this.myAmount.text = obj.stackNum;
         if(this.myImage != null)
         {
            this.myImage.setImage(obj.icon);
         }
         if(this.myOutline != null)
         {
            colorTransform = new ColorTransform();
            colorTransform.color = HudTdLoadoutViewTiedSlotBase.TIER_COLOR[obj.tier];
            this.myOutline.transform.colorTransform = colorTransform;
         }
         if(this.myColorBg != null)
         {
            this.myColorBg.gotoAndStop(obj.tier + 1);
         }
      }
      
      public function get data() : Object
      {
         return this.mData;
      }
      
      private function onMouseOverHandle(cEvt:MouseEvent) : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_TD_SHOW_UPGARDE_MATERIAL_DETAIL,this.mData);
      }
      
      private function onMouseMoveHandle(cEvt:MouseEvent) : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_TD_SHOW_UPGARDE_MATERIAL_DETAIL,null);
      }
      
      private function onMouseOutHandle(cEvt:MouseEvent) : void
      {
         EventManager.getInstance().broadcast(BCInGameEvent.EVT_TD_HIDE_UPGARDE_MATERIAL_DETAIL);
      }
   }
}

