package codo.views.hudZombieArena
{
   import codo.common.CFunctionInGameContainer;
   import codo.component.TextField;
   import codo.objects.ZombieArenaSpecializationObj;
   import codo.style.GlobalGuide;
   import codo.style.TextStyle;
   import codo.utils.LocalizeUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class ZombieArenaSpecializationSelection extends MovieClip
   {
      
      private static const LABEL_WIDTH:Number = 150;
      
      private static const FOCUS_ALPHA:Number = 1;
      
      private static const UNFOCUS_ALPHA:Number = 0.4;
      
      public var myFrame:MovieClip;
      
      public var mySpecialization0:ZombieArenaSpecializationDisplay;
      
      public var mySpecialization1:ZombieArenaSpecializationDisplay;
      
      public var myHeader:TextField;
      
      public var mySpecializationLabel0:TextField;
      
      public var mySpecializationLabel1:TextField;
      
      public var myDefenderKey:TextField;
      
      public var myAttackerKey:TextField;
      
      public var myAttackerHitArea:MovieClip;
      
      public var myDefenderHitArea:MovieClip;
      
      public var myAttackerButtonBG:MovieClip;
      
      public var myDefenderButtonBG:MovieClip;
      
      public function ZombieArenaSpecializationSelection()
      {
         super();
         this.initStage();
      }
      
      private function initStage() : void
      {
         this.myHeader.alignment = TextStyle.HALIGN_CENTER;
         this.myHeader.font = GlobalGuide.FONT_FACE_BOLD;
         this.myHeader.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.mySpecializationLabel0.alignment = TextStyle.HALIGN_CENTER;
         this.mySpecializationLabel1.alignment = TextStyle.HALIGN_CENTER;
         this.mySpecializationLabel0.font = GlobalGuide.FONT_FACE_BOLD;
         this.mySpecializationLabel1.font = GlobalGuide.FONT_FACE_BOLD;
         this.mySpecializationLabel0.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.mySpecializationLabel1.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.mySpecializationLabel0.width = LABEL_WIDTH;
         this.mySpecializationLabel1.width = LABEL_WIDTH;
         this.mySpecializationLabel0.text = "";
         this.mySpecializationLabel1.text = "";
         this.myDefenderKey.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myAttackerKey.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myDefenderKey.fontSize = GlobalGuide.FONT_SIZE_GIGANTIC;
         this.myAttackerKey.fontSize = GlobalGuide.FONT_SIZE_GIGANTIC;
         this.myDefenderKey.height = 80;
         this.myAttackerKey.height = 80;
         this.myAttackerKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+melee");
         this.myDefenderKey.text = LocalizeUtil.localizeFirstKeyBindingForCommand("+tact");
         this.myAttackerHitArea.addEventListener(MouseEvent.MOUSE_DOWN,this.handleAttackClicked);
         this.myDefenderHitArea.addEventListener(MouseEvent.MOUSE_DOWN,this.handleDefenderClicked);
         this.myAttackerHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.handleAttackerHover);
         this.myAttackerHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.handleAttackerUnhover);
         this.myDefenderHitArea.addEventListener(MouseEvent.MOUSE_OVER,this.handleDefenderHover);
         this.myDefenderHitArea.addEventListener(MouseEvent.MOUSE_OUT,this.handleDefenderUnhover);
         this.myAttackerButtonBG.alpha = UNFOCUS_ALPHA;
         this.myDefenderButtonBG.alpha = UNFOCUS_ALPHA;
      }
      
      public function setData(data:Object, isZChamp:Boolean) : void
      {
         var length:Number = Number(data.roles.length);
         for(var i:Number = 0; i < length; i++)
         {
            this["mySpecializationLabel" + i].text = data.roles[i].label;
         }
         this.setSkills(data.skills);
         if(!isZChamp)
         {
            this.myFrame.myContainer.gotoAndStop(5);
            this.myFrame.width = 669;
            this.myFrame.height = 325;
            this.myDefenderKey.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
            this.myAttackerKey.fontColor = GlobalGuide.CODO_BLUE_HIGHLIGHT;
            this.myHeader.width = this.myFrame.width;
            this.myHeader.height = this.myFrame.height;
         }
         else
         {
            this.myFrame.width = 771;
            this.myFrame.height = 390;
            this.myDefenderKey.fontColor = GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE;
            this.myAttackerKey.fontColor = GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE;
            this.myHeader.width = this.myFrame.width - 80;
            this.myHeader.height = this.myFrame.height;
         }
      }
      
      public function setSkills(skills:Array) : void
      {
         var specializationData:ZombieArenaSpecializationObj = null;
         var length:Number = skills.length;
         var data:Vector.<ZombieArenaSpecializationObj> = new Vector.<ZombieArenaSpecializationObj>();
         for(var i:Number = 0; i < length; i++)
         {
            specializationData = new ZombieArenaSpecializationObj(skills[i].type,skills[i].label,skills[i].description,skills[i].image);
            data.push(specializationData);
         }
         this.mySpecialization0.setData(data[0]);
         this.mySpecialization1.setData(data[1]);
      }
      
      public function setHeader(text:String) : void
      {
         this.myHeader.text = text;
      }
      
      private function handleAttackClicked(e:MouseEvent) : void
      {
         CFunctionInGameContainer.AS_ZombieArenaHandleSelection(1);
      }
      
      private function handleDefenderClicked(e:MouseEvent) : void
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

