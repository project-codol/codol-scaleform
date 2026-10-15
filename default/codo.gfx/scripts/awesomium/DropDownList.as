package awesomium
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class DropDownList extends BaseMc
   {
      
      public static const ITEM_SELECT_EVENT:String = "item_select_event";
      
      private var myBg:MovieClip;
      
      private var m_ItemClass:Class;
      
      private var m_rendererList:Vector.<DropDownMenuItem> = new Vector.<DropDownMenuItem>();
      
      private var m_selectedIndex:int = -1;
      
      private var m_highlightIndex:int = -1;
      
      public function DropDownList(asset:MovieClip)
      {
         super(asset);
      }
      
      override protected function assembleAsset() : void
      {
         this.myBg = m_rawAsset["myBg"];
         var item:MovieClip = m_rawAsset["myItem"];
         var className:String = getQualifiedClassName(item);
         this.m_ItemClass = getDefinitionByName(className) as Class;
         addChild(this.myBg);
      }
      
      public function setData(itemList:Array, w:int, h:int, fontSize:Number, selected:int = -1) : void
      {
         var i:int = 0;
         var renderer:DropDownMenuItem = null;
         this.disposeLastTime();
         var count:int = int(itemList.length);
         var bgWidth:Number = w;
         var bgHeight:Number = 0;
         for(i = 0; i < count; i++)
         {
            renderer = new DropDownMenuItem(new this.m_ItemClass());
            renderer.setLabel(itemList[i]);
            renderer.setTextSize(fontSize);
            renderer.setItemSize(w,h);
            renderer.x = 0;
            renderer.y = i * h;
            bgHeight = renderer.y + h;
            addChild(renderer);
            this.registerItemListener(renderer);
            this.m_rendererList.push(renderer);
         }
         this.myBg.width = bgWidth;
         this.myBg.height = bgHeight;
         for(i = 0; i < count; i++)
         {
            this.m_rendererList[i].setWidth(bgWidth);
         }
         this.m_selectedIndex = this.m_highlightIndex = selected;
         if(selected >= 0 && selected < this.m_rendererList.length)
         {
            this.m_rendererList[selected].setState(DropDownMenuItem.STATE_OVER);
         }
      }
      
      private function disposeLastTime() : void
      {
         var itemCount:int = int(this.m_rendererList.length);
         for(var i:int = 0; i < itemCount; i++)
         {
            this.unregisterItemListener(this.m_rendererList[i]);
            this.m_rendererList[i].dispose();
            removeChild(this.m_rendererList[i]);
         }
         this.m_rendererList.splice(0,itemCount);
      }
      
      private function registerItemListener(item:DropDownMenuItem) : void
      {
         item.addEventListener(MouseEvent.ROLL_OVER,this.onItemRollOver);
         item.addEventListener(MouseEvent.CLICK,this.onItemClicked);
      }
      
      private function unregisterItemListener(item:DropDownMenuItem) : void
      {
         item.removeEventListener(MouseEvent.ROLL_OVER,this.onItemRollOver);
         item.removeEventListener(MouseEvent.CLICK,this.onItemClicked);
      }
      
      private function onItemRollOver(e:MouseEvent) : void
      {
         var item:DropDownMenuItem = e.currentTarget as DropDownMenuItem;
         var itemIndex:int = this.m_rendererList.indexOf(item);
         if(this.m_highlightIndex >= 0 && this.m_highlightIndex < this.m_rendererList.length)
         {
            this.m_rendererList[this.m_highlightIndex].setState(DropDownMenuItem.STATE_OUT);
         }
         this.m_highlightIndex = itemIndex;
         this.m_rendererList[this.m_highlightIndex].setState(DropDownMenuItem.STATE_OVER);
      }
      
      private function onItemClicked(e:MouseEvent) : void
      {
         var item:DropDownMenuItem = e.currentTarget as DropDownMenuItem;
         var itemIndex:int = this.m_rendererList.indexOf(item);
         if(this.m_highlightIndex >= 0 && this.m_highlightIndex < this.m_rendererList.length)
         {
            this.m_rendererList[this.m_highlightIndex].setState(DropDownMenuItem.STATE_OUT);
         }
         this.m_selectedIndex = this.m_highlightIndex = itemIndex;
         this.m_rendererList[this.m_highlightIndex].setState(DropDownMenuItem.STATE_OVER);
         dispatchEvent(new Event(ITEM_SELECT_EVENT));
      }
      
      public function getSelectedIndex() : int
      {
         return this.m_selectedIndex;
      }
      
      override public function dispose() : void
      {
         this.disposeLastTime();
         super.dispose();
      }
   }
}

