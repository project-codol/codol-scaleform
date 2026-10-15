package codo.views.hudDMZ
{
   import codo.localization.DictDmz;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   
   public class MarkerHintPanel extends MovieClip
   {
      
      public var myMark:KeyHint;
      
      public var myCancelMark:KeyHint;
      
      public function MarkerHintPanel()
      {
         super();
         this.myMark.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+attack");
         this.myMark.myLabel.text = LocalizeUtil.localize(DictDmz.MARK);
         this.myCancelMark.myKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+toggleads_throw");
         this.myCancelMark.myLabel.text = LocalizeUtil.localize(DictDmz.CANCEL_MARK);
      }
   }
}

