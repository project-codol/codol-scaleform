package codo.component.matchselect
{
   import codo.component.core.UIInteractiveComponent;
   import codo.style.GlobalGuide;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class RandomRewardTextButton extends UIInteractiveComponent
   {
      
      public var myLabel:TextField;
      
      public function RandomRewardTextButton()
      {
         super();
         this.myLabel.text = "@SF_UI_VIEW_REWARDS";
         this.toNormalState();
      }
      
      override protected function onMouseOver() : void
      {
         super.onMouseOver();
         this.toHighlightState();
      }
      
      override protected function onMouseOut() : void
      {
         super.onMouseOut();
         this.toNormalState();
      }
      
      protected function toNormalState() : void
      {
         this.myLabel.textColor = 14832640;
         var tfm:TextFormat = this.myLabel.getTextFormat();
         tfm.underline = false;
         this.myLabel.setTextFormat(tfm);
      }
      
      protected function toHighlightState() : void
      {
         this.myLabel.textColor = GlobalGuide.WHITE;
         var tfm:TextFormat = this.myLabel.getTextFormat();
         tfm.underline = true;
         this.myLabel.setTextFormat(tfm);
      }
   }
}

