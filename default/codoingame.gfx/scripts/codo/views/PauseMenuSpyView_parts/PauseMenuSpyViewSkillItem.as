package codo.views.PauseMenuSpyView_parts
{
   import codo.component.TextField;
   import codo.component.core.UIInteractiveComponent;
   import codo.style.GlobalGuide;
   import codo.style.SpyHudGuide;
   import codo.utils.LocalizeUtil;
   import fsg.util.FsgImageHolder;
   
   public class PauseMenuSpyViewSkillItem extends UIInteractiveComponent
   {
      
      public var myIcon:FsgImageHolder;
      
      public var myDesc:TextField;
      
      public function PauseMenuSpyViewSkillItem()
      {
         super();
         this.myDesc.textStyle = SpyHudGuide.PauseMenuSpyViewSkillItemDesc;
         this.myDesc.width = 463;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.myIcon.setImage(data.icon);
         this.myDesc.myTextClip.textColor = GlobalGuide.WHITE;
         LocalizeUtil.setTextFieldColorWithLocalizedString(this.myDesc.myTextClip,"@" + data.desc);
      }
   }
}

