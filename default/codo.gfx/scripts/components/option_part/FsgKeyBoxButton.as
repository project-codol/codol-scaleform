package components.option_part
{
   import codo.constants.GameInfo;
   import codo.utils.TextUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import fsg.shared.BehaviourAnimatedClickable;
   import fsg.shared.BehaviourAudio;
   import fsg.shared.BehaviourClickable;
   
   public class FsgKeyBoxButton extends MovieClip
   {
      
      public var myValue:MovieClip;
      
      public var myLabel:TextField;
      
      public var myHitArea:MovieClip;
      
      private var m_clickable:BehaviourClickable;
      
      private var m_anim:BehaviourAnimatedClickable;
      
      private var m_audio:BehaviourAudio;
      
      private var m_labelText:String;
      
      public function FsgKeyBoxButton()
      {
         super();
         this.m_clickable = new BehaviourClickable(this.myHitArea);
         this.m_anim = new BehaviourAnimatedClickable(this,this.m_clickable,1,2,2);
         this.m_audio = new BehaviourAudio(this.m_clickable);
         this.m_labelText = this.myLabel.text;
         this.m_clickable.addMouseOverCallback(this.onMouseOver);
         this.m_clickable.addMouseOutCallback(this.onMouseOut);
      }
      
      public function set value(cText:String) : void
      {
         cText ||= "n/a";
         TextUtil.replaceEnFont(this.myValue.myLabel.myTF,cText,GameInfo.GAME_FONT_AENCY_FB_BOLD,15,GameInfo.GAME_FONT_S,15);
      }
      
      public function get value() : String
      {
         return this.myValue.myLabel.myTF.text;
      }
      
      public function set label(cText:String) : void
      {
         this.m_labelText = cText;
         this.myLabel.text = cText;
      }
      
      public function get label() : String
      {
         return this.myLabel.text;
      }
      
      public function registerClickEvent(callback:Function, userData:Object = null) : void
      {
         this.m_clickable.addClickCallback(callback,userData);
      }
      
      private function onMouseOver() : void
      {
         gotoAndStop(2);
         this.myValue.gotoAndStop(2);
         this.label = this.m_labelText;
      }
      
      private function onMouseOut() : void
      {
         gotoAndStop(1);
         this.myValue.gotoAndStop(1);
         this.label = this.m_labelText;
      }
   }
}

