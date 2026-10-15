package codo.views.helpMenu_parts.zhunt
{
   import codo.utils.TextUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import fsg.util.FsgImageHolder;
   
   public class FsgHelpMenuZhuntPartReward extends MovieClip
   {
      
      public var myTitleTF:TextField;
      
      public var myIcon:FsgImageHolder;
      
      public var myNameTF:TextField;
      
      private var mIsFinalBoss:Boolean = false;
      
      public function FsgHelpMenuZhuntPartReward()
      {
         super();
      }
      
      public function set title(title:String) : void
      {
         this.myTitleTF.text = title;
      }
      
      public function set icon(icon:String) : void
      {
         this.myIcon.setImage(icon);
      }
      
      public function set rewardName(name:String) : void
      {
         this.myNameTF.text = name;
         TextUtil.resizeTextToFitWidth(this.myNameTF);
      }
      
      public function set isFinalBoss(isFinalBoss:Boolean) : void
      {
         this.mIsFinalBoss = isFinalBoss;
         var format:TextFormat = this.myTitleTF.getTextFormat();
         if(isFinalBoss)
         {
            format.align = TextFormatAlign.RIGHT;
         }
         else
         {
            format.align = TextFormatAlign.LEFT;
         }
         this.myTitleTF.setTextFormat(format);
      }
      
      public function get isFinalBoss() : Boolean
      {
         return this.mIsFinalBoss;
      }
   }
}

