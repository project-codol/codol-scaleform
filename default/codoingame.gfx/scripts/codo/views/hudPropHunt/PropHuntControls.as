package codo.views.hudPropHunt
{
   import flash.display.MovieClip;
   
   public class PropHuntControls extends MovieClip
   {
      
      public var mySpectateItem:PropHuntControlItem;
      
      public var myAbilityItem:PropHuntControlItem;
      
      public var mySlopeItem:PropHuntControlItem;
      
      public var myLockItem:PropHuntControlItem;
      
      public var myRotateItem:PropHuntControlItem;
      
      public var mySwapPropItem:PropHuntControlItem;
      
      public var mySneakItem:PropHuntControlItem;
      
      private var mWidth:Number;
      
      public function PropHuntControls()
      {
         super();
         this.mySpectateItem.setText("@PH_SPECKEY","+actionslot 3");
         this.myAbilityItem.setText("@PH_FLASH","+tact");
         this.mySlopeItem.setText("@PH_SLOPE","+reload","@PH_SLOPED");
         this.myLockItem.setText("@PH_LOCK","+attack","@PH_LOCKED");
         this.myRotateItem.setText("@PH_SPIN","+toggleads_throw");
         this.mySwapPropItem.setText("@PH_CHANGE","+activate");
         this.mySneakItem.setText("@PH_SNEAK","+breath_sprint");
         var items:Vector.<PropHuntControlItem> = new <PropHuntControlItem>[this.mySpectateItem,this.myAbilityItem,this.mySlopeItem,this.myLockItem,this.myRotateItem,this.mySwapPropItem,this.mySneakItem];
         this.mWidth = 0;
         for(var i:uint = 0; i < items.length; i++)
         {
            this.mWidth = Math.max(this.mWidth,items[i].width);
         }
      }
      
      override public function get width() : Number
      {
         return this.mWidth;
      }
   }
}

