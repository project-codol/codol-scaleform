package codo.objects
{
   public class ScrollListHeaderRestrictionObj extends ScrollListHeaderObj
   {
      
      public var numBanned:uint;
      
      public var toggleBannedCallback:Function;
      
      public function ScrollListHeaderRestrictionObj()
      {
         super();
         classLinkage = "codo.shared.restrictionOptionListHeader";
      }
   }
}

