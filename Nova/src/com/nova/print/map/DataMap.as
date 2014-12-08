package com.nova.print.map
{
	import com.nova.print.util.SetupInfo;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.core.INavigatorContent;
	import mx.messaging.channels.StreamingAMFChannel;

	/**
	 * 此类存储所有传递过来的Data数据
	 * 所有的文本数据和表格数据
	 * */
	public class DataMap
	{
		private var _tfData:ArrayCollection=null;
		private var _gridData:ArrayCollection=null;
		private var _totalItem:Object=null;
		private var _dataXml:XML=null;
		private var _totalFieldArr:Array=null;
		private var _totalEllipsisArr:Array=null;
		private static var simple:DataMap=null;
		public static function getSimple():DataMap
		{
			if(simple==null)
			{
				simple=new DataMap();
			}
			return simple;
		}
/**
 * 此方法是接受js传递过来的数据接口
 * 表格和文本分别进行保存
 * */
		public function setData(value:XML):void
		{
			_dataXml=value;
			setTfData();
			setGridData();
		}
		private function indexContuine():void
		{
			var length:int=_dataXml.children().length();
			if(length<=1)
			{
				SetupInfo.getInstance().isContinue=false;
			}
			else
			{
				SetupInfo.getInstance().isContinue=true;
			}
		}
/**
 * 保存所有的非表格数据
 * */
		private function setTfData():void
		{
			_tfData=new ArrayCollection();
			for(var i:int=0;i<_dataXml.children().length();i++)
			{
				var item:XML=_dataXml.children()[i] as XML;
				if(item.localName()!="Grids")
				{
					var object:Object=new Object();
					object.id=item.localName();
					object.text=_dataXml.children()[i];
					_tfData.addItem(object);
				}
			}
		}
		private function setGridData():void
		{
			_gridData=new ArrayCollection();
			if(!SetupInfo.getInstance().hasGrid) return;
			var dataXml:XML=new XML(_dataXml.DataGrid.RowData);
			var colXml:XML=new XML(_dataXml.DataGrid.ColModel);
			var totalXml:XML=null;
			var totalLength:int=_dataXml.DataGrid.elements("TotalCol").length();
			if(totalLength!=0)
			{
				totalXml=new XML(_dataXml.DataGrid.TotalCol).children()[0];
			}
			var colArr:Array=[];
			for(var i:int=0;i<colXml.children().length();i++)
			{
				colArr.push(colXml.children()[i].@DataField);
			}
			for(var j:int=0;j<dataXml.children().length();j++)
			{
				var item:XML=dataXml.children()[j] as XML;
				var obj:Object=new Object();
				for(var c:int=0;c<colArr.length;c++)
				{
					var str:String=colArr[c];
					obj[colArr[c]]=item.@[str];
				}
				_gridData.addItem(obj);
			}
			if(totalXml!=null)
			{
				_totalItem=new Object();
				SetupInfo.getInstance().isTotalCol=1;
				_totalItem.nova="total";
				for each(var t:XML in totalXml.attributes())
				{
					var kid:String=t.name();
					_totalItem[kid]=t.toString();
				}
				_totalFieldArr=[];
				_totalFieldArr=String(_totalItem.fieldName).split(",");
				_totalEllipsisArr=[];
				_totalEllipsisArr=String(_totalItem.elliName).split(",");
				trace("_totalFieldArr:  "+_totalFieldArr);
				trace("_totalEllipsisArr:  "+_totalEllipsisArr);
			}
			trace("接受到的数据长度:  "+_gridData.length);
		}
		public function clearTotalItem():void
		{
			for(var i:int=_gridData.length-1;i>=0;i--)
			{
				var obj:Object=_gridData.getItemAt(i);
				if(obj.nova=="total" || obj.nova=="empty")
				{
					_gridData.removeItemAt(i);
				}
			}
			_gridData.refresh();
		}
		public function get tfData():ArrayCollection
		{
			return _tfData;
		}

		public function set tfData(value:ArrayCollection):void
		{
			_tfData = value;
		}

		public function get gridData():ArrayCollection
		{
			return _gridData;
		}

		public function set gridData(value:ArrayCollection):void
		{
			_gridData = value;
		}

		public function get dataXml():XML
		{
			return _dataXml;
		}

		public function set dataXml(value:XML):void
		{
			_dataXml = value;
		}
/**
 * 最后一行的合计行
 * */
		public function get totalItem():Object
		{
			return _totalItem;
		}

		public function set totalItem(value:Object):void
		{
			_totalItem = value;
		}
/**
 * 在合计行数据中添加需要合计行中相应列的字段
 * 检测到后 画线高度减小20个像素。
 * */
		public function get totalFieldArr():Array
		{
			return _totalFieldArr;
		}

		public function set totalFieldArr(value:Array):void
		{
			_totalFieldArr = value;
		}
/**
 * 打印页码多时是否存在省略号的数组
 * */
		public function get totalEllipsisArr():Array
		{
			return _totalEllipsisArr;
		}

		public function set totalEllipsisArr(value:Array):void
		{
			_totalEllipsisArr = value;
		}


	}
}