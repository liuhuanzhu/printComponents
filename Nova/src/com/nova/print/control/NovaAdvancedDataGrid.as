package  com.nova.print.control
{
	import com.nova.print.map.DataMap;
	import com.nova.print.map.FoldAdvancedGridMap;
	import com.nova.print.map.GroupMap;
	import com.nova.print.map.LayoutMap;
	import com.nova.print.map.PrintDataMap;
	import com.nova.print.map.PrintMap;
	import com.nova.print.util.SetupInfo;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Alert;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnGroup;
	import mx.controls.dataGridClasses.DataGridColumn;

	public class NovaAdvancedDataGrid
	{
		private static var novaAdvancedDataGrid:NovaAdvancedDataGrid=null;
		private var _dataGridHeight:int=0;//计算表格的实际高度
		public var colHeight:int=25;
		public static function getInstance():NovaAdvancedDataGrid
		{
			if(novaAdvancedDataGrid==null)
			{
				novaAdvancedDataGrid=new NovaAdvancedDataGrid();
			}
			return novaAdvancedDataGrid;
		}
		public function creatAdvancedDataGrid(advancedGrid:AdvancedDataGrid):void
		{
			advancedGrid.dataProvider=null;
			DataMap.getSimple().clearTotalItem();
			var dataProvider:ArrayCollection=PrintDataMap.getSimple().getData(SetupInfo.getInstance().colCurrentPage-1);
			if(dataProvider.contains(DataMap.getSimple().totalItem))
			{
				dataProvider.removeItemAt(dataProvider.getItemIndex(DataMap.getSimple().totalItem));
			}
			var currentPage:int=SetupInfo.getInstance().rowCurrentPage-((SetupInfo.getInstance().colCurrentPage-1)*SetupInfo.getInstance().rowPages)-1;
			var paperHeight:int=SetupInfo.getInstance().paperHeightSize;
			var viewheight:int=paperHeight-SetupInfo.getInstance().printHeaderNum-SetupInfo.getInstance().printFooterNum-SetupInfo.getInstance().printBottom-SetupInfo.getInstance().printTop;
			var columnIndexArr:Array=FoldAdvancedGridMap.getSimple().getColumnArrByID(currentPage) as Array;
			var emptyRowNum:int=0;
			emptyRowNum=Math.max(SetupInfo.getInstance().printRowNumber-dataProvider.length,0);
			if(columnIndexArr.length==0)
			{
				advancedGrid.width=0;
				advancedGrid.height=0;
				return;
			}
			var gmArray:Array=gotoGetHeader(columnIndexArr);
			var array:Array=creatGroupColumn(gmArray);
			/**创建空的行*/
			for(var k:int=0;k<emptyRowNum;k++)
			{
				var obj:Object=new Object();
				obj.nova="empty";
				dataProvider.addItem(obj);
			}
			if(DataMap.getSimple().totalItem!=null)// && SetupInfo.getInstance().rowCurrentPage==SetupInfo.getInstance().printTotalPages
			{
				dataProvider.addItem(DataMap.getSimple().totalItem);
			}
			var isWarp:Boolean=false;
			colHeight=SetupInfo.getInstance().colHeight;
			isWarp=Math.ceil(colHeight/25)<2?false:true;
			if(isWarp)
			{
				colHeight+=5;
			}
			advancedGrid.groupedColumns=array;
			advancedGrid.resizableColumns=true;
			advancedGrid.mouseChildren=true;
			advancedGrid.sortableColumns=false;
			advancedGrid.selectable=false;
			advancedGrid.sortExpertMode=true;
			advancedGrid.allowDragSelection=false;
			advancedGrid.draggableColumns=false;
			advancedGrid.setStyle("alternatingItemColors",[0xffffff]);
			advancedGrid.setStyle("horizontalGridLines",true);
			advancedGrid.setStyle("horizontalGridLineColor",0xDEE2E3);
			advancedGrid.setStyle("verticalGridLineColor",0xDEE2E3);
			advancedGrid.setStyle("headerStyleName","header");
			advancedGrid.setStyle("chromeColor",0xffffff);
			advancedGrid.setStyle("fontFamily","SONG");
			advancedGrid.setStyle("verticalAlign","middle");
			advancedGrid.setStyle("fontSize",10);
			advancedGrid.setStyle("kerning",true);
			advancedGrid.setStyle("leading",3);
			advancedGrid.verticalScrollPolicy="off";
			advancedGrid.rowHeight=colHeight;
			advancedGrid.wordWrap=isWarp;
			advancedGrid.dataProvider=dataProvider;
			//总共显示的行数为  每页显示多少行+补空行数目
			var length:int=dataProvider.length;
			length=Math.max(0,length);
			advancedGrid.rowCount=length+1+LayoutMap.getSimple().gridType;
			_dataGridHeight=colHeight*length+advancedGrid.headerHeight*(LayoutMap.getSimple().gridType+1)+10;
		}
/**
 * 解析表格数据集合  根据坐标取得header  然后进行配对分组
 * */
		private function gotoGetHeader(columnIndexArr:Array):Array
		{
			var array:Array=[];
			array.push(new GroupMap());
			trace("columnIndexArr:  "+columnIndexArr);
			trace("FoldAdvancedGridMap.getSimple().columnArray:  "+FoldAdvancedGridMap.getSimple().columnArray);
			for(var i:int=0;i<columnIndexArr.length;i++)
			{
				var columns:Array=FoldAdvancedGridMap.getSimple().columnArray[columnIndexArr[i]];
				trace("columns: "+columns);
				var parentHeader:String=columns[0];
				var sonHeader:String=columns[1];
				var unique:String=columns[6];
				var group:String=columns[5];
				if(GroupMap(array[array.length-1]).unique==unique)
				{
					GroupMap(array[array.length-1]).insertSonHeader(columns);
				}
				else
				{
					var gm:GroupMap=new GroupMap();
					gm.insertIsGroup(group);
					gm.insertParentHeader(parentHeader);
					gm.unique=unique;
					gm.insertSonHeader(columns);
					array.push(gm);
				}
			}
			array.shift();
			return array;
		}
/**
 * 根据配对分组声场的GroupMap数组集合  进行创建表格的子对象数组
 * */
		private function creatGroupColumn(array:Array):Array
		{
			var gridArray:Array=[];
			for(var i:int=0;i<array.length;i++)
			{
				var gm:GroupMap=array[i] as GroupMap;
				if(gm.isGroup)
				{
					gridArray.push(setAdvancedDataGridColumnGroup(gm));
				}
				else
				{
					gridArray.push(setAdvancedDataGridColumn(gm));
				}
			}
			return gridArray;
		}
		private function setAdvancedDataGridColumn(gm:GroupMap):AdvancedDataGridColumn
		{
			var column:AdvancedDataGridColumn=new AdvancedDataGridColumn();
			column.headerText=gm.sonHeaderArray[0];
			column.dataField=gm.sonFieldArray[0];
			var defaultWidth:int=PrintMap.getSimple().getRecordGridWidth(column.dataField);
			var defaultAlign:String=gm.sonAlginArray[0];
			if(defaultWidth!=0)
			{
				column.width=defaultWidth;
			}
			if(defaultAlign.length>0)
			{
				column.setStyle("textAlign",gm.sonAlginArray[0]);
			}
			return column;
		}
		private function setAdvancedDataGridColumnGroup(gm:GroupMap):AdvancedDataGridColumnGroup
		{
			var columnGroup:AdvancedDataGridColumnGroup=new AdvancedDataGridColumnGroup();
			columnGroup.headerText=gm.parentHeader;
			var array:Array=[];
			for(var i:int=0;i<gm.sonHeaderArray.length;i++)
			{
				var column:AdvancedDataGridColumn=new AdvancedDataGridColumn();
				column.headerText=gm.sonHeaderArray[i];
				column.dataField=gm.sonFieldArray[i];
				var defaultWidth:int=PrintMap.getSimple().getRecordGridWidth(column.dataField);
				var defaultAlign:String=gm.sonAlginArray[i];
				if(defaultWidth!=0)
				{
					column.width=defaultWidth;
				}
				if(defaultAlign.length>0)
				{
					column.setStyle("textAlign",gm.sonAlginArray[i]);
				}
				array.push(column);
			}
			columnGroup.children=array;
			return columnGroup;
		}

		public function get dataGridHeight():int
		{
			return _dataGridHeight;
		}

		public function set dataGridHeight(value:int):void
		{
			_dataGridHeight = value;
		}

	}
}