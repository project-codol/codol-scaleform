package codo.base
{
   import codo.interfaces.IStateMachine;
   import codo.utils.Logger;
   import flash.utils.Dictionary;
   
   public class StateMachineBase implements IStateMachine
   {
      
      private var _stateCallbacks:Dictionary = new Dictionary();
      
      private var _currentState:uint = 0;
      
      public function StateMachineBase()
      {
         super();
      }
      
      public static function logPrint(str:String) : void
      {
         Logger.print(str);
      }
      
      public static function printStack() : void
      {
         var e:Error = new Error();
         Logger.print(e.getStackTrace());
      }
      
      public function get state() : uint
      {
         return this._currentState;
      }
      
      public function set state(s:uint) : void
      {
         var cbFunc:Function = null;
         if(!this.isValidState(s))
         {
            Logger.print("StateMachineBase::set state, invalid task state: " + s);
            return;
         }
         if(this._currentState != s)
         {
            this._currentState = s;
            cbFunc = this._stateCallbacks[this._currentState].callBack;
            if(cbFunc != null)
            {
               cbFunc();
            }
         }
      }
      
      public function addState(cState:uint, cFunc:Function) : void
      {
         if(this.isValidState(cState))
         {
            Logger.print("StateMachineBase::addState state: " + cState + "has been already added!");
         }
         this._stateCallbacks[cState] = {"callBack":cFunc};
      }
      
      public function update(deltaTime:Number) : void
      {
      }
      
      private function isValidState(s:uint) : Boolean
      {
         return this._stateCallbacks.hasOwnProperty(s.toString());
      }
   }
}

