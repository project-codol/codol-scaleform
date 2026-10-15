package fsg.shared
{
   import codo.constants.BCEvent;
   import codo.constants.TipType;
   import codo.interfaces.IDisposable;
   import codo.manager.EventManager;
   import codo.utils.StageUtil;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class BehaviourTooltip implements IDisposable
   {
      
      public static var TYPE_DEFAULT:uint = 0;
      
      public static var TYPE_WEAPON:uint = 1;
      
      public static var TYPE_RENEW:uint = 2;
      
      private var m_subject:Sprite;
      
      private var m_AdditionalData:Object;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_messageStr:String;
      
      private var m_size:Point = new Point(0,0);
      
      private var m_offset:Point = new Point(0,0);
      
      private var m_toolTipType:uint = TYPE_DEFAULT;
      
      private var m_hasActiveTip:Boolean = false;
      
      private var m_enabled:Boolean = true;
      
      public function BehaviourTooltip(clickable:BehaviourClickable, message:String, subject:Sprite, size:Object = null, AdditionalData:Object = null)
      {
         super();
         this.m_subject = subject;
         this.m_subject.mouseChildren = false;
         this.m_clickable = clickable;
         this.m_messageStr = message;
         if(size != null && (size.x != null || size.y != null))
         {
            this.m_size = new Point(size.x,size.y);
         }
         if(AdditionalData != null && AdditionalData.data != null && AdditionalData.data.type != null && AdditionalData.data.type == "wea")
         {
            this.m_toolTipType = TYPE_WEAPON;
            this.m_AdditionalData = AdditionalData;
         }
         else if(AdditionalData != null && AdditionalData.toolTipType != null)
         {
            this.m_toolTipType = AdditionalData.toolTipType;
            this.m_AdditionalData = null;
         }
         else
         {
            this.m_toolTipType = TYPE_DEFAULT;
            this.m_AdditionalData = null;
         }
         this.registerEvents();
      }
      
      public function dispose() : void
      {
         this.m_clickable.removeMouseOverCallback(this.onMouseOver);
         this.m_clickable.removeMouseOutCallback(this.onMouseOut);
         this.m_clickable = null;
         this.m_subject = null;
         this.m_AdditionalData = null;
      }
      
      public function set enabled(isEnabled:Boolean) : void
      {
         this.m_enabled = isEnabled;
      }
      
      public function get enabled() : Boolean
      {
         return this.m_enabled;
      }
      
      public function setData(message:String, size:Object = null, AdditionalData:Object = null) : void
      {
         this.m_messageStr = message;
         if(size != null && (size.x != null || size.y != null))
         {
            this.m_size = new Point(size.x,size.y);
         }
         if(AdditionalData != null && AdditionalData.data != null && AdditionalData.data.type != null && AdditionalData.data.type == "wea")
         {
            this.m_toolTipType = TYPE_WEAPON;
            this.m_AdditionalData = AdditionalData;
         }
         else if(AdditionalData != null && AdditionalData.toolTipType != null)
         {
            this.m_toolTipType = AdditionalData.toolTipType;
            this.m_AdditionalData = AdditionalData;
         }
         else
         {
            this.m_toolTipType = TYPE_DEFAULT;
            this.m_AdditionalData = null;
         }
         if(this.m_hasActiveTip)
         {
            this.onMouseOver();
         }
      }
      
      public function registerEvents() : void
      {
         this.m_clickable.addMouseOverCallback(this.onMouseOver);
         this.m_clickable.addMouseOutCallback(this.onMouseOut);
      }
      
      public function set tipText(strText:String) : void
      {
         this.m_messageStr = strText;
      }
      
      public function get tipText() : String
      {
         return this.m_messageStr;
      }
      
      public function set tipOffset(offset:Point) : void
      {
         this.m_offset = offset;
      }
      
      public function refreshTip() : void
      {
         if(this.m_hasActiveTip)
         {
            this.onMouseOver();
         }
      }
      
      public function removeTip() : void
      {
         if(this.m_hasActiveTip)
         {
            this.onMouseOut();
         }
      }
      
      private function onMouseOver() : void
      {
         if(this.m_enabled == false)
         {
            return;
         }
         var tooltipPos:Point = StageUtil.localPosToStagePos(this.m_subject);
         tooltipPos.x += this.m_subject.width / 2 + this.m_offset.x;
         var altTooltipPos:Point = tooltipPos.clone();
         tooltipPos.y += this.m_subject.height + this.m_offset.y;
         if(this.m_toolTipType == TYPE_DEFAULT)
         {
            this.m_hasActiveTip = true;
            EventManager.getInstance().broadcast(BCEvent.TIP_SHOW,{
               "type":TipType.TEXT,
               "text":this.m_messageStr,
               "pos":tooltipPos,
               "altPos":altTooltipPos,
               "size":this.m_size
            });
         }
         else if(this.m_toolTipType == TYPE_WEAPON)
         {
            tooltipPos.x -= this.m_subject.width / 2;
            this.m_hasActiveTip = true;
            EventManager.getInstance().broadcast(BCEvent.TIP_SHOW,{
               "type":TipType.ITEM_TIP,
               "data":this.m_AdditionalData,
               "pos":tooltipPos,
               "parentHeight":this.m_subject.height,
               "size":this.m_size
            });
         }
         else if(this.m_toolTipType == TYPE_RENEW)
         {
            this.m_hasActiveTip = true;
            EventManager.getInstance().broadcast(BCEvent.TIP_SHOW,{
               "type":TipType.RENEW_TIP,
               "pos":tooltipPos,
               "size":this.m_size
            });
         }
      }
      
      private function onMouseOut() : void
      {
         if(this.m_enabled == false)
         {
            return;
         }
         this.m_hasActiveTip = false;
         EventManager.getInstance().broadcast(BCEvent.TIP_HIDE,null);
      }
   }
}

