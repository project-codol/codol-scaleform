package codo.views
{
   import codo.base.BaseView;
   import codo.component.Button;
   import codo.component.CloseButton;
   import codo.component.ContentContainer;
   import codo.component.TextField;
   import codo.constants.BCEvent;
   import codo.constants.DataID;
   import codo.constants.MsgBtnCount;
   import codo.localization.Dict;
   import codo.objects.QuestionObj;
   import codo.style.GlobalGuide;
   import components.fsgquestionnaire_part.*;
   import flash.display.MovieClip;
   import flash.text.TextFieldAutoSize;
   
   public class FsgQuestionaireView extends BaseView
   {
      
      private static const FRAME_WIDTH:int = 673;
      
      private static const FRAME_HEIGHT:int = 545;
      
      public var myUserFeedback:TextField;
      
      public var myDescriptionText:TextField;
      
      public var myQuestionNumber:TextField;
      
      public var myOptions:MovieClip;
      
      public var mySubmitBtn:Button;
      
      public var myCloseBtn:CloseButton;
      
      public var myBg:MovieClip;
      
      public var myQuitBtn:Button;
      
      public var myFrame:ContentContainer;
      
      private var m_QuestionaireData:Object;
      
      private var m_QuestionIndex:uint;
      
      private var m_OptionSlots:Array;
      
      private var m_Answers:Array;
      
      private var m_TextBox:FsgQuestionTextInput;
      
      private var m_DisableTickCheck:Boolean = false;
      
      public function FsgQuestionaireView()
      {
         super();
      }
      
      override protected function onInit() : void
      {
         this.myFrame.width = FRAME_WIDTH;
         this.myFrame.height = FRAME_HEIGHT;
         this.myQuitBtn.width = this.mySubmitBtn.width = 110;
         this.myQuitBtn.height = this.mySubmitBtn.height = 37;
         this.mySubmitBtn.registerClickEvent(this.nextQuestion);
         this.myCloseBtn.registerClickEvent(this.close);
         this.myQuitBtn.registerClickEvent(this.close);
         this.myQuitBtn.label = Dict.QUESTION_CANCEL;
         this.myQuestionNumber.font = GlobalGuide.FONT_FACE_NUMBERS;
         this.myQuestionNumber.fontSize = GlobalGuide.FONT_SIZE_MEDIUM;
         this.myQuestionNumber.fontColor = GlobalGuide.GRAY_80;
         this.myUserFeedback.font = GlobalGuide.FONT_FACE_BOLD;
         this.myUserFeedback.fontSize = GlobalGuide.FONT_SIZE_LARGE;
         this.myUserFeedback.width = FRAME_WIDTH - 80;
         this.myUserFeedback.height = 48;
         this.myDescriptionText.fontSize = GlobalGuide.FONT_SIZE_SMALL;
         this.myDescriptionText.wordWrap = true;
         this.myDescriptionText.multiline = true;
         this.myDescriptionText.width = 630;
         this.myDescriptionText.height = 36;
         this.myDescriptionText.autoSize = TextFieldAutoSize.LEFT;
         this.myUserFeedback.text = Dict.QUESTION_HEADER;
         this.m_OptionSlots = [];
         this.m_TextBox = new fsgQuestionTextInput();
         this.myOptions.addChild(this.m_TextBox);
         this.m_TextBox.visible = false;
      }
      
      override protected function enableData() : void
      {
         this.bind(DataID.QUESTION_DATA,this.bindQuestionData);
      }
      
      override protected function disableData() : void
      {
         this.unbind(DataID.QUESTION_DATA,this.bindQuestionData);
      }
      
      private function bindQuestionData(cResult:Object) : void
      {
         this.m_Answers = [];
         this.m_QuestionaireData = cResult.data;
         this.displayQuestion(0);
      }
      
      private function displayQuestion(question:uint) : void
      {
         var questionObj:QuestionObj = null;
         var i:uint = 0;
         var option:FsgQuestionOption = null;
         var textOption:FsgQuestionOption = null;
         this.m_QuestionIndex = question;
         if(this.m_QuestionaireData == null || question >= this.m_QuestionaireData.question.length)
         {
            broadcast(BCEvent.SUBMIT_QUESTIONNAIRE,{"answer":this.m_Answers});
            return;
         }
         this.myQuestionNumber.text = String(question + 1) + "/" + String(this.m_QuestionaireData.question.length);
         questionObj = new QuestionObj(this.m_QuestionaireData.question[question]);
         this.myDescriptionText.text = questionObj.content;
         this.m_DisableTickCheck = true;
         var curY:Number = 0;
         for(var index:uint = 0; index < this.m_OptionSlots.length; index++)
         {
            option = this.m_OptionSlots[index];
            option.visible = false;
         }
         for(i = 0; i < questionObj.options.length; i++)
         {
            if(this.m_OptionSlots.length < i + 1)
            {
               this.m_OptionSlots.push(new fsgQuestionOption());
               this.m_OptionSlots[i].setClickCallback(this.onTickBox,this.m_OptionSlots[i]);
            }
            textOption = this.m_OptionSlots[i];
            textOption.visible = true;
            textOption.x = 0;
            textOption.y = curY;
            this.myOptions.addChild(textOption);
            textOption.checked = false;
            textOption.label = questionObj.options[i];
            curY += textOption.height + 18;
         }
         this.m_TextBox.text = "";
         if(questionObj.messageType == QuestionObj.MESSAGETYPE_NONE)
         {
            this.m_TextBox.visible = false;
         }
         else
         {
            this.m_TextBox.visible = false;
            this.m_TextBox.x = 0;
            this.m_TextBox.y = curY;
            this.m_TextBox.state = questionObj.messageType == QuestionObj.MESSAGETYPE_FREE ? FsgQuestionTextInput.STATE_ACTIVE : FsgQuestionTextInput.STATE_INACTIVE;
         }
         if(question == this.m_QuestionaireData.question.length - 1)
         {
            this.mySubmitBtn.label = Dict.QUESTION_SUBMIT;
         }
         else
         {
            this.mySubmitBtn.label = Dict.QUESTION_NEXT;
         }
         if(questionObj.type == QuestionObj.TYPE_SINGLE)
         {
            this.m_OptionSlots[0].myCheckBox.checked = true;
         }
         this.m_DisableTickCheck = false;
      }
      
      private function nextQuestion() : void
      {
         var option:FsgQuestionOption = null;
         var hasEmptyAnswer:Boolean = true;
         var ans:Object = {
            "answerIndex":this.m_QuestionIndex,
            "answer":[],
            "text":this.m_TextBox.text
         };
         for(var i:uint = 0; i < this.m_QuestionaireData.question[this.m_QuestionIndex].options.length; i++)
         {
            option = this.m_OptionSlots[i];
            ans.answer.push(option.checked);
            if(option.checked)
            {
               hasEmptyAnswer = false;
            }
         }
         if(hasEmptyAnswer)
         {
            this.showMsg(Dict.QUESTIONNAIRE_SELECT_ANSWER,MsgBtnCount.ONE);
         }
         else
         {
            this.m_Answers.push(ans);
            this.displayQuestion(this.m_QuestionIndex + 1);
         }
      }
      
      private function close() : void
      {
         broadcast(BCEvent.HIDE_QUESTIONNAIRE);
      }
      
      private function onTickBox(cOption:FsgQuestionOption) : void
      {
         var i:uint = 0;
         var option:FsgQuestionOption = null;
         if(this.m_DisableTickCheck)
         {
            return;
         }
         var questionObj:QuestionObj = new QuestionObj(this.m_QuestionaireData.question[this.m_QuestionIndex]);
         if(questionObj.type == QuestionObj.TYPE_SINGLE)
         {
            this.m_DisableTickCheck = true;
            for(i = 0; i < this.m_OptionSlots.length; i++)
            {
               option = this.m_OptionSlots[i];
               if(option == cOption)
               {
                  option.checked = true;
                  if(questionObj.messageType == QuestionObj.MESSAGETYPE_WITHLASTOPTION)
                  {
                     this.m_TextBox.state = i == questionObj.optionNum ? FsgQuestionTextInput.STATE_ACTIVE : FsgQuestionTextInput.STATE_INACTIVE;
                  }
               }
               else
               {
                  option.checked = false;
                  if(questionObj.messageType == QuestionObj.MESSAGETYPE_WITHLASTOPTION)
                  {
                     this.m_TextBox.state = FsgQuestionTextInput.STATE_ACTIVE;
                  }
               }
            }
            this.m_DisableTickCheck = false;
         }
      }
      
      private function onUntickBox(cOption:FsgQuestionOption) : void
      {
         if(this.m_DisableTickCheck)
         {
            return;
         }
         if(this.m_QuestionaireData.question[this.m_QuestionIndex].type == QuestionObj.TYPE_SINGLE)
         {
            this.m_DisableTickCheck = true;
            cOption.myCheckBox.checked = true;
            this.m_DisableTickCheck = false;
         }
      }
   }
}

