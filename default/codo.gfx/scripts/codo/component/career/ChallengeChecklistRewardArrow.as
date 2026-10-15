package codo.component.career
{
   import codo.component.core.UIInteractiveComponent;
   import flash.text.TextField;
   
   public class ChallengeChecklistRewardArrow extends UIInteractiveComponent
   {
      
      public var myValue:TextField;
      
      public function ChallengeChecklistRewardArrow()
      {
         super();
         this.myValue.text = "";
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         this.myValue.text = data as String;
      }
   }
}

