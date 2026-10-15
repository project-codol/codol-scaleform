package codo.views
{
   import codo.base.BaseView;
   import codo.component.ViewPanelBase;
   import codo.views.career_parts.CareerBattleExperienceProgressPanel;
   
   public class CareerBattleExperienceView extends BaseView
   {
      
      public var myProgressPanel:CareerBattleExperienceProgressPanel;
      
      private var mCurPanel:ViewPanelBase;
      
      public function CareerBattleExperienceView()
      {
         super();
         this.mCurPanel = this.myProgressPanel;
      }
      
      override protected function showView() : void
      {
         super.showView();
         this.mCurPanel.showPanel();
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         this.mCurPanel.hidePanel();
      }
   }
}

