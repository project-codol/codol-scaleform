package codo.component.navigation
{
   import codo.component.Button;
   import codo.utils.LocalizeUtil;
   
   public class SubNavTabButton extends Button
   {
      
      public function SubNavTabButton()
      {
         super();
         myLabel.x = 0;
         myLabel.y = 1;
      }
      
      override public function setData(data:*) : void
      {
         super.setData(data);
         width = myLabel.textWidth + 20;
      }
      
      override public function set label(label:String) : void
      {
         myLabel.text = LocalizeUtil.localize(label);
      }
      
      override public function draw() : void
      {
         super.draw();
         myBackground.width = mWidth;
      }
      
      override public function set height(h:Number) : void
      {
         myBackground.height = h;
         myLabel.myTextClip.height = h - 2;
      }
   }
}

