package codo.views
{
   import codo.base.BaseView;
   import codo.constants.GameInfo;
   import codo.constants.UITourVOSoundAliases;
   import codo.localization.Dict;
   import codo.utils.LocalizeUtil;
   import components.fsgonboardpopups_part.character.FsgCharacterSelectViewPanel;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class FsgCharacterSelectView extends BaseView
   {
      
      public var myLogo:Sprite;
      
      public var myTitleTF:TextField;
      
      public var myDescriptionTF:TextField;
      
      public var myCharacterPanel:FsgCharacterSelectViewPanel;
      
      public var myScrim:Sprite;
      
      private var mIsInitShow:Boolean = true;
      
      public function FsgCharacterSelectView()
      {
         super();
         var LOCALIZE:Function = LocalizeUtil.localize;
         this.myTitleTF.autoSize = this.myDescriptionTF.autoSize = TextFieldAutoSize.LEFT;
         this.myTitleTF.text = LOCALIZE(Dict.CHARACTER_CREATE_SELECT).toUpperCase();
         this.myDescriptionTF.text = LOCALIZE(Dict.CHARACTER_CREATE_SUBTITLE).toUpperCase();
         this.myScrim.width = GameInfo.stageSize.x;
         this.myScrim.x = GameInfo.stagePosition.x;
         this.myScrim.y = GameInfo.stagePosition.y + GameInfo.stageSize.y - this.myScrim.height;
      }
      
      override protected function showView() : void
      {
         this.myCharacterPanel.initPanel();
         super.showView();
         if(this.mIsInitShow)
         {
            playSound(UITourVOSoundAliases.CHARACTER_SELECT_INTRO);
            this.mIsInitShow = false;
         }
      }
      
      override protected function hideView() : void
      {
         this.myCharacterPanel.dispose();
         super.hideView();
      }
   }
}

