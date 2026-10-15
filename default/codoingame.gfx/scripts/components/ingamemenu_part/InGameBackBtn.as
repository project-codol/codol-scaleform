package components.ingamemenu_part
{
   import codo.constants.TweenParam;
   import codo.localization.Dict;
   import com.greensock.TweenLite;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.TweenPlugin;
   import components.BaseButton;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class InGameBackBtn extends BaseButton
   {
      
      public var btn_TF:TextField;
      
      public var btn_highlight:Sprite;
      
      public function InGameBackBtn()
      {
         super();
         this.btn_TF.text = Dict.BACK;
         this.btn_TF.appendText(" (ESC)");
         this.btn_highlight.alpha = 0;
      }
      
      override protected function onInit() : void
      {
         TweenPlugin.activate([AutoAlphaPlugin]);
         TweenLite.to(this.btn_highlight,0,{"autoAlpha":0});
         this.btn_TF.mouseEnabled = false;
      }
      
      public function set label(txt:String) : void
      {
         this.btn_TF.text = txt;
      }
      
      override protected function setToNormal(cTween:Boolean = true) : void
      {
         super.setToNormal(cTween);
         TweenLite.to(this.btn_highlight,TweenParam.SPD_FADE,{"autoAlpha":0});
      }
      
      override protected function setToRollOver(cTween:Boolean = true) : void
      {
         super.setToRollOver(cTween);
         TweenLite.to(this.btn_highlight,TweenParam.SPD_FADE,{"autoAlpha":1});
      }
   }
}

