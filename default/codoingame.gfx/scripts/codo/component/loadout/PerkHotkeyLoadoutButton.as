package codo.component.loadout
{
   import codo.objects.ProductObj;
   import flash.display.MovieClip;
   import fsg.util.FsgImageHolder;
   
   public class PerkHotkeyLoadoutButton extends HotkeyLoadoutButton
   {
      
      private static const NUM_PERKS:int = 6;
      
      public var myPerk0:MovieClip;
      
      public var myPerk1:MovieClip;
      
      public var myPerk2:MovieClip;
      
      public var myPerk3:MovieClip;
      
      public var myPerk4:MovieClip;
      
      public var myPerk5:MovieClip;
      
      private var mPerkClips:Vector.<MovieClip>;
      
      public function PerkHotkeyLoadoutButton()
      {
         super();
         this.mPerkClips = new <MovieClip>[this.myPerk0,this.myPerk1,this.myPerk2,this.myPerk3,this.myPerk4,this.myPerk5];
      }
      
      public function setPerks(perks:Array) : void
      {
         var perkData:ProductObj = null;
         var perk:MovieClip = null;
         var image:FsgImageHolder = null;
         var len:int = 0;
         this.clearPerks();
         len = int(perks.length);
         mEmpty = true;
         for(var i:int = 0; i < len; i++)
         {
            perk = this.mPerkClips[i];
            image = perk["myImage"];
            perkData = new ProductObj(perks[i]);
            image.setImage(perkData.imageURL);
            image.visible = true;
            mEmpty = mEmpty && perkData.id == 0;
         }
         myBackground.gotoAndStop(mEmpty ? EMPTY_FRAME : UP_STATE_FRAME);
      }
      
      private function clearPerks() : void
      {
         var perk:MovieClip = null;
         var image:FsgImageHolder = null;
         for(var i:int = 0; i < NUM_PERKS; i++)
         {
            perk = this.mPerkClips[i];
            image = perk["myImage"];
            image.visible = false;
         }
      }
   }
}

