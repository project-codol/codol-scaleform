package codo.interfaces
{
   import codo.objects.ToolTipObject;
   import shaui.component.core.UIComponent;
   
   public interface ITipView
   {
      
      function displayTip(param1:UIComponent) : void;
      
      function displayGlobalToolTip(param1:ToolTipObject) : void;
      
      function hideGlobalToolTip() : void;
      
      function removeTip(param1:UIComponent) : void;
   }
}

