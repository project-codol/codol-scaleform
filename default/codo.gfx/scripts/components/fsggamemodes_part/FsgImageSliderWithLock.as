package components.fsggamemodes_part
{
   import codo.event.ParaEvent;
   import codo.localization.DictRoom;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import fsg.util.FsgBaseButton;
   import fsg.util.FsgImageHolder;
   import shaui.component.core.InteractiveComponent;
   
   public class FsgImageSliderWithLock extends InteractiveComponent
   {
      
      public static const EVT_INDEX_CHANGED:String = "evt_index_changed";
      
      public var myImg:FsgImageHolder;
      
      public var myMissionLocked:MovieClip;
      
      private var m_data:Array;
      
      private var m_dataField:String = "imageURL";
      
      private var m_currentIndex:int = -1;
      
      private var m_btnRight:FsgBaseButton;
      
      private var m_btnLeft:FsgBaseButton;
      
      private var m_widthOverride:Number = -1;
      
      private var m_heightOverride:Number = -1;
      
      public function FsgImageSliderWithLock()
      {
         super();
      }
      
      public function set dataField(cField:String) : void
      {
         this.m_dataField = cField;
      }
      
      public function set overrideWidth(w:Number) : void
      {
         this.m_widthOverride = w;
      }
      
      public function get overrideWidth() : Number
      {
         return this.m_widthOverride;
      }
      
      public function set overrideHeight(h:Number) : void
      {
         this.m_heightOverride = h;
      }
      
      public function get overrideHeight() : Number
      {
         return this.m_heightOverride;
      }
      
      public function set data(cDat:Array) : void
      {
         this.m_data = cDat;
      }
      
      public function get data() : Array
      {
         return this.m_data;
      }
      
      public function get selectedData() : Object
      {
         return this.m_data[this.currentIndex];
      }
      
      public function reset() : void
      {
         this.m_currentIndex = -1;
         this.m_data = null;
      }
      
      public function set currentIndex(cIndex:uint) : void
      {
         var selectedData:Object = null;
         var url:String = null;
         var selectedDataUnlockedHints:Object = null;
         var lockedHint:String = null;
         var entry:String = null;
         if(this.m_data != null && cIndex >= 0 && cIndex < this.m_data.length)
         {
            this.m_currentIndex = cIndex;
            selectedData = this.m_data[this.m_currentIndex];
            url = this.m_dataField == "" ? selectedData as String : (selectedData == null ? "" : selectedData[this.m_dataField]);
            if(url != null && url.length > 0)
            {
               this.myImg.visible = true;
               this.myImg.setImage(url);
            }
            else
            {
               this.myImg.visible = false;
               this.myImg.clearImage();
            }
            if(Boolean(selectedData.unlocked))
            {
               if(Boolean(selectedData.lockedByDLCLevel))
               {
                  this.myMissionLocked.visible = true;
                  this.myMissionLocked.myLockedText.text_txtTF.text = LocalizeUtil.localize(DictRoom.TUTORIAL_NODLC);
                  this.myMissionLocked.myLockedText.visible = true;
               }
               else
               {
                  this.myMissionLocked.visible = false;
               }
            }
            else
            {
               this.myMissionLocked.visible = true;
               selectedDataUnlockedHints = selectedData.unlockedHints;
               if(selectedDataUnlockedHints != null)
               {
                  lockedHint = "";
                  for each(entry in selectedDataUnlockedHints)
                  {
                     lockedHint += LocalizeUtil.localize(entry) + "\n";
                  }
                  this.myMissionLocked.myLockedText.text_txtTF.text = lockedHint;
               }
               this.myMissionLocked.myLockedText.visible = selectedDataUnlockedHints != null;
            }
            dispatchEvent(new ParaEvent(EVT_INDEX_CHANGED,{
               "index":this.m_currentIndex,
               "data":selectedData
            }));
         }
      }
      
      public function get currentIndex() : uint
      {
         return this.m_currentIndex;
      }
      
      override protected function onInitListener() : void
      {
         this.myImg.addEventListener(Event.COMPLETE,this.onImgLoaded,false,0,true);
      }
      
      private function onImgLoaded(e:Event) : void
      {
         if(this.m_widthOverride > 0)
         {
            this.myImg.width = this.m_widthOverride;
         }
         if(this.m_heightOverride > 0)
         {
            this.myImg.height = this.m_heightOverride;
         }
      }
      
      private function onArrowBtnLeftClick(cButton:MovieClip) : void
      {
         if(this.m_data != null && this.m_data.length > 0)
         {
            if(this.m_currentIndex == 0)
            {
               this.currentIndex = this.m_data.length - 1;
            }
            else
            {
               --this.currentIndex;
            }
         }
      }
      
      private function onArrowBtnRightClick(cButton:MovieClip) : void
      {
         if(this.m_data != null && this.m_data.length > 0)
         {
            if(this.m_currentIndex == this.m_data.length - 1)
            {
               this.currentIndex = 0;
            }
            else
            {
               ++this.currentIndex;
            }
         }
      }
   }
}

