package fsg.shared
{
   import codo.utils.ScaleformUtil;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class ToolTipItem extends MovieClip
   {
      
      private var m_clickable:BehaviourClickable;
      
      private var m_audio:BehaviourAudio;
      
      private var m_tooltip:BehaviourTooltip;
      
      public function ToolTipItem()
      {
         super();
         this.m_clickable = new BehaviourClickable(this);
         if(ScaleformUtil.isScaleform == true)
         {
            this.m_clickable.setEnableMouseHighlight(false);
         }
         this.m_tooltip = new BehaviourTooltip(this.m_clickable,"",this);
         this.m_audio = new BehaviourAudio(this.m_clickable);
      }
      
      public function setTip(text:String, size:Object = null, AdditionalData:Object = null) : void
      {
         if(this.m_tooltip != null)
         {
            this.m_tooltip.setData(text,size,AdditionalData);
         }
      }
      
      public function set tipOffset(offset:Point) : void
      {
         this.m_tooltip.tipOffset = offset;
      }
      
      public function get audio() : BehaviourAudio
      {
         return this.m_audio;
      }
   }
}

