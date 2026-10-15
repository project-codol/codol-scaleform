package codo.views.hudSpy
{
   import codo.constants.SpyModeRoleType;
   import codo.constants.SpyRoundType;
   import codo.localization.DictHud;
   import codo.localization.DictMatchResults;
   import codo.utils.LocalizeUtil;
   import codo.utils.SpyUtil;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class RoundResultSplash extends MovieClip
   {
      
      private static const DESC_X_MARGIN:int = 16;
      
      public var myIcon:MovieClip;
      
      public var myText:TextField;
      
      public var myDesc:TextField;
      
      public var myDescBG:MovieClip;
      
      public function RoundResultSplash()
      {
         super();
      }
      
      public function cppSetWinner(data:Object) : void
      {
         var winner:int = 0;
         var round:int = 0;
         var firstCharRect:Rectangle = null;
         var lastCharRect:Rectangle = null;
         var textWidth:int = 0;
         winner = int(data.winner);
         var timeout:Boolean = Boolean(data.isTimeout);
         round = int(data.roundType);
         if(round == SpyRoundType.ROUND_NORMAL)
         {
            this.myDesc.visible = true;
            this.myDescBG.visible = true;
            if(winner == SpyModeRoleType.SPY_ROLE_SPY)
            {
               this.myIcon.gotoAndStop(2);
               this.myText.text = LocalizeUtil.param(DictHud.SPY_ROUND_WINNER,[LocalizeUtil.localize(SpyUtil.getLocalizedRoleName(SpyModeRoleType.SPY_ROLE_SPY))]);
               this.myText.textColor = SpyUtil.getRoleColor(SpyModeRoleType.SPY_ROLE_SPY);
               this.myDesc.text = LocalizeUtil.param(DictHud.SPY_ALL_ENEMY_DOWN,[LocalizeUtil.localize(SpyUtil.getLocalizedRoleName(SpyModeRoleType.SPY_ROLE_CIVILIAN))]);
            }
            else
            {
               this.myIcon.gotoAndStop(3);
               this.myText.text = LocalizeUtil.param(DictHud.SPY_ROUND_WINNER,[LocalizeUtil.localize(SpyUtil.getLocalizedRoleName(SpyModeRoleType.SPY_ROLE_CIVILIAN))]);
               this.myText.textColor = SpyUtil.getRoleColor(SpyModeRoleType.SPY_ROLE_CIVILIAN);
               if(timeout)
               {
                  this.myDesc.text = LocalizeUtil.localize(DictHud.SPY_ROUND_TIMEOUT);
               }
               else
               {
                  this.myDesc.text = LocalizeUtil.param(DictHud.SPY_ALL_ENEMY_DOWN,[LocalizeUtil.localize(SpyUtil.getLocalizedRoleName(2))]);
               }
            }
            if(this.myDesc.length > 0)
            {
               firstCharRect = this.myDesc.getCharBoundaries(0);
               lastCharRect = this.myDesc.getCharBoundaries(this.myDesc.text.length - 1);
               textWidth = this.myDesc.textWidth;
               this.myDescBG.width = textWidth + DESC_X_MARGIN * 2;
               this.myDescBG.x = this.myDesc.x + (this.myDesc.width - this.myDescBG.width) / 2;
            }
         }
         else
         {
            this.myDesc.visible = false;
            this.myDescBG.visible = false;
            this.myIcon.gotoAndStop(3 + round);
            this.myText.text = LocalizeUtil.localize(DictMatchResults.MATCH_WON);
         }
      }
   }
}

