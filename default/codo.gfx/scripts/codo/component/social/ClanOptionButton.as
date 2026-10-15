package codo.component.social
{
   import codo.component.Button;
   import codo.localization.DictSetting;
   import codo.objects.RightClickMenuItemObj;
   import codo.style.ClanGuide;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   
   public class ClanOptionButton extends Button
   {
      
      private static const DROP_DOWN_PANEL_LINK:String = "codo.social.socialDropDown";
      
      private static const DROP_DOWN_ITEM_LINK:String = "codo.social.dropDownBtn2";
      
      private static const GAP:int = 5;
      
      public var myIcon:MovieClip;
      
      private var mDropDownMenu:SocialDropDown;
      
      protected var mOptions:Vector.<RightClickMenuItemObj>;
      
      public function ClanOptionButton()
      {
         super();
         myLabel.textStyle = ClanGuide.styleClanOptionLabel;
         myLabel.text = DictSetting.OPTIONS;
         var contentWidth:Number = this.myIcon.width + myLabel.textWidth + GAP;
         myLabel.x = (myHitArea.width - contentWidth) / 2;
         myLabel.y = 4;
         this.myIcon.x = myLabel.x + myLabel.textWidth + GAP;
         this.initDropDownMenu();
         this.initClickListener();
      }
      
      private function initDropDownMenu() : void
      {
         var cls:Class = getDefinitionByName(DROP_DOWN_PANEL_LINK) as Class;
         this.mDropDownMenu = new cls() as SocialDropDown;
         this.mDropDownMenu.setDropDownBtnLinkage(DROP_DOWN_ITEM_LINK);
         this.mDropDownMenu.setItemWidth(SocialDropDownBtn2.ITEM_WIDTH);
         this.mDropDownMenu.setItemHeight(SocialDropDownBtn2.ITEM_HEIGHT);
      }
      
      private function initClickListener() : void
      {
         registerClickEvent(this.showOptions);
      }
      
      override protected function showHighlight() : void
      {
         super.showHighlight();
         this.myIcon.gotoAndStop(2);
      }
      
      override protected function endHighlight() : void
      {
         super.endHighlight();
         this.myIcon.gotoAndStop(1);
      }
      
      public function setOption(options:Vector.<RightClickMenuItemObj>) : void
      {
         this.mOptions = options;
      }
      
      protected function showOptions() : void
      {
         this.mDropDownMenu.setOptionMenu(this.mOptions,null);
         addChild(this.mDropDownMenu);
         this.mDropDownMenu.x = myHitArea.x;
         this.mDropDownMenu.y = myHitArea.y + myHitArea.height;
         stage.addEventListener(MouseEvent.CLICK,this.onStageClicked);
      }
      
      private function onStageClicked(evt:MouseEvent) : void
      {
         if(evt.target != myHitArea)
         {
            removeChild(this.mDropDownMenu);
            stage.removeEventListener(MouseEvent.CLICK,this.onStageClicked);
         }
      }
   }
}

