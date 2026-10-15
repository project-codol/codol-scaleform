package codo.objects
{
   public class MatchSelectOptionObj
   {
      
      public static const UNLOCK_LEVEL_NONE:int = -1;
      
      public var id:String;
      
      public var name:String;
      
      public var locked:Boolean;
      
      public var unlockLevel:int;
      
      public var isNew:Boolean;
      
      public var isFeatured:Boolean;
      
      public var tooltip:String;
      
      public function MatchSelectOptionObj(_id:String, _name:String, _tooltip:String = null, _locked:Boolean = false, _unlockLevel:int = -1, _isNew:Boolean = false, _isFeatured:Boolean = false)
      {
         super();
         this.id = _id;
         this.name = _name;
         this.tooltip = _tooltip;
         this.locked = _locked;
         this.unlockLevel = _unlockLevel;
         this.isNew = _isNew;
         this.isFeatured = _isFeatured;
      }
      
      public function get label() : String
      {
         return this.name;
      }
   }
}

