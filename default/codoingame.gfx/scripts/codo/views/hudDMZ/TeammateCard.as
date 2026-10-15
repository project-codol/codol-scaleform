package codo.views.hudDMZ
{
   import codo.utils.StringUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TeammateCard extends MovieClip
   {
      
      public var myName:TextField;
      
      public function TeammateCard()
      {
         super();
      }
      
      public function setName(name:String) : void
      {
         this.myName.text = name;
         StringUtil.fitTextField(this.myName);
      }
   }
}

