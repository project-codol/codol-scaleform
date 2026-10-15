package codo.utils
{
   import codo.interfaces.ISoundUtil;
   
   public class FakeSoundUtil implements ISoundUtil
   {
      
      public function FakeSoundUtil()
      {
         super();
      }
      
      public function playMusic(cMusicName:String, cAmbName:String) : void
      {
      }
      
      public function stopMusic() : void
      {
      }
      
      public function playSound(cSoundName:String) : void
      {
      }
      
      public function stopSound() : void
      {
      }
      
      public function playSoundByFullName(cFullName:String, cFlag:uint, cMatchType:uint = 0) : void
      {
      }
   }
}

