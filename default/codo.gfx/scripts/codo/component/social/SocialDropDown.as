package codo.component.social
{
   import codo.component.core.UIInteractiveComponent;
   import codo.objects.RightClickMenuItemObj;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   
   public class SocialDropDown extends UIInteractiveComponent
   {
      
      private var mLinkage:String = "codo.social.dropDownBtn";
      
      private var mItemWidth:Number = 100;
      
      private var mItemHeight:Number = 25;
      
      private var mDropDownBtnKeepers:Vector.<SocialDropDownBtn> = new Vector.<SocialDropDownBtn>();
      
      public var myContainer:MovieClip;
      
      public var myBg:MovieClip;
      
      public function SocialDropDown()
      {
         super();
      }
      
      public function setDropDownBtnLinkage(linkage:String) : void
      {
         this.mLinkage = linkage;
      }
      
      public function setItemWidth(value:Number) : void
      {
         this.mItemWidth = value;
      }
      
      public function setItemHeight(value:Number) : void
      {
         this.mItemHeight = value;
      }
      
      public function setOptionMenu(options:Vector.<RightClickMenuItemObj>, data:Object) : void
      {
         var i:int = 0;
         var itemNum:int = 0;
         var item:SocialDropDownBtn = null;
         for(i = 0; i < this.mDropDownBtnKeepers.length; i++)
         {
            this.mDropDownBtnKeepers[i].visible = false;
         }
         itemNum = 0;
         for(i = 0; i < options.length; i++)
         {
            if(options[i].enable)
            {
               item = this.getItemRender(itemNum);
               item.resetCallback();
               item.registerClickEvent(this.onOptionClicked,{
                  "data":data,
                  "option":options[i]
               });
               item.visible = true;
               item.setData(options[i].label);
               itemNum++;
            }
         }
         this.myBg.width = this.mItemWidth;
         this.myBg.height = itemNum * this.mItemHeight;
      }
      
      private function onOptionClicked(wrapper:Object) : void
      {
         var option:RightClickMenuItemObj = wrapper["option"];
         var data:Object = wrapper["data"];
         var checker:Function = option.enableChecker;
         var handler:Function = option.handle;
         if(checker != null)
         {
            if(Boolean(checker(data)))
            {
               handler(data);
            }
         }
         else
         {
            handler(data);
         }
      }
      
      override public function get height() : Number
      {
         return this.myBg.height;
      }
      
      private function getItemRender(index:int) : SocialDropDownBtn
      {
         var cls:Class = null;
         var item:SocialDropDownBtn = null;
         if(index >= this.mDropDownBtnKeepers.length)
         {
            cls = getDefinitionByName(this.mLinkage) as Class;
            item = new cls() as SocialDropDownBtn;
            item.x = 0;
            item.y = index * item.height;
            this.myContainer.addChild(item);
            this.mDropDownBtnKeepers.push(item);
         }
         return this.mDropDownBtnKeepers[index];
      }
   }
}

