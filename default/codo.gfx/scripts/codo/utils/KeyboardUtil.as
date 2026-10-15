package codo.utils
{
   import codo.localization.DictKeyboard;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class KeyboardUtil
   {
      
      public static const LOCALIZE:Function = LocalizeUtil.localize;
      
      public function KeyboardUtil()
      {
         super();
      }
      
      public static function populateKeyboardControls(layoutClip:MovieClip, isCodControls:Boolean, codFrame:int) : void
      {
         var fieldTF:TextField = null;
         var spaceBarValueTF:TextField = null;
         var fields:Vector.<String> = isCodControls ? localizedControlsCoD : localizedControlsCS_CF;
         var len:uint = fields.length;
         var i:uint = 0;
         var spaceBarLabelTF:TextField = layoutClip.getChildByName("mySpaceBarLabelTF") as TextField;
         spaceBarValueTF = layoutClip.getChildByName("mySpaceBarValueTF") as TextField;
         spaceBarLabelTF.autoSize = spaceBarValueTF.autoSize = TextFieldAutoSize.LEFT;
         spaceBarLabelTF.text = LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_SPACEBAR).concat(" - ");
         spaceBarValueTF.x = spaceBarLabelTF.x + spaceBarLabelTF.textWidth + 3;
         spaceBarValueTF.text = DictKeyboard.KEYBOARD_CONTROL_JUMP;
         var cscfFrame:int = codFrame == 1 ? 2 : 1;
         for(layoutClip.gotoAndStop(isCodControls ? codFrame : cscfFrame); i < len; )
         {
            fieldTF = layoutClip.getChildByName("myField".concat(i)) as TextField;
            if(i < 7)
            {
               fieldTF.autoSize = TextFieldAutoSize.RIGHT;
            }
            else if(i == 7)
            {
               fieldTF.autoSize = TextFieldAutoSize.CENTER;
            }
            else
            {
               fieldTF.autoSize = TextFieldAutoSize.LEFT;
            }
            fieldTF.text = fields[i];
            i++;
         }
      }
      
      private static function get localizedControlsCoD() : Vector.<String>
      {
         return new <String>["3 - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_WEAPON_ATTACHMENTS)),"1-2 - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_ROTATE_WEAPONS)),"Q - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_TACTICAL_THROWABLES)),"TAB - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_SHOW_SCORE)),"WSDA - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_MOVE)),"SHIFT - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_SPRINT)),"CTRL - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_PRONE)),"C - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_CROUCH)),"4-8 - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_USE_POINT_REWARD)),"E - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_MELEE)),"R - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_RELOAD)),"G - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_GRENADE)),"F - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_USE_ITEM))];
      }
      
      private static function get localizedControlsCS_CF() : Vector.<String>
      {
         return new <String>["3 - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_TACTICAL_THROWABLES)),"2 - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_GRENADE)),"1/Q - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_ROTATE_WEAPONS)),"TAB - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_SHOW_SCORE)),"WSDA - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_MOVE)),"SHIFT - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_SPRINT)),"CTRL - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_CROUCH)),"C - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_PRONE)),"4-8 - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_USE_POINT_REWARD)),"E - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_USE_ITEM)),"R - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_RELOAD)),"F - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_MELEE)),"V - ".concat(LOCALIZE(DictKeyboard.KEYBOARD_CONTROL_WEAPON_ATTACHMENTS))];
      }
   }
}

