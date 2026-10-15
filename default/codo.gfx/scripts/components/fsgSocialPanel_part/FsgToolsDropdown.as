package components.fsgSocialPanel_part
{
   import codo.constants.GameInfo;
   import codo.constants.SE_ID;
   import codo.objects.RightClickMenuItemObj;
   import codo.utils.TextUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import fsg.shared.BehaviourClickable;
   import fsg.util.FsgAudioUtil;
   
   public class FsgToolsDropdown extends MovieClip
   {
      
      public var myBackground:MovieClip;
      
      public var m_ToolOptions:Vector.<RightClickMenuItemObj>;
      
      public var m_ClickableArray:Array;
      
      public var m_MenuArray:Array;
      
      private var m_para:*;
      
      private var m_id:String;
      
      public function FsgToolsDropdown()
      {
         super();
      }
      
      public function set menuOptions(m_Options:Vector.<RightClickMenuItemObj>) : void
      {
         var ypos:Number = NaN;
         var count:Number = NaN;
         var item:MovieClip = null;
         this.m_ToolOptions = m_Options;
         this.m_MenuArray = [];
         this.m_ClickableArray = [];
         ypos = 0;
         count = 0;
         for(var i:int = 0; i < this.m_ToolOptions.length; i++)
         {
            if(this.m_ToolOptions[i].enable == true)
            {
               item = new fsgToolWindowItem();
               TextUtil.replaceEnFont(item.myText.myTextTF,String(this.m_ToolOptions[i].label),GameInfo.GAME_FONT_AENCY_FB,0,GameInfo.GAME_FONT_L,0);
               item.y = ypos;
               this.m_MenuArray[count] = item;
               this.m_ClickableArray[count] = new BehaviourClickable(item);
               this.m_ClickableArray[count].addMouseOverCallback(this.onMouseOver,count);
               this.m_ClickableArray[count].addMouseOutCallback(this.onMouseOut,count);
               this.m_ClickableArray[count].addClickCallback(this.m_ToolOptions[i].handle,this.m_para);
               item.addEventListener(MouseEvent.CLICK,this.onItemClickHandle);
               ypos += item.height;
               this.addChild(item);
               count++;
            }
         }
         this.myBackground.height = ypos;
      }
      
      private function onItemClickHandle(cEvt:MouseEvent) : void
      {
         FsgAudioUtil.getInstance().playSound(SE_ID.UI_MENU_ROLLOUT_PROCEED);
      }
      
      public function onMouseOver(i_index:int) : void
      {
         FsgAudioUtil.getInstance().playSound(SE_ID.GENERAL_ROLLOVER);
         this.m_MenuArray[i_index].gotoAndStop(2);
      }
      
      public function onMouseOut(i_index:int) : void
      {
         this.m_MenuArray[i_index].gotoAndStop(1);
      }
      
      public function set para(para:*) : void
      {
         this.m_para = para;
      }
   }
}

