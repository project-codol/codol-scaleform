package codo.component
{
   import codo.style.TextStyle;
   import codo.utils.TextUtil;
   import flash.display.DisplayObject;
   import flash.utils.getDefinitionByName;
   
   public class ItemFooterIndicator extends ItemFooterButton
   {
      
      public static const ICON_LINKAGE_LOCKED:String = "icon_slot_lock";
      
      public static const ICON_LINKAGE_CHECKED:String = "icon_slot_checked";
      
      public static const ICON_LINKAGE_INFO:String = "icon_slot_info";
      
      public static const ICON_HEIGHT:int = 16;
      
      private var mEnabled:Boolean = false;
      
      public function ItemFooterIndicator()
      {
         super();
         isInteractiveEnabled = false;
      }
      
      override public function set height(h:Number) : void
      {
         myHitArea.height = myLabel.height = h;
      }
      
      override public function get width() : Number
      {
         return myHitArea.width;
      }
      
      override public function get height() : Number
      {
         return myHitArea.height;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         this.mEnabled = value;
         visible = this.mEnabled;
      }
      
      override public function get enabled() : Boolean
      {
         return this.mEnabled;
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
         this.layout();
      }
      
      public function set icon(linkage:String) : void
      {
         var icon:DisplayObject = null;
         while(Boolean(myIconHolder.numChildren))
         {
            myIconHolder.removeChildAt(0);
         }
         var iconClass:Class = getDefinitionByName(linkage) as Class;
         if(Boolean(iconClass))
         {
            icon = new iconClass() as DisplayObject;
            myIconHolder.addChild(icon);
            myIconHolder.height = ICON_HEIGHT;
            myIconHolder.scaleX = myIconHolder.scaleY;
            myIconHolder.visible = true;
         }
         this.layout();
      }
      
      override public function set label(value:String) : void
      {
         super.label = value;
         this.layout();
      }
      
      private function layout() : void
      {
         myLabel.alignment = TextStyle.HALIGN_LEFT;
         var wholeWidth:Number = myIconHolder.width + myLabel.textWidth;
         var initX:Number = (myHitArea.width - wholeWidth) / 2 + myHitArea.x;
         myIconHolder.x = initX;
         myLabel.x = myIconHolder.x + myIconHolder.width;
         myLabel.width = myHitArea.width - myLabel.x;
         TextUtil.resizeTextToFitWidth(myLabel.myTextClip);
      }
   }
}

