package codo.views.hudDMZ
{
   import codo.localization.DictDmz;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   
   public class GhostKeyHintPanel extends MovieClip
   {
      
      public var myShift:KeyHint;
      
      public var mySpace:KeyHint;
      
      public var mySuicide:KeyHint;
      
      public function GhostKeyHintPanel()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this.myShift.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+breath_sprint");
         this.myShift.myLabel.text = LocalizeUtil.localize(DictDmz.GHOST_SPRINT);
         this.mySpace.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+gostand");
         this.mySpace.myLabel.text = LocalizeUtil.localize(DictDmz.GHOST_FLYUP);
         this.mySuicide.myKey.text = "8";
         this.mySuicide.myLabel.text = LocalizeUtil.localize(DictDmz.GHOST_SUICIDE);
      }
   }
}

