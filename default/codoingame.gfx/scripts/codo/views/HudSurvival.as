package codo.views
{
   import codo.base.BaseView;
   import codo.common.CFunctionInGameContainer;
   import codo.component.TextField;
   import codo.component.diagram.CircleDiagram;
   import codo.style.GlobalGuide;
   import codo.utils.LocalizeUtil;
   import codo.utils.ShoutcastUtil;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class HudSurvival extends BaseView
   {
      
      private static var CIRCLE_COLOR:uint = 2539662;
      
      public var myCenterContainer:MovieClip;
      
      public var myCircleDiagram:CircleDiagram;
      
      public var myCircleLabel:TextField;
      
      public function HudSurvival()
      {
         super();
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.myCircleDiagram = this.myCenterContainer["myCircleDiagram"];
         this.myCircleDiagram.setParams(38,32,new Point(76,76));
         this.myCircleDiagram.setFillColor(CIRCLE_COLOR);
         this.myCircleLabel = this.myCenterContainer["myCircleLabel"];
         this.myCircleLabel.font = GlobalGuide.FONT_FACE_BOLD;
         this.myCircleLabel.fontColor = CIRCLE_COLOR;
         this.myCircleLabel.text = LocalizeUtil.localize("@UI_HUD_SURVIVAL_CASH_MULTIPLIER");
         CFunctionInGameContainer.AS_RegisterHUDView(CFunctionInGameContainer.HVT_Survival,this);
         ShoutcastUtil.getInstance().registerView(this);
      }
   }
}

