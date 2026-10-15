package codo.component.loadout
{
   import codo.objects.ProductObj;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import fsg.util.FsgImageHolder;
   
   public class HostageChampionListItemPerkComponent extends MovieClip
   {
      
      private static const IMAGE_LINK:String = "codo.shared.pause.HostageChampionListItemPerkImage";
      
      private static const PERK_OFFSET:int = 18;
      
      public function HostageChampionListItemPerkComponent()
      {
         super();
      }
      
      public function setData(perks:Vector.<ProductObj>) : void
      {
         var i:int = 0;
         var cls:Class = null;
         var imageHolder:FsgImageHolder = null;
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         for(i = 0; i < perks.length; i++)
         {
            cls = getDefinitionByName(IMAGE_LINK) as Class;
            imageHolder = new cls();
            imageHolder.setImage(perks[i].imageURL);
            imageHolder.x = PERK_OFFSET * i;
            imageHolder.y = i % 2 * PERK_OFFSET;
            addChild(imageHolder);
         }
      }
   }
}

