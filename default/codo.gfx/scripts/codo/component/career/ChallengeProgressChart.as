package codo.component.career
{
   import codo.component.diagram.CircleDiagram;
   import codo.style.GlobalGuide;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class ChallengeProgressChart extends CircleDiagram
   {
      
      public var myLabel:TextField;
      
      public var myMiddleColorBar:Sprite;
      
      public var myIcon:MovieClip;
      
      private var mChallengeColor:int = 16777215;
      
      public function ChallengeProgressChart()
      {
         super();
         var center:Point = new Point(119,119);
         setParams(119,101,center);
         setFillColor(this.mChallengeColor);
         setUseSecondaryFill(true);
      }
      
      public function set label(l:String) : void
      {
         this.myLabel.text = l;
      }
      
      public function set isPvp(val:Boolean) : void
      {
         this.mChallengeColor = val ? int(GlobalGuide.PVP_CHALLENGE_COLOR) : int(GlobalGuide.PVE_CHALLENGE_COLOR);
         var colorTf:ColorTransform = new ColorTransform();
         colorTf.color = this.mChallengeColor;
         this.myMiddleColorBar.transform.colorTransform = colorTf;
         this.myIcon.gotoAndStop(val ? 3 : 2);
         setFillColor(this.mChallengeColor);
      }
   }
}

