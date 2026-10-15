package codo.controllers
{
   import codo.base.BaseController;
   import codo.constants.BCEvent;
   import codo.constants.TipType;
   import codo.interfaces.ITipAbleElement;
   import codo.interfaces.ITipController;
   import codo.utils.LocalizeUtil;
   import codo.utils.StageUtil;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import shaui.component.core.UIComponent;
   
   public class TipController extends BaseController implements ITipController
   {
      
      private var _tipDataDict:Dictionary = new Dictionary();
      
      public function TipController()
      {
         super();
         UIComponent.TIP_CONTROLLER = this;
      }
      
      public function registerTip(cTarget:ITipAbleElement, cTipType:uint, cTipTargetID:String = "", cTipLocString:String = "") : void
      {
         if(this._tipDataDict[cTarget] == null)
         {
            if(cTipLocString != "")
            {
               cTipLocString = LocalizeUtil.localize(cTipLocString);
            }
            this._tipDataDict[cTarget] = {
               "target":cTarget,
               "type":cTipType,
               "targetID":cTipTargetID,
               "locString":cTipLocString
            };
            cTarget.tipHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverHandle);
            cTarget.tipHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutHandle);
         }
      }
      
      public function unRegisterTip(cTarget:ITipAbleElement) : void
      {
         if(this._tipDataDict[cTarget] != null)
         {
            delete this._tipDataDict[cTarget];
         }
      }
      
      private function onMouseOverHandle(cEvt:MouseEvent) : void
      {
         var tempTipDat:Object = null;
         var tempTxt:String = null;
         var tempPos:Point = null;
         var altTempPos:Point = null;
         tempTipDat = this._tipDataDict[cEvt.currentTarget];
         if(tempTipDat != null && (cEvt.currentTarget as ITipAbleElement).tipAble)
         {
            switch(tempTipDat.type)
            {
               case TipType.TEXT:
                  tempTxt = tempTipDat.locString;
                  if(tempTxt == "")
                  {
                     tempTxt = tempTipDat.target.tipLocString;
                  }
                  tempPos = StageUtil.localPosToStagePos(tempTipDat.target);
                  altTempPos = tempPos.clone();
                  if(tempTipDat.target.tipOffset != null)
                  {
                     tempPos.x += tempTipDat.target.tipOffset.x;
                     tempPos.y += tempTipDat.target.tipOffset.y;
                  }
                  else
                  {
                     tempPos.x += tempTipDat.target.width / 2;
                     tempPos.y += tempTipDat.target.height;
                  }
                  altTempPos.x = tempPos.x;
                  broadcast(BCEvent.TIP_SHOW,{
                     "type":tempTipDat.type,
                     "text":LocalizeUtil.localize(tempTxt),
                     "pos":tempPos,
                     "altPos":altTempPos
                  });
                  break;
               case TipType.GENERAL_ITEM:
            }
         }
      }
      
      private function onMouseOutHandle(cEvt:MouseEvent) : void
      {
         broadcast(BCEvent.TIP_HIDE);
      }
   }
}

