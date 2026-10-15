package fsg.util
{
   import codo.utils.Logger;
   import codo.utils.SoundUtil;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public class FsgAudioUtil
   {
      
      private static var instance:FsgAudioUtil;
      
      private var m_audioMap:Dictionary;
      
      public function FsgAudioUtil()
      {
         super();
         this.m_audioMap = new Dictionary();
      }
      
      public static function getInstance() : FsgAudioUtil
      {
         if(FsgAudioUtil.instance == null)
         {
            FsgAudioUtil.instance = new FsgAudioUtil();
         }
         return FsgAudioUtil.instance;
      }
      
      public function registerAudioEvent(cBaseControl:DisplayObject, cEvtName:String, cSoundName:String) : void
      {
         var eventMap:Dictionary = Boolean(this.m_audioMap[cBaseControl]) ? this.m_audioMap[cBaseControl] : new Dictionary();
         eventMap[cEvtName] = cSoundName;
         this.m_audioMap[cBaseControl] = eventMap;
         cBaseControl.addEventListener(cEvtName,this.audioListener,false,0,true);
      }
      
      public function registerCallbackAudioEvent(cBaseControl:DisplayObject, cEvtName:String, cCallbackFn:Function) : void
      {
         var eventMap:Dictionary = Boolean(this.m_audioMap[cBaseControl]) ? this.m_audioMap[cBaseControl] : new Dictionary();
         eventMap[cEvtName] = cCallbackFn;
         this.m_audioMap[cBaseControl] = eventMap;
         cBaseControl.addEventListener(cEvtName,this.audioListener,false,0,true);
      }
      
      public function unregisterAudioEvent(cBaseControl:DisplayObject, cEvtName:String, cSoundName:String) : void
      {
         cBaseControl.removeEventListener(cEvtName,this.audioListener);
         var eventMap:Dictionary = this.m_audioMap[cBaseControl];
         if(eventMap != null)
         {
            delete this.m_audioMap[cBaseControl][cEvtName];
            if(!eventMap.length)
            {
               delete this.m_audioMap[cBaseControl];
            }
         }
      }
      
      public function removeAudio(cBaseControl:DisplayObject) : void
      {
         var key:* = undefined;
         var value:String = null;
         var eventMap:Dictionary = this.m_audioMap[cBaseControl];
         for(key in eventMap)
         {
            value = eventMap[key];
            cBaseControl.removeEventListener(key,this.audioListener);
         }
         delete this.m_audioMap[cBaseControl];
      }
      
      public function playSound(cSoundName:String) : void
      {
         SoundUtil.getInstance().playSound(cSoundName);
      }
      
      public function stopSound() : void
      {
         SoundUtil.getInstance().stopSound();
      }
      
      protected function audioListener(cEvt:Event) : void
      {
         var eventMap:Dictionary = null;
         var eventObject:Object = null;
         var key:Object = cEvt.target;
         while(!eventObject && Boolean(key))
         {
            eventMap = this.m_audioMap[key];
            if(eventMap != null)
            {
               eventObject = eventMap[cEvt.type];
            }
            key = key.parent;
            if(key == null)
            {
               eventMap = this.m_audioMap[cEvt.target.stage];
               if(eventMap != null)
               {
                  eventObject = eventMap[cEvt.type];
               }
               break;
            }
         }
         var sndName:String = null;
         if(eventObject is String)
         {
            sndName = eventObject as String;
         }
         else
         {
            if(!(eventObject is Function))
            {
               Logger.print("FsgAudioUtil::audioListener \'" + cEvt.type + "\' tried to trigger an unregistered sound, object \'" + Logger.getObjUri(cEvt.target) + "\'");
               return;
            }
            sndName = (eventObject as Function)(cEvt) as String;
            if(sndName == "")
            {
               return;
            }
         }
         this.playSound(sndName);
      }
   }
}

