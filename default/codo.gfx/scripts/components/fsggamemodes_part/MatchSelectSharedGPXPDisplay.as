package components.fsggamemodes_part
{
   import codo.constants.ComponentCSS;
   import codo.localization.Dict;
   import codo.utils.ScaleformUtil;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class MatchSelectSharedGPXPDisplay extends Sprite
   {
      
      public var myInPartyLabelTF:TextField;
      
      public var myNoPartyLabelTF:TextField;
      
      public var myPartyGPValueTF:TextField;
      
      public var myPartyXPValueTF:TextField;
      
      public var myGPValueTF:TextField;
      
      public var myXPValueTF:TextField;
      
      public var mySepVertical:Sprite;
      
      public var myPartyGPIcon:Sprite;
      
      public var myPartyXPIcon:Sprite;
      
      public function MatchSelectSharedGPXPDisplay()
      {
         super();
         if(ScaleformUtil.isScaleform)
         {
            this.myInPartyLabelTF.text = Dict.USER_STATUS_IN_PARTY;
            this.myNoPartyLabelTF.text = Dict.USER_STATUS_NO_PARTY_ONLY;
         }
      }
      
      public function setAndDisplayXPandGPRate(xpRate:Number, gpRate:Number, xpScale:Number = 1, gpScale:Number = 1, firstWinXPScale:Number = 1, firstWinGPScale:Number = 1, partyFirstWinXPScale:Number = 1, partyFirstWinGPScale:Number = 1) : void
      {
         var xpPartyDisplayVal:Number = NaN;
         var gpPartyDisplayVal:Number = NaN;
         var xpDisplayVal:Number = xpRate * (xpScale + firstWinXPScale - 1);
         var gpDisplayVal:Number = gpRate * (gpScale + firstWinGPScale - 1);
         var bShowParty:Boolean = partyFirstWinXPScale > 1 || partyFirstWinGPScale > 1;
         this.myNoPartyLabelTF.text = Dict.USER_STATUS_NO_PARTY_ONLY;
         this.myXPValueTF.textColor = xpDisplayVal > 100 ? ComponentCSS.FSG_COLOR_BLUE : 16777215;
         this.myGPValueTF.textColor = gpDisplayVal > 100 ? ComponentCSS.FSG_COLOR_BLUE : 16777215;
         if(xpDisplayVal > 400)
         {
            xpDisplayVal = 400;
         }
         if(gpDisplayVal > 400)
         {
            gpDisplayVal = 400;
         }
         this.myXPValueTF.text = xpDisplayVal + "%";
         this.myGPValueTF.text = gpDisplayVal + "%";
         this.showHidePartyInfo(bShowParty);
         if(bShowParty)
         {
            xpPartyDisplayVal = xpRate * (xpScale + partyFirstWinXPScale - 1);
            gpPartyDisplayVal = gpRate * (gpScale + partyFirstWinGPScale - 1);
            this.myNoPartyLabelTF.text = Dict.USER_STATUS_NO_PARTY;
            this.myPartyXPValueTF.textColor = xpPartyDisplayVal > 100 ? ComponentCSS.FSG_COLOR_BLUE : 16777215;
            this.myPartyGPValueTF.textColor = gpPartyDisplayVal > 100 ? ComponentCSS.FSG_COLOR_BLUE : 16777215;
            if(xpPartyDisplayVal > 400)
            {
               xpPartyDisplayVal = 400;
            }
            if(gpPartyDisplayVal > 400)
            {
               gpPartyDisplayVal = 400;
            }
            this.myPartyXPValueTF.text = xpPartyDisplayVal + "%";
            this.myPartyGPValueTF.text = gpPartyDisplayVal + "%";
         }
         visible = true;
      }
      
      private function showHidePartyInfo(isShow:Boolean) : void
      {
         this.myInPartyLabelTF.visible = this.myPartyGPValueTF.visible = this.myPartyXPValueTF.visible = this.mySepVertical.visible = this.myPartyGPIcon.visible = this.myPartyXPIcon.visible = isShow;
      }
      
      public function resetDisplayData() : void
      {
         this.myPartyGPValueTF.text = this.myPartyXPValueTF.text = this.myGPValueTF.text = this.myXPValueTF.text = "";
      }
   }
}

