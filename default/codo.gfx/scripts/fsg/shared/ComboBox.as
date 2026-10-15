package fsg.shared
{
   import codo.constants.SE_ID;
   import codo.event.ParaEvent;
   import codo.utils.Logger;
   import codo.utils.ScaleformUtil;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import fsg.util.FsgAudioUtil;
   
   public class ComboBox extends MovieClip
   {
      
      public static const EVT_CHANGE:String = "evt_change";
      
      public var myHitArea:MovieClip;
      
      public var mySelectedItem:MovieClip;
      
      public var myComboBoxLabel:MovieClip;
      
      public var myDropDownMenu:ComboBoxDropDownMenu;
      
      protected var m_itemHeight:int = 21;
      
      private var m_selectedDataIndex:int = -1;
      
      protected var m_dataProvider:Object;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_selectable:BehaviourSelectable;
      
      private var m_selectedItemAnim:BehaviourAnimatedClickable;
      
      private var m_backgroundAnim:BehaviourAnimatedSelectable;
      
      private var m_label:String = "";
      
      private var m_disabledItemMsg:String = "";
      
      private var m_audio:BehaviourAudio;
      
      protected var m_dataIndexToItemIndex:Vector.<int> = new Vector.<int>();
      
      private var m_hackShowTimer:Timer;
      
      public function ComboBox()
      {
         super();
         this.myDropDownMenu.customItemHeight = this.m_itemHeight;
         this.m_clickable = new BehaviourClickable(this.myHitArea);
         this.m_selectable = new BehaviourSelectable(this.m_clickable,false);
         this.m_selectedItemAnim = new BehaviourAnimatedClickable(this.mySelectedItem,this.m_clickable,3,4,4);
         this.m_backgroundAnim = new BehaviourAnimatedSelectable(this,this.m_selectable,this.m_clickable,1,2,1);
         this.m_selectable.addSelectedCallback(this.onSelected);
         this.m_selectable.addUnselectedCallback(this.onUnselected);
         this.m_audio = new BehaviourAudio(this.m_clickable,SE_ID.GENERAL_ROLLOVER,SE_ID.MUTE,SE_ID.MUTE);
         this.m_hackShowTimer = new Timer(300);
         this.m_hackShowTimer.addEventListener(TimerEvent.TIMER,this.onHackShowHandle);
         this.onUnselected();
      }
      
      public function get label() : String
      {
         return this.m_label;
      }
      
      public function set label(cText:String) : void
      {
         this.myComboBoxLabel.myTextTF.text = cText;
         this.m_label = cText;
      }
      
      public function get disabledItemMsg() : String
      {
         return this.m_disabledItemMsg;
      }
      
      public function set disabledItemMsg(msg:String) : void
      {
         this.m_disabledItemMsg = msg;
      }
      
      public function set dropHeight(m_nHeight:Number) : void
      {
         this.myDropDownMenu.customItemHeight = m_nHeight;
      }
      
      public function set dataProvider(value:Object) : void
      {
         var item:ComboBoxItem = null;
         var ob:Object = null;
         var showThisValue:Boolean = false;
         this.m_dataProvider = value;
         this.m_dataIndexToItemIndex.splice(0,this.m_dataIndexToItemIndex.length);
         var array:Array = this.m_dataProvider as Array;
         var itemClass:Class = getDefinitionByName(getQualifiedClassName(this.mySelectedItem)) as Class;
         var len:int = int(array.length);
         var isEnabled:Boolean = true;
         this.myDropDownMenu.clearList();
         for(var dataIndex:int = 0; dataIndex < len; dataIndex++)
         {
            ob = this.m_dataProvider[dataIndex];
            this.m_dataIndexToItemIndex[dataIndex] = -1;
            showThisValue = true;
            if(ob.isHiddenValue != null)
            {
               showThisValue = !ob.isHiddenValue;
            }
            if(showThisValue)
            {
               isEnabled = ob.enabled != undefined ? Boolean(ob.enabled) : true;
               item = new itemClass() as ComboBoxItem;
               item.label = ob.label || ob.name || ob.id;
               item.enabled = isEnabled;
               this.addItemToDropDown(item,dataIndex);
            }
         }
      }
      
      public function get dataProvider() : Object
      {
         return this.m_dataProvider;
      }
      
      public function get selectedValue() : Object
      {
         if(this.m_selectedDataIndex >= 0 && this.m_selectedDataIndex < this.m_dataProvider.length)
         {
            return Boolean(this.m_dataProvider[this.m_selectedDataIndex]) ? this.m_dataProvider[this.m_selectedDataIndex] : {
               "label":"null",
               "id":0
            };
         }
         return null;
      }
      
      public function get selectedIndex() : int
      {
         return this.m_selectedDataIndex;
      }
      
      public function set selectedIndex(cIndex:int) : void
      {
         if(isNaN(cIndex) || cIndex < 0 || cIndex >= this.m_dataProvider.length)
         {
            if(ScaleformUtil.isScaleform)
            {
               Logger.print("WARNING: ComboBox::selectedIndex setting an out of range index " + cIndex + ", value ignored.");
            }
            return;
         }
         this.m_selectedDataIndex = cIndex;
         this.onSelectedIndexChanged();
      }
      
      public function set maxVisibleItemCount(count:int) : void
      {
         this.myDropDownMenu.maxVisibleItemCount = count;
      }
      
      public function get maxVisibleItemCount() : int
      {
         return this.myDropDownMenu.maxVisibleItemCount;
      }
      
      private function onHackShowHandle() : void
      {
         this.m_hackShowTimer.stop();
         this.myDropDownMenu.visible = false;
      }
      
      public function hackShowInTheBeginning() : void
      {
         this.myDropDownMenu.visible = true;
         this.m_hackShowTimer.start();
      }
      
      private function onSelectedIndexChanged() : void
      {
         this.setSelectedItemFromIndex(this.m_selectedDataIndex);
         dispatchEvent(new ParaEvent(EVT_CHANGE));
      }
      
      private function onSelected() : void
      {
         if(!this.mySelectedItem.enabled)
         {
            return;
         }
         this.swapDepth();
         if(stage != null)
         {
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageClicked,false,0,true);
         }
         this.myComboBoxLabel.myTextTF.text = this.m_label;
         this.mySelectedItem.visible = false;
         this.myHitArea.visible = false;
         this.myDropDownMenu.visible = true;
         FsgAudioUtil.getInstance().playSound(SE_ID.UI_MENU_ROLLOUT);
      }
      
      private function onUnselected() : void
      {
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageClicked);
         }
         this.myComboBoxLabel.myTextTF.text = this.m_label;
         this.mySelectedItem.visible = true;
         this.myHitArea.visible = true;
         this.myDropDownMenu.visible = false;
      }
      
      private function swapDepth() : void
      {
         parent.setChildIndex(this,parent.numChildren - 1);
      }
      
      public function currentItem() : ComboBoxItem
      {
         var itemIndex:int = this.m_dataIndexToItemIndex[this.m_selectedDataIndex];
         if(itemIndex >= 0)
         {
            return this.myDropDownMenu.getItem(itemIndex) as ComboBoxItem;
         }
         return null;
      }
      
      protected function addItemToDropDown(item:ComboBoxItem, dataIndex:int) : void
      {
         if(this.myDropDownMenu.length == 0)
         {
            this.setSelectedItemFromMClip(item);
            this.m_selectedDataIndex = 0;
         }
         item.registerMouseDownEvent(this.onDropDownItemClicked,dataIndex);
         this.myDropDownMenu.push(item);
         this.m_dataIndexToItemIndex[dataIndex] = this.myDropDownMenu.length - 1;
      }
      
      private function onDropDownItemClicked(dataIndex:int = -1) : void
      {
         this.selectedIndex = dataIndex;
         FsgAudioUtil.getInstance().playSound(SE_ID.UI_MENU_ROLLOUT_PROCEED);
      }
      
      public function get itemCount() : int
      {
         return this.myDropDownMenu.length;
      }
      
      private function setSelectedItemFromIndex(dataIndex:int) : void
      {
         var itemIndex:int = 0;
         var item:ComboBoxItem = null;
         try
         {
            itemIndex = this.m_dataIndexToItemIndex[dataIndex];
            if(itemIndex >= 0)
            {
               item = this.myDropDownMenu.getItem(itemIndex) as ComboBoxItem;
               if(item.enabled)
               {
                  this.setSelectedItemFromMClip(item);
               }
            }
            else
            {
               this.mySelectedItem.label = this.m_dataProvider[dataIndex].label;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function isSelectable(dataIndex:int) : Boolean
      {
         var itemIndex:int = this.m_dataIndexToItemIndex[dataIndex];
         if(itemIndex < 0)
         {
            return false;
         }
         var item:ComboBoxItem = this.myDropDownMenu.getItem(itemIndex) as ComboBoxItem;
         if(item == null)
         {
            return true;
         }
         return item.enabled;
      }
      
      public function setSelectedItemFromMClip(item:ComboBoxItem) : void
      {
         this.mySelectedItem.label = item.label;
      }
      
      private function detectMouseOver(d:DisplayObject) : Boolean
      {
         var mousePoint:Point = d.localToGlobal(new Point(d.mouseX,d.mouseY));
         return d.hitTestPoint(mousePoint.x,mousePoint.y,true);
      }
      
      private function onStageClicked(event:MouseEvent) : void
      {
         if(!this.detectMouseOver(this.myDropDownMenu.myScrollBar))
         {
            if(this.detectMouseOver(this))
            {
               if(!this.isSelectable(this.m_selectedDataIndex))
               {
                  return;
               }
            }
            this.m_selectable.state = BehaviourSelectable.STATE_UNSELECTED;
         }
      }
   }
}

