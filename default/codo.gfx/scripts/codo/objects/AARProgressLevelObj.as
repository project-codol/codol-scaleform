package codo.objects
{
   public class AARProgressLevelObj
   {
      
      public var fullLabel:String;
      
      public var displayLevel:String;
      
      public var rank:int;
      
      public var isMaxRank:Boolean;
      
      public function AARProgressLevelObj(_fullLabel:String, _displayLevel:String, _rank:int, _isMaxRank:Boolean = false)
      {
         super();
         this.fullLabel = _fullLabel;
         this.displayLevel = _displayLevel;
         this.rank = _rank;
         this.isMaxRank = _isMaxRank;
      }
   }
}

