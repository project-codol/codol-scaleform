package fsg.shared
{
   import fsg.widgets.fsgComboxBoxItemImage;
   
   public class ComboBoxWithImage extends ComboBox
   {
      
      private var mImageURL:String;
      
      public function ComboBoxWithImage()
      {
         m_itemHeight = 55;
         super();
      }
      
      override public function set dataProvider(value:Object) : void
      {
         var item:ComboBoxImageItem = null;
         var ob:Object = null;
         var showThisValue:Boolean = false;
         m_dataProvider = value;
         m_dataIndexToItemIndex.splice(0,m_dataIndexToItemIndex.length);
         var array:Array = m_dataProvider as Array;
         var len:int = int(array.length);
         var isEnabled:Boolean = true;
         this.myDropDownMenu.clearList();
         for(var dataIndex:int = 0; dataIndex < len; dataIndex++)
         {
            ob = m_dataProvider[dataIndex];
            m_dataIndexToItemIndex[dataIndex] = -1;
            showThisValue = true;
            if(ob.isHiddenValue != null)
            {
               showThisValue = !ob.isHiddenValue;
            }
            if(showThisValue)
            {
               isEnabled = ob.enabled != undefined ? Boolean(ob.enabled) : true;
               item = new fsgComboxBoxItemImage();
               item.label = ob.label || ob.name || ob.id;
               item.enabled = isEnabled;
               item.image = ob.imageURL;
               this.addItemToDropDown(item,dataIndex);
            }
         }
      }
      
      override public function setSelectedItemFromMClip(item:ComboBoxItem) : void
      {
         var itemWithImage:ComboBoxImageItem = item as ComboBoxImageItem;
         var selectedImg:ComboBoxImageItem = mySelectedItem as ComboBoxImageItem;
         selectedImg.label = itemWithImage.label;
         selectedImg.image = itemWithImage.imageURL;
      }
   }
}

