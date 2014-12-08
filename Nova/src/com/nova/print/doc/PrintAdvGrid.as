package com.nova.print.doc
{
	import com.nova.print.control.NovaText;
	import com.nova.print.map.DataMap;
	import com.nova.print.map.FoldAdvancedGridMap;
	import com.nova.print.map.GroupMap;
	import com.nova.print.map.LayoutMap;
	import com.nova.print.map.PrintDataMap;
	import com.nova.print.map.PrintMap;
	import com.nova.print.util.SetupInfo;
	
	import flash.display.Sprite;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.IFactory;
	
	public class PrintAdvGrid extends PrintGrids
	{
		private var rowCurrentPage:int=0;
		private var colCurrentPage:int=0;
		private var dataLength:int=0;//行数目
		private var headLength:int=0;//列数目
		public var gridWidth:int=0;//表格总宽度  
		private var gridHeight:int=0;//表格高度
		private var gridHeadArray:Array=[];//表格的列的数字
		private var gridColumnWidth:int=0;
		private var borderWidth:int=0;
		private var dataArray:ArrayCollection;
		private var colHeight:int=50;//表格的每行高度
		private var dynamicGridWidthArray:Array=[];//动态计算并存储每一列的列宽
		private var dynamicLocalX:Array=[];//记录每一列的X坐标
		private var isTotalCol:int=0;//是否存在合计行  默认为0
		private var advGridHeadTxtArray:Array=[];//存储表格列标题的数组
		private var moreColumnArray:Array=[];//存储多列的数组
		private var simpleColumnWidth:Array=[];//按照顺序获取某一列的宽度
		public function PrintAdvGrid(_rowCurrentPage:int,_colCurrentPage:int)
		{
			if(!SetupInfo.getInstance().hasGrid) return;
			isTotalCol=SetupInfo.getInstance().isTotalCol;
			rowCurrentPage=_rowCurrentPage;
			colCurrentPage=_colCurrentPage;
			gridWidth=getWidth();
			dataArray=PrintDataMap.getSimple().getData(colCurrentPage);
			if(dataArray.contains(DataMap.getSimple().totalItem))
			{
				dataArray.removeItemAt(dataArray.getItemIndex(DataMap.getSimple().totalItem));
			}
			borderWidth=SetupInfo.getInstance().borderWidth;
			dataLength=SetupInfo.getInstance().printRowNumber+1;
			gridHeadArray=FoldAdvancedGridMap.getSimple().getColumnArrByID(rowCurrentPage);
			headLength=gridHeadArray.length;
			gridColumnWidth=Math.ceil(gridWidth/headLength);
			advGridHeadTxtArray=gotoGetHeader(gridHeadArray);
			if(isTotalCol==1)
			{
				gridHeight+=colHeight;
				dataArray.addItemAt(DataMap.getSimple().totalItem,dataArray.length);
			}
			dataLength+=isTotalCol;
			gridHeight=dataLength*colHeight;
			indexAdvGridColumnWidth();
			graphicsRow();
			printLine();
			printContent();
			/*trace("打印时创建表格的属性-----------------------------------------------------------start");
			trace("打印界面的实际宽度为: "+SetupInfo.getInstance().pageWidth);
			trace("表格的X坐标为: "+LayoutMap.getSimple().getGridX());
			trace("表格的界面宽度为: "+gridWidth);
			trace("表格的界面高度为: "+gridHeight);
			trace("表格的数据集合为: "+dataArray);
			trace("表格的数据集合长度为； "+dataArray.length);
			trace("表格有多少行(加上补空行): "+dataLength);
			trace("表格的列标题数据集合: "+gridHeadArray);
			trace("每一列的宽度为: "+gridColumnWidth);
			trace("动态计算每一列的列宽数组集合为:  "+dynamicGridWidthArray);
			trace("列的当前页: "+_rowCurrentPage+"   总的列的页数"+SetupInfo.getInstance().rowPages);
			trace("行的当前页: "+_colCurrentPage+"   总的列的页数"+SetupInfo.getInstance().colPages);
			trace("打印时创建表格的属性-----------------------------------------------------------end");*/
			
		}
		public function getWidth():int
		{
			var pageWidth:int=SetupInfo.getInstance().paperRealWidth-SetupInfo.getInstance().offsetX-40;
			return pageWidth;
		}
/**
 * 解析表格数据集合  根据坐标取得header  然后进行配对分组
 * */
		private function gotoGetHeader(gridHeadArray:Array):Array
		{
			var array:Array=[];
			array.push(new GroupMap());
			for(var i:int=0;i<gridHeadArray.length;i++)
			{
				var columns:Array=FoldAdvancedGridMap.getSimple().columnArray[gridHeadArray[i]];
				var parentHeader:String=columns[0];
				var sonHeader:String=columns[1];
				var unique:String=columns[6];
				var group:String=columns[5];
				var letterSpac:int=columns[7];
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
					gm.letterSpac=letterSpac;
					gm.insertSonHeader(columns);
					array.push(gm);
				}
			}
			array.shift();
			return array;
		}
		/**
		 * 该方法计算列宽
		 * 如果指定了宽度则为该宽度  否则进行计算
		 * */
		private function indexAdvGridColumnWidth():void
		{
			var noRecordArrayHead:Array=[];
			var recordWidth:int=0;
			var noRecordWidth:int=0;
			dynamicGridWidthArray=[];
			var noRecordAverWidth:int=0;
			for(var i:int=0;i<advGridHeadTxtArray.length;i++)
			{
				var gm:GroupMap=advGridHeadTxtArray[i] as GroupMap;
				var header:String="";
				var field:String="";
				var parent:String="";
				var gridRecordWidth:int=0;
				if(gm.isGroup)
				{
					for(var j:int=0;j<gm.sonHeaderArray.length;j++)
					{
						header=gm.sonHeaderArray[j];
						field=gm.sonFieldArray[j];
						parent=gm.parentHeader;
						gridRecordWidth=PrintMap.getSimple().getRecordGridWidth(field);
						if(gridRecordWidth==0)
						{
							noRecordArrayHead.push([parent,header,field,gridRecordWidth]);
						}
						else
						{
							recordWidth+=gridRecordWidth;
							dynamicGridWidthArray.push([parent,header,field,gridRecordWidth]);
						}
					}
				}
				else
				{
					header=gm.sonHeaderArray[0];
					field=gm.sonFieldArray[0];
					parent=gm.parentHeader;
					gridRecordWidth=PrintMap.getSimple().getRecordGridWidth(field);
					if(gridRecordWidth==0)
					{
						noRecordArrayHead.push([parent,header,field,gridRecordWidth]);
					}
					else
					{
						recordWidth+=gridRecordWidth;
						dynamicGridWidthArray.push([parent,header,field,gridRecordWidth]);
					}
				}
			}
			noRecordWidth=gridWidth-recordWidth;
			var noLength:int=noRecordArrayHead.length;
			if(noLength!=0)
			{
				noRecordAverWidth=Math.ceil(noRecordWidth/noLength);
				for(var r:int=0;r<noRecordArrayHead.length;r++)
				{	
					noRecordArrayHead[r][3]=noRecordAverWidth;
					dynamicGridWidthArray.push(noRecordArrayHead[r]);
				}
			}
			//trace("dynamicGridWidthArray: "+dynamicGridWidthArray);
		}
/**
 * 画横线
 * */
		private function graphicsRow():void
		{
			var rowLength:int=dataLength+1;
			this.graphics.clear();
			this.graphics.lineStyle(borderWidth);
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(gridWidth,0);
			this.graphics.moveTo(0,0);
			this.graphics.lineTo(0,rowLength*colHeight);
			this.graphics.lineStyle(1,0x000000,0.4);
			this.graphics.moveTo(0,colHeight*2);
			this.graphics.lineTo(gridWidth,colHeight*2);
			for(var i:int=3;i<=rowLength;i++)
			{
				if(i==rowLength)
				{
					this.graphics.lineStyle(borderWidth);
				}
				this.graphics.moveTo(0,i*colHeight);
				this.graphics.lineTo(gridWidth,i*colHeight);
			}
			this.graphics.lineStyle(borderWidth);
			this.graphics.moveTo(gridWidth,0);
			this.graphics.lineTo(gridWidth,rowLength*colHeight);
			this.graphics.endFill();
		}
/**
 * 获取列的所有属性
 * */
		private function indexGridHeader(parentHeader:String,selfHeader:String):Array
		{
			for(var i:int=0;i<dynamicGridWidthArray.length;i++)
			{
				var array:Array=dynamicGridWidthArray[i];
				if(array[0]==parentHeader && array[1]==selfHeader)
				{
					return array;
				}
			}
			return [0,0];
		}
/**
 * 画竖直的线条
 * */
		private function printLine():void
		{
			simpleColumnWidth=[0];
			for(var i:int=0;i<advGridHeadTxtArray.length;i++)
			{
				var gm:GroupMap=advGridHeadTxtArray[i] as GroupMap;
				if(gm.isGroup)
				{
					graphicsRowsByGroupMap(gm);
				}
				else
				{
					graphicsRowByGroupMap(gm,i);
				}
			}
			
		}
/**
 * 单个的列进行画线
 * */
		private function graphicsRowByGroupMap(gm:GroupMap,index:int):void
		{
			var rowLength:int=dataLength+1;
			var array:Array=indexGridHeader(gm.parentHeader,gm.sonHeaderArray[0]);
			var columnWidth:int=array[3];
			simpleColumnWidth.push(simpleColumnWidth[simpleColumnWidth.length-1]+columnWidth);
			var field:String=gm.sonFieldArray[0];
			var isMin:int=0;
			if(DataMap.getSimple().totalFieldArr!=null && DataMap.getSimple().totalFieldArr.indexOf(field)!=-1)
			{
				isMin=-20;
			}
			if(index<advGridHeadTxtArray.length-1)
			{
				this.graphics.lineStyle(1,0x000000,0.4);
				this.graphics.moveTo(simpleColumnWidth[simpleColumnWidth.length-1],0);
				this.graphics.lineTo(simpleColumnWidth[simpleColumnWidth.length-1],rowLength*colHeight+isMin);
				this.graphics.endFill();
			}
			var header:PrintDocTxt=new PrintDocTxt(gm.parentHeader,"center",columnWidth,gm.letterSpac);
			this.addChild(header);
			header.x=simpleColumnWidth[simpleColumnWidth.length-2];
			header.y=10;
			//trace("加载单个列: 列名："+gm.parentHeader+"|宽度|"+columnWidth+"|位置|"+header.x);
		}
/**
 * 多个的列进行画线
 * */
		private function graphicsRowsByGroupMap(gm:GroupMap):void
		{
			var rowLength:int=dataLength+1;
			var parentHeader:String=gm.parentHeader;
			var columnWidth:int=0;
			var length:int=gm.sonHeaderArray.length;
			this.graphics.lineStyle(1,0x000000,0.4);
			for(var i:int=0;i<gm.sonHeaderArray.length-1;i++)
			{
				var sonHeader:String=gm.sonHeaderArray[i];
				var sonField:String=gm.sonFieldArray[i];
				var array:Array=indexGridHeader(parentHeader,sonHeader);
				columnWidth=array[3];
				simpleColumnWidth.push(simpleColumnWidth[simpleColumnWidth.length-1]+columnWidth);
				var lineHeight:int=rowLength*colHeight;
				if(DataMap.getSimple().totalFieldArr.indexOf(sonField)!=-1)
				{
					lineHeight-=20;
				}
				this.graphics.moveTo(simpleColumnWidth[simpleColumnWidth.length-1],20);
				this.graphics.lineTo(simpleColumnWidth[simpleColumnWidth.length-1],lineHeight);
			//	trace("加载复杂列中的单个列: 列名："+sonHeader+"|宽度|"+columnWidth+"|位置|"+simpleColumnWidth[simpleColumnWidth.length-1]+"列的字段名: "+gm.sonFieldArray[i]);
				var header:PrintDocTxt=new PrintDocTxt(sonHeader,"center",columnWidth,gm.letterSpacArr[i]);
				this.addChild(header);
				header.x=simpleColumnWidth[simpleColumnWidth.length-2];
				header.y=22;
			}
			var endHeader:String=gm.sonHeaderArray[gm.sonHeaderArray.length-1];
			var endArray:Array=indexGridHeader(parentHeader,endHeader);
			columnWidth=endArray[3];
			simpleColumnWidth.push(simpleColumnWidth[simpleColumnWidth.length-1]+columnWidth);
			//复杂列的最后一个画线i
			if(simpleColumnWidth[simpleColumnWidth.length-1]<gridWidth)
			{
				this.graphics.moveTo(simpleColumnWidth[simpleColumnWidth.length-1],0);
				this.graphics.lineTo(simpleColumnWidth[simpleColumnWidth.length-1],rowLength*colHeight);
			}
			var firstLocal:int=simpleColumnWidth[simpleColumnWidth.length-length-1];
			var endLocal:int=simpleColumnWidth[simpleColumnWidth.length-1];
			endLocal=Math.min(gridWidth,endLocal);
			this.graphics.moveTo(firstLocal,20);
			this.graphics.lineTo(endLocal,20);
			this.graphics.endFill();
			//trace("加载复杂列中的单个列: 列名："+endHeader+"|宽度|"+columnWidth+"|位置|"+simpleColumnWidth[simpleColumnWidth.length-1]);
			var endHeaderDoc:PrintDocTxt=new PrintDocTxt(endHeader,"center",columnWidth,gm.letterSpacArr[gm.letterSpacArr.length-1]);
			this.addChild(endHeaderDoc);
			endHeaderDoc.x=simpleColumnWidth[simpleColumnWidth.length-2];
			endHeaderDoc.y=22;
			
			//trace("加载复杂列: 列名："+gm.parentHeader+"|宽度|"+columnWidth+"|位置|"+simpleColumnWidth[simpleColumnWidth.length-1]);
			var parentDoc:PrintDocTxt=new PrintDocTxt(gm.parentHeader,"center",endLocal-firstLocal,gm.letterSpac);
			this.addChild(parentDoc);
			parentDoc.x=firstLocal;
			parentDoc.y=1;
		}
		private function printContent():void
		{
			for(var i:int=0;i<headLength;i++)
			{
				var index:int=gridHeadArray[i];
				var headArray:Array=FoldAdvancedGridMap.getSimple().columnArray[index] as Array;
				var field:String=headArray[2];
				var parentHeader:String=headArray[0];
				var selfHeader:String=headArray[1];
				var align:String=headArray[3];
				var columnWidthArray:Array=indexGridHeader(parentHeader,selfHeader);
				if(align.length<=0)
				{
					align="left";
				}
				var localX:int=simpleColumnWidth[i];
				var gridW:int=columnWidthArray[3];
				for(var j:int=0;j<dataArray.length;j++)
				{
					var obj:Object=dataArray.getItemAt(j);
					var txt:String="";
					if(obj)
					{
						txt=obj[field];
					}
					if(obj.nova=="total" && colCurrentPage<SetupInfo.getInstance().colPages-1)
					{
						if(DataMap.getSimple().totalEllipsisArr.indexOf(field)!=-1)
						{
							txt="..."	
						}
					}
					var nt:PrintDocTxt=new PrintDocTxt(txt,align,gridW);
					nt.x=localX;
					nt.y=colHeight*(j+2)+3;
					if(obj.nova=="total" && DataMap.getSimple().totalFieldArr.indexOf(field)!=-1)
					{
						nt.creatBg(false);
						trace("文字:  "+txt+"|"+obj.nova+"|------------------------------------------------------------------------------false");
					}
					else
					{
						nt.creatBg();
						trace("文字:  "+txt+"|"+obj.nova+"|------------------true");
					}
					this.addChild(nt);
				}
			}
		}
		override public function getHeight():int
		{
			return this.gridHeight+15;
		}
	}
}