package codo.objects
{
   public dynamic class ModeObj extends CustomObject
   {
      
      public var id:String = "";
      
      public var name:String = "";
      
      public var description:String = "";
      
      public var alias:String = "";
      
      public var image:String = "";
      
      public var minPlayers:uint = 0;
      
      public var maxPlayers:uint = 0;
      
      public var defaultPlayers:uint = 18;
      
      public function ModeObj(cObj:Object = null)
      {
         super(cObj);
      }
      
      public function get isDMZ() : Boolean
      {
         return this.id == "dmz" || this.id == "tdmz";
      }
      
      public function get isTDMZ() : Boolean
      {
         return this.id == "tdmz";
      }
      
      public function get isSpy() : Boolean
      {
         return this.id == "spy";
      }
   }
}

