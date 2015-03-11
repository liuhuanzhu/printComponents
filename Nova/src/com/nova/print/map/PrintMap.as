/**
 * 此类执行所有的打印界面的操作
 * */

package com.nova.print.map
{
	import com.nova.print.doc.PrintDoc;
	import com.nova.print.util.SetupInfo;
	
	import flash.display.Sprite;
	import flash.printing.PrintJob;
	import flash.printing.PrintJobOptions;
	import flash.printing.PrintJobOrientation;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.printing.FlexPrintJob;
	import mx.printing.FlexPrintJobScaleType;
	
	import spark.layouts.supportClasses.LayoutBase;

	public class PrintMap
	{
		private var _localXY:Array=null;
		private static var _simple:PrintMap=null;
		private var _recordDataFieldArray:Array=null;
		private var _recordSpacing:Array=null;
		private var _exportLayoutXml:XML=null;
		public function PrintMap()
		{
			_recordDataFieldArray=[["测试",0]];
			_recordSpacing=[];
		}
		public static function getSimple():PrintMap
		{
			if(_simple==null)
			{
				_simple=new PrintMap();
			}
			return _simple;
		}
/**
 * 初始化的时候存储表格列的宽度
 * */
		public function creatRecordDataFieldArray(dataField:String,width:String):void
		{
			_recordDataFieldArray.push([dataField,width]);
		}
/**
 * 表格发生列宽的改变时   此方法针对DataGrid
 * 查找_recordDataFieldArray里面的值进行对比  存在即更新  否则即添加
 * _recordDataFieldArray[0] 为dataFiled
 * _recordDataFieldArray[1] 为列的宽度
 * */
		public function updateRecordDataFieldArray(columns:Array):void
		{
			trace("表格的列宽发生改变--------------------------------------------start");
			trace("表格的列宽发生改变前的长度为:  "+_recordDataFieldArray.length);
			for(var i:int=0;i<columns.length;i++)
			{
				var dataGridColumn:DataGridColumn=columns[i] as DataGridColumn;
				var dataField:String=dataGridColumn.dataField;
				var gridWidth:int=dataGridColumn.width;
				var index:int=indexRecordGrid(dataField);
				if(index==-1)
				{
					_recordDataFieldArray.push([dataField,gridWidth]);
				}
				else
				{
					_recordDataFieldArray[index]=[dataField,gridWidth];
				}
			}
			trace("表格的列宽发生改变表格长度为:  "+_recordDataFieldArray.length);
			trace("表格的列宽发生改变表格数组为:  "+_recordDataFieldArray);
			trace("表格的列宽发生改变--------------------------------------------end");
		}
/**
 * 表格发生列宽的改变时   此方法针对AdvanceDataGrid
 * 查找_recordDataFieldArray里面的值进行对比  存在即更新  否则即添加
 * _recordDataFieldArray[0] 为dataFiled
 * _recordDataFieldArray[1] 为列的宽度
 * */
		public function updateRecordAdvDataFieldArray(column:AdvancedDataGridColumn):void
		{
			trace("表格的列宽发生改变--------------------------------------------start");
			trace("发生改变的列为："+column.headerText+"|dataField: "+column.dataField+"|width: "+column.width);
			trace("表格的列宽发生改变前的长度为:  "+_recordDataFieldArray.length);
			var index:int=indexRecordGrid(column.dataField);
			if(index==-1)
			{
				_recordDataFieldArray.push([column.dataField,column.width]);
			}
			else
			{
				_recordDataFieldArray[index]=[column.dataField,column.width];
			}
			trace("表格的列宽发生改变表格长度为:  "+_recordDataFieldArray.length);
			trace("表格的列宽发生改变表格数组为:  "+_recordDataFieldArray);
			trace("表格的列宽发生改变--------------------------------------------end");
		}
/**
 * 检测_recordDataFieldArray里面是否存在列DataField
 * */
		private function indexRecordGrid(dataField:String):int
		{
			var index:int=-1;
			for(var i:int=0;i<_recordDataFieldArray.length;i++)
			{
				var fieldArray:Array=_recordDataFieldArray[i] as Array;
				var field:String=fieldArray[0];
				if(field==dataField)
				{
					index=i;
				}
			}
			return index;
		}
/**
 * 创建表格时 查找记录的宽度  有则返回宽度
 * 无则返回宽度为0
 * */
		public function getRecordGridWidth(_field:String):int
		{
			var gridWidth:int=0;
			for(var i:int=0;i<_recordDataFieldArray.length;i++)
			{
				var fieldArray:Array=_recordDataFieldArray[i] as Array;
				var field:String=fieldArray[0];
				if(field==_field)
				{
					gridWidth=fieldArray[1];
					return gridWidth;
				}
			}
			return gridWidth;
		}
/**
 * 导出打印属性
 * */
		public function exportSeting():void
		{
			
		}
/**
 * 导出界面属性
 * */	
		public function exportLayout():void
		{
			trace("导出界面属性---------------------------------------start");
			_exportLayoutXml=new XML(<Layouts></Layouts>);
			_exportLayoutXml.appendChild(LayoutMap.getSimple().topXml);
			_exportLayoutXml.appendChild(LayoutMap.getSimple().bottomXml);
			if(SetupInfo.getInstance().hasGrid)
			{
				_exportLayoutXml.appendChild(updataGridXmlWidth());
			}
			_exportLayoutXml.appendChild(LayoutMap.getSimple().declarationsXml);
			_exportLayoutXml.appendChild(LayoutMap.getSimple().headerXml.children());
			trace(_exportLayoutXml);
			trace("导出界面属性---------------------------------------end");
		}
		private function updataGridXmlWidth():XML
		{
			var gridXml:XML=null;
			gridXml=LayoutMap.getSimple().gridXml;
			for(var i:int=0;i<gridXml.children().length();i++)
			{
				var xx:XML=gridXml.children()[i] as XML;
				if(xx.children().length()>0)
				{
					for(var j:int=0;j<xx.children().length();j++)
					{
						var fieldx:String=xx.children()[j].@dataField;
						var gridWidthx:int=getRecordGridWidth(fieldx);
						if(gridWidthx!=0)
						{
							xx.children()[j].@width=gridWidthx;
						}
					}
				}
				else
				{
					var field:String=xx.@dataField;
					var gridWidth:int=getRecordGridWidth(field);
					if(gridWidth!=0)
					{
						xx.@width=gridWidth;
					}
				}
			}
			return gridXml;
		}
		public function saveLocalXY():void
		{
			_localXY=[];
			var paperWidth:int=SetupInfo.getInstance().getPaperArrays()[0];
			var paperHeight:int=SetupInfo.getInstance().getPaperArrays()[1];
			var cxWidth:int=paperWidth-SetupInfo.getInstance().printLeft-SetupInfo.getInstance().printRight;
			var cxHeight:int=paperHeight-SetupInfo.getInstance().printHeaderNum-SetupInfo.getInstance().printFooterNum-SetupInfo.getInstance().printBottom-SetupInfo.getInstance().printTop;
			var viewWidth:int=SetupInfo.getInstance().printPaperWidth;
			var viewHeight:int=SetupInfo.getInstance().printPaperHeight;
			var kx:int=Math.ceil(viewWidth/cxWidth);
			var gx:int=Math.ceil(viewHeight/cxHeight);
			SetupInfo.getInstance().printTotalPages=kx*gx;
			for(var i:int=0;i<gx;i++)
			{
				for(var j:int=0;j<kx;j++)
				{
					_localXY.push([cxWidth*j,cxHeight*i]);
				}
			}
		}
		public function getPrintRange():Array
		{
			var array:Array=SetupInfo.getInstance().printRange;
			trace("所有的列分页:"+SetupInfo.getInstance().rowPages);
			trace("所有的行分页: "+SetupInfo.getInstance().colPages);
			trace("array:  "+array[0]);
			if(array[0]==-2)
			{
				return printAll();
			}
			else if(array[0]==-1)
			{
				return printCurrentPage();
			}
			else if(array[0]==-3)
			{
				return printEven();
			}
			else if(array[0]==-4)
			{
				return printOdd();
			}
			else
			{
				return printPart();
			}
		}
/**
 * 打印奇数页
 * */
		private function printOdd():Array
		{
			var array:Array=[];
			trace("打印奇数页面---------------------------------------------------start");
			for(var i:int=0;i<SetupInfo.getInstance().colPages;i++)
			{
				for(var j:int=0;j<SetupInfo.getInstance().rowPages;j++)
				{
					if(j%2==1)
					{
						var doc:PrintDoc=new PrintDoc();
						doc.Creat(j,i);
						trace("打印的为奇数为: "+i+"           当前的列的分页下标: "+j);
						array.push(doc);
					}
				}
			}
			trace("打印奇数页面---------------------------------------------------end");
			return array;
		}
/**
 * 打印偶数页
 * */
		private function printEven():Array
		{
			var array:Array=[];
			trace("打印偶数页面---------------------------------------------------start");
			for(var i:int=0;i<SetupInfo.getInstance().colPages;i++)
			{
				for(var j:int=0;j<SetupInfo.getInstance().rowPages;j++)
				{
					if(j%2==0)
					{
						var doc:PrintDoc=new PrintDoc();
						doc.Creat(j,i);
						trace("打印的为奇数为: "+i+"           当前的列的分页下标: "+j);
						array.push(doc);
					}
				}
			}
			trace("打印偶数页面---------------------------------------------------end");
			return array;
		}
		private function printCurrentPage():Array
		{
			var array:Array=[];
			var doc:PrintDoc=new PrintDoc();
			doc.Creat(SetupInfo.getInstance().rowCurrentPage-1,SetupInfo.getInstance().colCurrentPage-1);
			trace("打印当前页面----------------------------------------start");
			trace("打印的列的当前页为: "+SetupInfo.getInstance().rowCurrentPage);
			trace("打印的数据的当前页为： "+SetupInfo.getInstance().colCurrentPage);
			trace("打印当前页面----------------------------------------end");
			array.push(doc);
			return array;
		}
		private function printPart():Array
		{
			var docArry:Array=[];
			var array:Array=SetupInfo.getInstance().printRange;
			if(array.length==1)
			{
				trace("打印单个页面----------------------------------------start");
				var doc:PrintDoc=new PrintDoc();
				var colCurrentPage:int=Math.ceil(array[0]/SetupInfo.getInstance().rowPages);
				doc.Creat(array[0]-1,colCurrentPage-1);
				trace("打印的页码为: "+array[0]);
				trace("打印的数据的当前页为： "+colCurrentPage);
				trace("打印单个页面----------------------------------------end");
				docArry.push(doc);
				return docArry;
			}
			else
			{
				docArry=printPartOther();
			}
			return docArry;
		}
		private function printPartOther():Array
		{
			var array:Array=SetupInfo.getInstance().printRange;
			var docArry:Array=[];
			var f:int=array[0];
			var e:int=array[1];
			trace("打印多个页面----------------------------------------start");
			for(var i:int=f;i<=e;i++)
			{
				var colCurrentPage:int=Math.ceil(i/SetupInfo.getInstance().rowPages);
				var doc:PrintDoc=new PrintDoc();
				doc.Creat(i-1,colCurrentPage-1);
				trace("打印的页码为: "+i);
				trace("打印的数据的当前页为： "+colCurrentPage);
				docArry.push(doc);
			}
			trace("打印单个页面----------------------------------------end");
			return docArry;
		}
		private function printAll():Array
		{
			var array:Array=new Array();
			if(SetupInfo.getInstance().rowToCol)
			{
				 return rowToCol();
			}
			else
			{
				return colToRow();
			}
		}
		/**
		 * 打印顺序  先列后行  总
		 *   */
		private function colToRow():Array
		{
			var array:Array=[];
			trace("打印所有页面---------------------------------------------------start");
			for(var i:int=0;i<SetupInfo.getInstance().rowPages;i++)
			{
				for(var j:int=0;j<SetupInfo.getInstance().colPages;j++)
				{
					var doc:PrintDoc=new PrintDoc();
					trace("打印的当前数据分页下标为: "+j+"           当前的列的分页下标: "+i);
					doc.Creat(i,j);
					array.push(doc);                                 
				}
			}
			trace("打印所有页面---------------------------------------------------end");
			return array;
		}
		/**
		 * 打印顺序  先行后列    总*/
		private function rowToCol():Array
		{
			var array:Array=[];
			trace("打印所有页面---------------------------------------------------start");
			for(var i:int=0;i<SetupInfo.getInstance().colPages;i++)
			{
				for(var j:int=0;j<SetupInfo.getInstance().rowPages;j++)
				{
					var doc:PrintDoc=new PrintDoc();
					doc.Creat(j,i);
					trace("打印的当前数据分页下标为: "+i+"           当前的列的分页下标: "+j);
					array.push(doc);
				}
			}
			trace("打印所有页面---------------------------------------------------end");
			return array;
		} 
		/**  存储计算后的界面坐标的XY的坐标*/
		public function get localXY():Array
		{
			return _localXY;
		}

		/**
		 * @private
		 */
		public function set localXY(value:Array):void
		{
			_localXY = value;
		}

		
/**
 * 记录存储表格的宽度   没有的添加  有的更新
 * */
		
		public function get recordDataFieldArray():Array
		{
			return _recordDataFieldArray;
		}
		
		public function set recordDataFieldArray(value:Array):void
		{
			_recordDataFieldArray = value;
		}
/**
 * 导出的界面Xml
 * */
		public function get exportLayoutXml():XML
		{
			return _exportLayoutXml;
		}

		public function set exportLayoutXml(value:XML):void
		{
			_exportLayoutXml = value;
		}
/*
 * 记录标题列中字符之间的距离
		*/
		public function get recordSpacing():Array
		{
			return _recordSpacing;
		}

		public function set recordSpacing(value:Array):void
		{
			_recordSpacing = value;
		}




	}
}