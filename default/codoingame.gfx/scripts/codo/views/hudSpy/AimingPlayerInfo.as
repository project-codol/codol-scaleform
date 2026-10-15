package codo.views.hudSpy
{
   import codo.constants.SpyModeRoleType;
   import codo.localization.DictHud;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.SpyUtil;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class AimingPlayerInfo extends MovieClip
   {
      
      public static const STATE_DEAD_COLOR:uint = 15080219;
      
      public static const STATE_DYING_COLOR:uint = 15080219;
      
      public static const STATE_SERIOUSLY_INJURED_COLOR:uint = 14643729;
      
      public static const STATE_INJURED_COLOR:uint = 15712782;
      
      public static const STATE_MINOR_INJURED_COLOR:uint = 11326979;
      
      public static const STATE_HEALTH_COLOR:uint = 6996736;
      
      public var myName:TextField;
      
      public var myNickname:PlayerNickname;
      
      public var myState:TextField;
      
      public var myFriend:TextField;
      
      public function AimingPlayerInfo()
      {
         super();
         this.myName.autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function setData(data:Object) : void
      {
         var health:int = 0;
         var state:String = null;
         var color:uint = 0;
         if(Boolean(data.disguised))
         {
            this.myState.visible = this.myNickname.visible = false;
            this.myName.text = SpyUtil.getLocalizedRoleName(SpyModeRoleType.SPY_ROLE_SPY);
            this.myName.textColor = SpyUtil.getRoleColor(SpyModeRoleType.SPY_ROLE_SPY);
         }
         else
         {
            this.myName.visible = this.myState.visible = true;
            this.myFriend.visible = false;
            this.myName.textColor = SpyUtil.getRoleColor(data.role);
            health = int(data.health);
            if(health >= 0)
            {
               this.myName.text = data.name;
               this.myNickname.nickname = data.nickname;
               this.myNickname.visible = true;
               if(Boolean(data.isSummonedZombie))
               {
                  this.myNickname.visible = false;
               }
               if(health == 0)
               {
                  state = DictHud.SPY_STATE_DEAD;
                  color = STATE_DEAD_COLOR;
               }
               else if(health <= 20)
               {
                  state = DictHud.SPY_STATE_DYING;
                  color = STATE_DYING_COLOR;
               }
               else if(health <= 40)
               {
                  state = DictHud.SPY_STATE_SERIOUSLY_INJURED;
                  color = STATE_SERIOUSLY_INJURED_COLOR;
               }
               else if(health <= 60)
               {
                  state = DictHud.SPY_STATE_INJURED;
                  color = STATE_INJURED_COLOR;
               }
               else if(health <= 80)
               {
                  state = DictHud.SPY_STATE_MINOR_INJURED;
                  color = STATE_MINOR_INJURED_COLOR;
               }
               else
               {
                  state = DictHud.SPY_STATE_HEALTH;
                  color = STATE_HEALTH_COLOR;
               }
               this.myState.text = "[" + LocalizeUtil.localize(state) + "]";
               this.myState.textColor = color;
               if(Boolean(data.isFriend))
               {
                  this.myFriend.text = "[" + LocalizeUtil.localize(DictHud.SPY_TEMP_FRIEND_LABEL) + "]";
                  this.myFriend.visible = true;
               }
            }
            else
            {
               this.myNickname.visible = false;
               this.myName.text = LocalizeUtil.localize(DictHud.SPY_BODY_NOT_VIEWED);
               this.myState.text = LocalizeUtil.localize(DictHud.SPY_VIEW_BODY_HINT);
               this.myState.textColor = GlobalGuide.WHITE;
            }
         }
         this.myState.width = this.myState.textWidth;
         this.myFriend.width = this.myFriend.textWidth;
         if(this.myName.width > this.myState.width)
         {
            this.myName.x = 0;
            this.myNickname.x = (this.myName.width - this.myNickname.width) / 2;
            this.myState.x = (this.myName.width - this.myState.width) / 2;
            if(this.myName.width > this.myFriend.width)
            {
               this.myFriend.x = (this.myName.width - this.myFriend.width) / 2;
            }
            else
            {
               this.myFriend.x = (this.myFriend.width - this.myName.width) / 2;
            }
         }
         else
         {
            this.myState.x = 0;
            this.myNickname.x = (this.myState.width - this.myNickname.width) / 2;
            this.myName.x = (this.myState.width - this.myName.width) / 2;
            if(this.myState.width > this.myFriend.width)
            {
               this.myFriend.x = (this.myState.width - this.myFriend.width) / 2;
            }
            else
            {
               this.myFriend.x = (this.myFriend.width - this.myState.width) / 2;
            }
         }
      }
   }
}

