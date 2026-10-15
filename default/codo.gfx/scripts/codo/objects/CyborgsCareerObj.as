package codo.objects
{
   public class CyborgsCareerObj extends CustomObject
   {
      
      public var kills:uint = 0;
      
      public var revives:uint = 0;
      
      public var downs:uint = 0;
      
      public var juggernautKills:uint = 0;
      
      public var headshots:uint = 0;
      
      public var tokensUsed:uint = 0;
      
      public function CyborgsCareerObj(cObj:Object = null)
      {
         super(cObj);
      }
   }
}

