package codo.views.hudZombieArena
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.ContentContainer;
   import codo.component.TextField;
   import codo.localization.DictHud;
   import codo.objects.ZombieArenaSpecializationObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ZombieArenaRoleSelection extends MovieClip
   {
      
      private static const FRAME_WIDTH:Number = 669;
      
      private static const FRAME_HEIGHT:Number = 325;
      
      private static const LABEL_WIDTH:Number = 298;
      
      private static const LABEL_HEIGHT:Number = 40;
      
      private static const FOCUS_ALPHA:Number = 1;
      
      private static const UNFOCUS_ALPHA:Number = 0.4;
      
      public var myFrame:ContentContainer;
      
      public var mySpecialization0:ZombieArenaSpecializationDisplay;
      
      public var mySpecialization1:ZombieArenaSpecializationDisplay;
      
      public var mySpecialization2:ZombieArenaSpecializationDisplay;
      
      public var mySpecialization3:ZombieArenaSpecializationDisplay;
      
      public var myHeader:TextField;
      
      public var mySubHeader:TextField;
      
      public var myDefenderLabel:TextField;
      
      public var myAttackerLabel:TextField;
      
      public var myDefenderKey:TextField;
      
      public var myAttackerKey:TextField;
      
      public var myAttackerHitArea:MovieClip;
      
      public var myDefenderHitArea:MovieClip;
      
      public var myAttackerButtonBG:MovieClip;
      
      public var myDefenderButtonBG:MovieClip;
      
      public function ZombieArenaRoleSelection()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myFrame.hudMode();
         this.myFrame.width = FRAME_WIDTH;
         this.myFrame.height = FRAME_HEIGHT;
         this.myHeader.alignment = TextStyle.HALIGN_CENTER;
         this.myHeader.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHeader.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myHeader.width = this.myFrame.width;
         this.myHeader.height = this.myFrame.height;
         this.mySubHeader.font = GlobalGuide.FONT_FACE_BOLD;
         this.mySubHeader.fontSize = GlobalGuide.FONT_SIZE_TINY;
         this.mySubHeader.alignment = TextStyle.HALIGN_CENTER;
         this.mySubHeader.width = this.myFrame.width;
         this.myDefenderLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myAttackerLabel.alignment = TextStyle.HALIGN_CENTER;
         this.myDefenderLabel.width = LABEL_WIDTH;
         this.myAttackerLabel.width = LABEL_WIDTH;
         this.myDefenderLabel.height = LABEL_HEIGHT;
         this.myAttackerLabel.height = LABEL_HEIGHT;
         this.myDefenderLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myAttackerLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myDefenderLabel.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myAttackerLabel.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myDefenderKey.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myAttackerKey.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myDefenderKey.fontSize = GlobalGuide.FONT_SIZE_GIGANTIC;
         this.myAttackerKey.fontSize = GlobalGuide.FONT_SIZE_GIGANTIC;
         this.myDefenderKey.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myAttackerKey.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
         this.myDefenderKey.height = 80;
         this.myAttackerKey.height = 80;
         this.myAttackerKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+melee");
         this.myDefenderKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+tact");
         this.myHeader.text = LocalizeUtil.localize(DictHud.ZOMBIE_ARENA_ROLE_SELECTION_HEADER);
         this.mySubHeader.text = LocalizeUtil.localize(DictHud.ZOMBIE_ARENA_ROLE_SELECTION_SUBHEADER);
         this.myDefenderLabel.text = LocalizeUtil.localize(DictHud.ZOMBIE_ARENA_ROLE_SELECTION_DEFENDER_LABEL).toUpperCase();
         this.myAttackerLabel.text = LocalizeUtil.localize(DictHud.ZOMBIE_ARENA_ROLE_SELECTION_ATTACKER_LABEL).toUpperCase();
         this.myAttackerHitArea.addEventListener(MouseEvent.MOUSE_DOWN,this.handleAttackClicked);
         this.myDefenderHitArea.addEventListener(MouseEvent.MOUSE_DOWN,this.handleDefenderClicked);
         this.myAttackerHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.handleAttackerHover);
         this.myAttackerHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.handleAttackerUnhover);
         this.myDefenderHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.handleDefenderHover);
         this.myDefenderHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.handleDefenderUnhover);
         this.myAttackerButtonBG.alpha = UNFOCUS_ALPHA;
         this.myDefenderButtonBG.alpha = UNFOCUS_ALPHA;
      }
      
      public function setData(data:Object) : void
      {
         this.myDefenderLabel.text = data.roles[0].label;
         this.myAttackerLabel.text = data.roles[1].label;
         this.setSkills(data.skills);
      }
      
      public function setSkills(skills:Array) : void
      {
         var specializationData:ZombieArenaSpecializationObj = null;
         var length:Number = skills.length;
         for(var i:Number = 0; i < length; i++)
         {
            specializationData = new ZombieArenaSpecializationObj(skills[i].type,skills[i].label,skills[i].description,skills[i].image);
            this["mySpecialization" + i].setData(specializationData);
         }
      }
      
      public function handleAttackClicked(e:MouseEvent) : void
      {
         CFunctionInGameContainer.AS_ZombieArenaHandleSelection(1);
      }
      
      public function handleDefenderClicked(e:MouseEvent) : void
      {
         CFunctionInGameContainer.AS_ZombieArenaHandleSelection(0);
      }
      
      private function handleAttackerHover() : void
      {
         this.myAttackerButtonBG.alpha = FOCUS_ALPHA;
      }
      
      private function handleAttackerUnhover() : void
      {
         this.myAttackerButtonBG.alpha = UNFOCUS_ALPHA;
      }
      
      private function handleDefenderHover() : void
      {
         this.myDefenderButtonBG.alpha = FOCUS_ALPHA;
      }
      
      private function handleDefenderUnhover() : void
      {
         this.myDefenderButtonBG.alpha = UNFOCUS_ALPHA;
      }
   }
}

