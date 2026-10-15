package codo.views.supplyDrop_parts
{
   import codo.component.diagram.CircleDiagram;
   
   public class SupplyDropRewardItemCircleDiagram extends CircleDiagram
   {
      
      public function SupplyDropRewardItemCircleDiagram()
      {
         super();
         myValue.visible = false;
      }
      
      override public function setFillAmount(fillAmount:Number, maxAmount:Number = 1, deltaAmount:Number = 0) : void
      {
         super.setFillAmount(fillAmount,maxAmount,deltaAmount);
      }
   }
}

