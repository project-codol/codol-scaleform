package codo.component.diagram
{
   public class AbilityDiagramData
   {
      
      public var min:Number = 0;
      
      public var max:Number = 1;
      
      public var current:Number = 0.5;
      
      public function AbilityDiagramData(min:Number, max:Number, current:Number)
      {
         super();
         this.min = min;
         this.max = max;
         this.current = current;
      }
   }
}

