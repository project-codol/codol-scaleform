package fsg.shared
{
   import codo.interfaces.IDisposable;
   import flash.display.MovieClip;
   
   public class TabBase extends MovieClip implements IDisposable
   {
      
      public var myHitArea:MovieClip;
      
      protected var m_clickable:BehaviourClickable;
      
      protected var m_selectable:BehaviourSelectable;
      
      protected var m_audio:BehaviourAudio;
      
      protected var m_toolTip:BehaviourTooltip;
      
      private var m_populated:Boolean = false;
      
      public function TabBase()
      {
         super();
         this.m_clickable = new BehaviourClickable(this.myHitArea);
         this.m_selectable = new BehaviourSelectable(this.m_clickable);
         this.m_audio = new BehaviourAudio(this.m_clickable);
      }
      
      public function dispose() : void
      {
         this.m_clickable.dispose();
         this.m_selectable.dispose();
         this.m_audio.dispose();
         if(this.m_toolTip != null)
         {
            this.m_toolTip.dispose();
         }
      }
      
      public function get audio() : BehaviourAudio
      {
         return this.m_audio;
      }
      
      public function set tabTitle(str:String) : void
      {
      }
      
      public function get tabTitle() : String
      {
         return "";
      }
      
      public function set tabWidth(nWidth:Number) : void
      {
         this.myHitArea.width = nWidth;
      }
      
      public function get tabWidth() : Number
      {
         return this.myHitArea.width;
      }
      
      public function set autoSize(value:Boolean) : void
      {
      }
      
      public function ForceSelect() : void
      {
         this.m_selectable.state = BehaviourSelectable.STATE_SELECTED;
      }
      
      public function ForceUnselect() : void
      {
         this.m_selectable.state = BehaviourSelectable.STATE_UNSELECTED;
      }
      
      public function addMouseOverCallback(fnOverCallback:Function, userData:Object = null) : void
      {
         this.m_clickable.addMouseOverCallback(fnOverCallback,userData);
      }
      
      public function removeMouseOverCallback(fnOverCallback:Function, userData:Object = null) : void
      {
         this.m_clickable.removeMouseOverCallback(fnOverCallback,userData);
      }
      
      public function addMouseOutCallback(fnOutCallback:Function, userData:Object = null) : void
      {
         this.m_clickable.addMouseOutCallback(fnOutCallback,userData);
      }
      
      public function removeMouseOutCallback(fnOutCallback:Function, userData:Object = null) : void
      {
         this.m_clickable.removeMouseOutCallback(fnOutCallback,userData);
      }
      
      public function addSelectedCallback(fnSelectedCallback:Function, userData:Object = null) : void
      {
         this.m_selectable.addSelectedCallback(fnSelectedCallback,userData);
      }
      
      public function removeSelectedCallback(fnSelectedCallback:Function, userData:Object = null) : void
      {
         this.m_selectable.removeSelectedCallback(fnSelectedCallback,userData);
      }
      
      public function addUnselectedCallback(fnUnselectedCallback:Function, userData:Object = null) : void
      {
         this.m_selectable.addUnselectedCallback(fnUnselectedCallback,userData);
      }
      
      public function removeUnselectedCallback(fnUnselectedCallback:Function, userData:Object = null) : void
      {
         this.m_selectable.removeUnselectedCallback(fnUnselectedCallback,userData);
      }
      
      internal function set populated(value:Boolean) : void
      {
         this.m_populated = value;
      }
      
      internal function get populated() : Boolean
      {
         return this.m_populated;
      }
      
      public function addToolTip(toolTipText:String, AdditionalData:Object = null) : void
      {
         this.clearToolTip();
         this.m_toolTip = new BehaviourTooltip(this.m_clickable,toolTipText,this.myHitArea,{
            "x":300,
            "y":0
         },AdditionalData);
      }
      
      public function clearToolTip() : void
      {
         if(this.m_toolTip != null)
         {
            this.m_toolTip.dispose();
            this.m_toolTip = null;
         }
      }
      
      public function setEnabled(enabled:Boolean) : void
      {
         this.myHitArea.mouseEnabled = enabled;
         this.myHitArea.enabled = enabled;
      }
   }
}

