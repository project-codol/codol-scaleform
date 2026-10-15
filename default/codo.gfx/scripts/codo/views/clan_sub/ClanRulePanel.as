package codo.views.clan_sub
{
   import codo.base.BaseSubElement;
   import codo.component.CloseButton;
   import codo.component.ContentContainer;
   import codo.component.TextField;
   import codo.constants.DataID;
   import codo.localization.DictClan;
   import codo.objects.ClanGlobalConfig;
   import codo.style.ClanGuide;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.MathUtil;
   
   public class ClanRulePanel extends BaseSubElement
   {
      
      public var myTitle:TextField;
      
      public var myCloseBtn:CloseButton;
      
      public var myContentContainer:ContentContainer;
      
      public var myRule1:TextField;
      
      public var myRule2:TextField;
      
      public var myRule3:TextField;
      
      public var myRule4:TextField;
      
      public var myRule5:TextField;
      
      public var myRule6:TextField;
      
      public var myRule7:TextField;
      
      public var myRule8:TextField;
      
      public var myRule9:TextField;
      
      public var myRule10:TextField;
      
      public var myRule11:TextField;
      
      private var mGlobalConfig:ClanGlobalConfig;
      
      private var mRuleTFs:Array;
      
      public function ClanRulePanel()
      {
         var tf:TextField = null;
         super();
         this.myContentContainer.width = 860;
         this.myContentContainer.height = 512;
         this.mRuleTFs = [this.myRule1,this.myRule2,this.myRule3,this.myRule4,this.myRule5,this.myRule6,this.myRule7,this.myRule8,this.myRule9,this.myRule10,this.myRule11];
         for(var i:int = 0; i < this.mRuleTFs.length; i++)
         {
            tf = this.mRuleTFs[i];
            tf.textStyle = ClanGuide.styleClanRule;
            tf.width = 800;
            tf.height = 450;
            tf.text = "";
         }
         this.myCloseBtn.registerClickEvent(this.onCloseBtnClicked);
      }
      
      override public function active() : void
      {
         super.active();
         this.mGlobalConfig = getDP(DataID.CLAN_GLOBAL_CONFIG);
         var upgradeString:String = String(0) + " " + String(this.mGlobalConfig.levelUpgrade[1]) + " " + String(this.mGlobalConfig.levelUpgrade[2]) + " " + String(this.mGlobalConfig.levelUpgrade[3]) + " " + String(this.mGlobalConfig.levelUpgrade[4]);
         LocalizeUtil.paramColorized(this.myRule1.myTextClip,DictClan.CLAN_RULE1,[LocalizeUtil.localize(DictClan.CLAN_LEVEL_BRONZE),LocalizeUtil.localize(DictClan.CLAN_LEVEL_SILVER),LocalizeUtil.localize(DictClan.CLAN_LEVEL_GOLD),LocalizeUtil.localize(DictClan.CLAN_LEVEL_PLATINUM),LocalizeUtil.localize(DictClan.CLAN_LEVEL_DIAMOND),upgradeString],[ClanGuide.BRONZE_COLOR,ClanGuide.SILVER_COLOR,ClanGuide.GOLD_COLOR,ClanGuide.PLATINUM_COLOR,ClanGuide.DIAMOND_COLOR,GlobalGuide.WHITE]);
         LocalizeUtil.paramColorized(this.myRule2.myTextClip,DictClan.CLAN_RULE2,[],[]);
         LocalizeUtil.paramColorized(this.myRule3.myTextClip,DictClan.CLAN_RULE3,[MathUtil.percentValue(this.mGlobalConfig.xpBuffPerLevel[0]),MathUtil.percentValue(this.mGlobalConfig.xpBuffPerLevel[1]),MathUtil.percentValue(this.mGlobalConfig.xpBuffPerLevel[2]),MathUtil.percentValue(this.mGlobalConfig.xpBuffPerLevel[3]),MathUtil.percentValue(this.mGlobalConfig.xpBuffPerLevel[4])],[ClanGuide.BRONZE_COLOR,ClanGuide.SILVER_COLOR,ClanGuide.GOLD_COLOR,ClanGuide.PLATINUM_COLOR,ClanGuide.DIAMOND_COLOR]);
         LocalizeUtil.paramColorized(this.myRule4.myTextClip,DictClan.CLAN_RULE4,[MathUtil.percentValue(this.mGlobalConfig.xpMatePlayBuffPerLevel[0]),MathUtil.percentValue(this.mGlobalConfig.xpMatePlayBuffPerLevel[1]),MathUtil.percentValue(this.mGlobalConfig.xpMatePlayBuffPerLevel[2]),MathUtil.percentValue(this.mGlobalConfig.xpMatePlayBuffPerLevel[3]),MathUtil.percentValue(this.mGlobalConfig.xpMatePlayBuffPerLevel[4])],[ClanGuide.BRONZE_COLOR,ClanGuide.SILVER_COLOR,ClanGuide.GOLD_COLOR,ClanGuide.PLATINUM_COLOR,ClanGuide.DIAMOND_COLOR]);
         LocalizeUtil.paramColorized(this.myRule5.myTextClip,DictClan.CLAN_RULE5,[],[]);
         LocalizeUtil.paramColorized(this.myRule6.myTextClip,DictClan.CLAN_RULE6,[this.mGlobalConfig.ccpToCTPRate],[GlobalGuide.CODO_YELLOW]);
         LocalizeUtil.paramColorized(this.myRule7.myTextClip,DictClan.CLAN_RULE7,[],[]);
         LocalizeUtil.paramColorized(this.myRule8.myTextClip,DictClan.CLAN_RULE8,[this.mGlobalConfig.cpToCCPRate],[GlobalGuide.CODO_YELLOW]);
         LocalizeUtil.paramColorized(this.myRule9.myTextClip,DictClan.CLAN_RULE9,[this.mGlobalConfig.ccpPlayWithMember,this.mGlobalConfig.ccpPlayWithMemberCap],[GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE,GlobalGuide.CODO_YELLOW]);
         LocalizeUtil.paramColorized(this.myRule10.myTextClip,DictClan.CLAN_RULE10,[this.mGlobalConfig.ccpWargod,this.mGlobalConfig.ccpWargodCap],[GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE,GlobalGuide.CODO_YELLOW]);
         LocalizeUtil.paramColorized(this.myRule11.myTextClip,DictClan.CLAN_RULE11,[this.mGlobalConfig.ccpChallenge,this.mGlobalConfig.ccpChallengeCap],[GlobalGuide.CODO_COLOR_HIGHLIGHT_ORANGE,GlobalGuide.CODO_YELLOW]);
      }
      
      private function onCloseBtnClicked() : void
      {
         deactive();
      }
   }
}

