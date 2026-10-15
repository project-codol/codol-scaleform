package codo.objects
{
   public dynamic class SettingsOptionObj
   {
      
      public var id:int;
      
      public var label:String;
      
      public var enabled:Boolean;
      
      public function SettingsOptionObj(id:int = 0, label:String = null, enabled:Boolean = true)
      {
         super();
         this.id = id;
         this.label = label;
         this.enabled = enabled;
      }
   }
}

