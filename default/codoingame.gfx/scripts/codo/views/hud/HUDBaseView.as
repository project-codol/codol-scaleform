package codo.views.hud
{
   import codo.base.BaseView;
   import codo.common.CFunctionCommonContainer;
   import codo.constants.BCInGameEvent;
   import codo.constants.DataInGameID;
   import codo.constants.GameInfo;
   import codo.event.ParaEvent;
   import codo.utils.ScaleformUtil;
   import codo.views.hud.HUDViewConfigs.HUDViewBaseConfig;
   import flash.display.DisplayObject;
   import flash.errors.IllegalOperationError;
   import flash.filters.BlurFilter;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   
   public class HUDBaseView extends BaseView
   {
      
      public function HUDBaseView()
      {
         super();
      }
      
      override protected function showView() : void
      {
         super.showView();
         if(!ScaleformUtil.isScaleform)
         {
            GameInfo.setStageSize(1280,960);
         }
         this.addChildComponents();
         listen(BCInGameEvent.EVT_BLUR,this.onBlurAllUI);
      }
      
      override protected function hideView() : void
      {
         super.hideView();
         unlisten(BCInGameEvent.EVT_BLUR,this.onBlurAllUI);
      }
      
      protected function get viewConfig() : IHUDViewConfig
      {
         throw new IllegalOperationError("Must override viewConfig function");
      }
      
      protected function onBlurAllUI(cEvt:ParaEvent) : void
      {
         var child:DisplayObject = null;
         var filter:BlurFilter = null;
         var blur:Number = cEvt.myPara as Number;
         CFunctionCommonContainer.SetUIBlur(blur);
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i);
            if(blur != 0)
            {
               filter = new BlurFilter(4,4,1);
               child.filters = [filter];
            }
            else
            {
               child.filters = [];
            }
         }
      }
      
      private function addChildComponents() : void
      {
         var componentConfig:Object = null;
         var component:HUDComponent = null;
         var cls:Class = null;
         var zoom:Number = NaN;
         var position:Point = null;
         var property:String = null;
         var anchor:Point = null;
         var offset:Point = null;
         var gametype:String = this.getDP(DataInGameID.GAME_TYPE);
         if(!ScaleformUtil.isScaleform)
         {
            gametype = "zhunt";
         }
         var viewComponents:Array = this.viewConfig.getModeViewData(gametype);
         for(var i:int = 0; i < viewComponents.length; i++)
         {
            componentConfig = viewComponents[i];
            if(typeof componentConfig.cls == "string")
            {
               cls = getDefinitionByName(componentConfig.cls) as Class;
               if(Boolean(cls))
               {
                  component = new cls();
               }
            }
            else
            {
               component = new (componentConfig.cls as Class)();
            }
            if(Boolean(component))
            {
               zoom = 1;
               if(componentConfig.hasOwnProperty("zoom"))
               {
                  zoom = Number(componentConfig.zoom);
               }
               if(componentConfig.hasOwnProperty("width"))
               {
                  component.width = componentConfig.width * zoom;
               }
               if(componentConfig.hasOwnProperty("height"))
               {
                  component.height = componentConfig.height * zoom;
               }
               position = new Point(0,0);
               if(componentConfig.hasOwnProperty("anchor"))
               {
                  anchor = componentConfig.anchor;
                  if(componentConfig.hasOwnProperty("offset"))
                  {
                     offset = componentConfig.offset;
                  }
                  else
                  {
                     offset = new Point(0,0);
                  }
                  position = GameInfo.getStageCoordForAnchorAndOffset(anchor,offset);
               }
               component.x = position.x;
               component.y = position.y;
               if(componentConfig.hasOwnProperty("rotateX"))
               {
                  component.rotationX = componentConfig.rotateX;
               }
               if(componentConfig.hasOwnProperty("rotateY"))
               {
                  component.rotationY = componentConfig.rotateY;
               }
               if(componentConfig.hasOwnProperty("rotateZ"))
               {
                  component.rotationY = componentConfig.rotateZ;
               }
               for(property in componentConfig)
               {
                  if(!HUDViewBaseConfig.IsConfigurableProperty(property))
                  {
                     component[property] = componentConfig[property];
                  }
               }
               component = this.addChild(component) as HUDComponent;
               component.registerComponent();
            }
         }
      }
   }
}

