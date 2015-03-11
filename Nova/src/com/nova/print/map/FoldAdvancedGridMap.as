package com.nova.print.map
{
	import com.nova.print.util.SetupInfo;
	
	import mx.controls.Alert;

	public class FoldAdvancedGridMap
	{
		private static var _simple:FoldAdvancedGridMap=null;
		private var _columnArray:Array=[];
		private var _columnIndexArray:Array=[];
		private var _allColumnNum:int=0;
		public static function getSimple():FoldAdvancedGridMap
		{
			if(_simple==null)
			{
				_simple=new FoldAdvancedGridMap();
			}
			return _simple;
		}
/**
 * 初始化表格的列 
 * 表格的数组依次为 父亲的列标题 -自己的标题-自己的Field-自己的对齐方式-自己的宽度-是否有父亲  0表示没有 1表示有-unique 顶级列的唯一标识
 * */
		private function PagesByFixInit():void
		{
			_columnArray=[];
			var groupXml:XML=LayoutMap.getSimple().gridXml as XML;
			_allColumnNum=0;
			for(var i:int=0;i<groupXml.children().length();i++)
			{
				
				var xx:XML=groupXml.children()[i] as XML;
				var unique:String=xx.@unique;
				if(xx.localName()=="column" &&　xx.@visible!="false")
				{
					_columnArray.push([xx.@headerText,xx.@headerText,xx.@dataField,xx.@textAlign,xx.@width,0,unique,xx.@letterSpace]);
					_allColumnNum++;
				}
				else if(xx.localName()=="columns")
				{
					for(var j:int=0;j<xx.children().length();j++)
					{
						var xxx:XML=xx.children()[j] as XML;
						if(xxx.@visible!="false")
						{
							_allColumnNum++;
							_columnArray.push([xx.@headerText,xxx.@headerText,xxx.@dataField,xxx.@textAlign,xxx.@width,1,xxx.@unique,xxx.@letterSpace]);
						}
					}
				}
			}
			if(_allColumnNum<2)
			{
				SetupInfo.getInstance().gridHeadCheckBol=false;
			}
			else
			{
				SetupInfo.getInstance().gridHeadCheckBol=true;
			}
			if(_allColumnNum<=1)
			{
				SetupInfo.getInstance().gridIsEnable=false;
			}
			else
			{
				SetupInfo.getInstance().gridIsEnable=true;
			}
			trace("_columnArray:  "+_columnArray);
		}
/**
 * 固定方式折页
 * */
		public function getPagesByFix():void
		{
			PagesByFixInit();
			_columnIndexArray=[];
			/** 纸张宽度*/
			var paperWidth:int=SetupInfo.getInstance().getPaperArrays()[0];
			/** 默认固定列*/
			var fixRow:int=SetupInfo.getInstance().printFirstRow;
			/** 得到的变动的最列数目*/
			var length:int=_allColumnNum-fixRow;
			SetupInfo.getInstance().printFoldMax=length;
			SetupInfo.getInstance().printFixMax=_allColumnNum-1;
			trace(SetupInfo.getInstance().printEndRow+"--"+_allColumnNum);
			var page:int=Math.ceil(length/SetupInfo.getInstance().printEndRow);
			var fixArr:Array=[];
			for(var fix:int=0;fix<fixRow;fix++)
			{
				fixArr.push(fix);
			}
			for(var i:int=0;i<page-1;i++)
			{
				var array:Array=[];
				array=array.concat(fixArr);
				for(var j:int=0;j<SetupInfo.getInstance().printEndRow;j++)
				{
					array.push(i*SetupInfo.getInstance().printEndRow+fixRow+j);	
				}
				_columnIndexArray.push(array);
			}
			if(length>0)
			{
				var endArray:Array=[];
				endArray=endArray.concat(fixArr);
				for(var end:int=(page-1)*SetupInfo.getInstance().printEndRow+fixRow;end<=_allColumnNum-1;end++)
				{
					endArray.push(end);
				}
				_columnIndexArray.push(endArray);
			}
			else
			{
				_columnIndexArray.push(fixArr);
			}
			SetupInfo.getInstance().rowPages=page;
		}
/**
 * 变动方式折页
 * */
		public function getPageByChange():void
		{
			PagesByFixInit();
			_columnIndexArray=[];
			/** 纸张宽度*/
			var paperWidth:int=SetupInfo.getInstance().getPaperArrays()[0];
			/** 默认第一页列数*/
			var changeRow:int=SetupInfo.getInstance().printFirstRow;
			/** 后几页列数*/
			var endRow:int=SetupInfo.getInstance().printEndRow;
			var length:int=_allColumnNum-changeRow;
			SetupInfo.getInstance().printFoldMax=length;
			SetupInfo.getInstance().printFixMax=_allColumnNum-1;
			var page:int=Math.ceil(length/endRow);
			/** 第一页默认列的列*/
			var defaultArr:Array=[];
			for(var defaultRow:int=0;defaultRow<changeRow;defaultRow++)
			{
				defaultArr.push(defaultRow);
			}
			_columnIndexArray.push(defaultArr);;
			for(var i:int=0;i<page-1;i++)
			{
				var array:Array=[];
				for(var j:int=0;j<endRow;j++)
				{
					array.push(endRow*i+changeRow+j);
				}
				_columnIndexArray.push(array);
			}
			if(_allColumnNum>1)
			{
				var endArr:Array=[];
				var okArr:Array=_columnIndexArray[_columnIndexArray.length-1] as Array;
				var endNum:int=okArr[okArr.length-1]+1;
				for(var end:int=endNum;end<=_allColumnNum-1;end++)
				{
					endArr.push(end);
				}
				_columnIndexArray.push(endArr);
			}
			SetupInfo.getInstance().rowPages=page+1;
		}
/**
 * 根据当前页获取表格的数据   
 * 注意此处的当前页是减掉过
 * 即：当前为第一页时   传递的数据为0；
 * */
		public function getColumnArrByID(value:int):Array
		{
			var col:int=Math.ceil((value+1)/SetupInfo.getInstance().rowPages);
			trace(SetupInfo.getInstance().rowPages);
			var page:int=value-(col-1)*SetupInfo.getInstance().rowPages;
			trace("获取表格的相关数据-------------------------------------------------------start");
			trace("当前的页数:  "+value);
			trace("总的列数目:  "+_allColumnNum);
			trace("根据列的分页数:"+_columnIndexArray.length);
			trace("根据列所取得的下标为： "+page);
			trace("取得的表格的数据为： "+_columnIndexArray[page]);
			trace("获取表格的相关数据---------------------------------------------------------end");
			return _columnIndexArray[page] as Array;
		}
		/** 记录所有需要显示的表格的数据*/
		public function get columnArray():Array
		{
			return _columnArray;
		}

		/**
		 * @private
		 */
		public function set columnArray(value:Array):void
		{
			_columnArray = value;
		}

		public function get columnIndexArray():Array
		{
			return _columnIndexArray;
		}

		public function set columnIndexArray(value:Array):void
		{
			_columnIndexArray = value;
		}

		public function get allColumnNum():int
		{
			return _allColumnNum;
		}

		public function set allColumnNum(value:int):void
		{
			_allColumnNum = value;
		}



	}
	
}