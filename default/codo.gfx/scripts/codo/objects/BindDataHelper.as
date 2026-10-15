package codo.objects
{
   import codo.interfaces.IDataManager;
   import codo.interfaces.IDisposable;
   
   public class BindDataHelper implements IDisposable
   {
      
      public static var DataManager:IDataManager;
      
      private var m_dataID:*;
      
      private var m_callback:Function;
      
      private var m_params:*;
      
      private var m_immediate:Boolean;
      
      private var m_fromController:Boolean;
      
      private var m_dataVersion:uint;
      
      private var m_isBound:Boolean;
      
      public function BindDataHelper(dataID:*, callback:Function, params:* = null, immediate:Boolean = true, fromViewDeprecated:Boolean = false, fromController:Boolean = false, initialDataVersion:uint = 0)
      {
         super();
         this.m_dataID = dataID;
         this.m_callback = callback;
         this.m_params = params;
         this.m_immediate = immediate;
         this.m_fromController = fromController;
         this.m_dataVersion = initialDataVersion;
         this.m_isBound = false;
      }
      
      public function dispose() : void
      {
         this.unbind();
         this.m_dataID = null;
         this.m_callback = null;
         this.m_params = null;
      }
      
      public function reset() : void
      {
         this.unbind();
         this.m_dataVersion = 0;
      }
      
      public function bind() : void
      {
         if(!this.m_isBound && DataManager != null)
         {
            this.m_isBound = true;
            DataManager.bind(this.m_dataID,this.m_callback,this.m_params,this.m_immediate,false,this.m_fromController,this.m_dataVersion);
         }
      }
      
      public function update() : void
      {
         if(!this.m_isBound)
         {
            this.bind();
            this.unbind();
         }
      }
      
      public function refresh() : void
      {
         var wasBound:Boolean = this.m_isBound;
         this.reset();
         if(wasBound)
         {
            this.bind();
         }
      }
      
      public function unbind() : void
      {
         if(this.m_isBound && DataManager != null)
         {
            this.m_isBound = false;
            this.m_dataVersion = DataManager.unbind(this.m_dataID,this.m_callback);
         }
      }
   }
}

