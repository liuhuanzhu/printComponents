package com.nova.print.util
{
	import com.nova.print.map.DataMap;
	import com.nova.print.map.FoldAdvancedGridMap;
	import com.nova.print.map.InitMap;
	import com.nova.print.map.LayoutMap;
	import com.nova.print.map.PrintDataMap;
	import com.nova.print.map.PrintMap;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.INavigatorContent;
	import mx.graphics.ImageSnapshot;
	
	import spark.components.BorderContainer;

	/**
	 * 打印设置信息实体类    此类记录打印组件的配置信息
	 * */
	[Bindable]
	public class SetupInfo
	{
		private var _infor:String="0";
		private var _printNumber:int=1;
		private var _printLayout:String="ver";
		private var _printTop:Number=0;
		private var _printBottom:Number=0;
		private var _printLeft:Number=20;
		private var _printRight:Number=20;
		private var _printPaperWidth:Number=400;
		private var _printPaperHeight:Number=800;
		private var _printIsTaoda:Boolean=false;
		private var _printHeader:String="";
		private var _printFooter:String="";
		private var _printHeaderNum:Number=0;
		private var _printFooterNum:Number=0;
		private var _printRowNumber:int=1;
		private var _isPrintHeader:Boolean=false;
		private var _isPrintLines:Boolean=false;
		private var _isPirntOrder:Boolean=true;
		private var _isEmptyRow:Boolean=false;
		private var _printRange:Array=[-2];
		private var _printFoldMax:int=0;
		private var _printFixMax:int=0;
		private var _printFirstRow:int=1;
		private var _printEndRow:int=5;
		private var _printTotalPages:int=1;
		
		private var _rowToCol:Boolean=true;
		
		private var _printFixChangeBol:Boolean=true;
		private var _printRow:Boolean=true;
		/**........其他保留*/
		private var _hasGrid:Boolean=false;
		private var _isTotalCol:int=0;
		
		private var _rows:int=0;
		private var _rowNumMax:int=0;
		private var _normMagn:int=20;
		
		private var _paperType:String="A4[595*842]";
		private var _paperSelectIndex:int=0;
		private static var setupInfo:SetupInfo=null;
		
		private var _pageWidth:int=0;
		private var _rowCurrentPage:int=1;
		private var _colCurrentPage:int=1;
		private var _rowPages:int=0;
		private var _colPages:int=0;
		private  var _gridHeight:int=0;
		
		
		private var _paperRealWidth:int=0;
		private var _paperRealHeight:int=0;
		
		
		private var _isContinue:Boolean=false;
		
		private var _exportPropertiesXml:XML=null;
		
		
		private var _paperArray:ArrayCollection=new ArrayCollection([{name:"A4[595*842]",pw:595,ph:842},
			{name:"A3[842*1191]",pw:842,ph:1191},
			{name:"A5[420*595]",pw:420,ph:595},
			{name:"B4[729*1032]",pw:729,ph:1032},
			{name:"B5[516*729]",pw:516,ph:729},
			{name:"凭证",pw:350,ph:650}
		]);
		
		
		private var _offsetX:int=0;
		
		private var _offsetY:int=0;
		
		private var _colHeight:int=25;
		
		private var _borderWidth:int=2;
		
		private var _gridHeadCheckBol:Boolean=true;
		private var _gridIsEnable:Boolean=true;
		
		private var _multiPrintType:int=0;
		
		private var _setXml:XML=null;
		
		public static function getInstance():SetupInfo
		{
			if(setupInfo==null)
			{
				setupInfo=new SetupInfo();
			}
			return setupInfo;
		}
		/**
		 * 导出打印设置
		 * */
		public function exportProperties():void
		{
			_exportPropertiesXml=<Properties></Properties>;
			_exportPropertiesXml.appendChild(<printRange>{_printRange.toString()}</printRange>);
			_exportPropertiesXml.appendChild(<paperType>{_paperType}</paperType>);
			_exportPropertiesXml.appendChild(<isEmptyRow>{_isEmptyRow}</isEmptyRow>);
			_exportPropertiesXml.appendChild(<printRowNumber>{_printRowNumber}</printRowNumber>);
			_exportPropertiesXml.appendChild(<paperSelectIndex>{_paperSelectIndex}</paperSelectIndex>);
			_exportPropertiesXml.appendChild(<printLayout>{_printLayout}</printLayout>);
			_exportPropertiesXml.appendChild(<printIsTaoda>{_printIsTaoda}</printIsTaoda>);
			_exportPropertiesXml.appendChild(<isPrintHeader>{_isPrintHeader}</isPrintHeader>);
			_exportPropertiesXml.appendChild(<isPrintLines>{_isPrintLines}</isPrintLines>);
			_exportPropertiesXml.appendChild(<printFixChangeBol>{_printFixChangeBol}</printFixChangeBol>);
			_exportPropertiesXml.appendChild(<printFirstRow>{_printFirstRow}</printFirstRow>);
			_exportPropertiesXml.appendChild(<printEndRow>{_printEndRow}</printEndRow>);
			_exportPropertiesXml.appendChild(<rowToCol>{_rowToCol}</rowToCol>);
			_exportPropertiesXml.appendChild(<printFooterNum>{_printFooterNum}</printFooterNum>);
			_exportPropertiesXml.appendChild(<printHeaderNum>{_printHeaderNum}</printHeaderNum>);
			_exportPropertiesXml.appendChild(<printFooter>{_printFooter}</printFooter>);
			_exportPropertiesXml.appendChild(<printHeader>{_printHeader}</printHeader>);
			_exportPropertiesXml.appendChild(<printLeft>{_printLeft}</printLeft>);
			_exportPropertiesXml.appendChild(<printRight>{_printRight}</printRight>);
			_exportPropertiesXml.appendChild(<printTop>{_printTop}</printTop>);
			_exportPropertiesXml.appendChild(<printBottom>{_printBottom}</printBottom>);
			_exportPropertiesXml.appendChild(<rowPages>{_rowPages}</rowPages>);
			_exportPropertiesXml.appendChild(<colPages>{_colPages}</colPages>);
			_exportPropertiesXml.appendChild(<printFoldMax>{_printFoldMax}</printFoldMax>);
			/*_exportPropertiesXml.appendChild(<borderWidth>{_borderWidth}</borderWidth>);
			_exportPropertiesXml.appendChild(<offsetX>{_offsetX}</offsetX>);
			_exportPropertiesXml.appendChild(<colHeight>{_colHeight}</colHeight>);
			_exportPropertiesXml.appendChild(<offsetY>{_offsetY}</offsetY>);*/
			trace("打印设置：  "+_exportPropertiesXml);
			
		}
		public function getProperties(xml:XML):void
		{
			_setXml=xml;
			this._paperType=xml.paperType;
			this._paperSelectIndex=int(xml.paperSelectIndex);
			
			this._printLayout=xml.printLayout;
			this._printIsTaoda=getBoolean(xml.printIsTaoda);
			this._isPrintHeader=getBoolean(xml.isPrintHeader);
			this._isPrintLines=getBoolean(xml.isPrintLines);
			this._printFixChangeBol=getBoolean(xml.printFixChangeBol);
			this._isEmptyRow=getBoolean(xml.isEmptyRow);
			this._printRowNumber=int(xml.printRowNumber);
			if(this._printRowNumber==0)
			{
				this._printRowNumber=DataMap.getSimple().gridData.length;
			}
			this._printFirstRow=int(xml.printFirstRow);
			this._printEndRow=int(xml.printEndRow);
			if(this._printEndRow==0)
			{
				this._printEndRow=LayoutMap.getSimple().allColumnIndex;
			}
			this._printFooterNum=int(xml.printFooterNum);
			this._printHeaderNum=int(xml.printHeaderNum);
			this._printFooter=xml.printFooter;
			this._printHeader=xml.printHeader;
			this._printLeft=int(xml.printLeft);
			this._printRight=int(xml.printRight);
			this._printBottom=int(xml.printBottom);
			this._printTop=int(xml.printTop);
			this._rowPages=int(xml.rowPages);
			this._printRange=String(xml.printRange).split(",");
			setCoverSet();
			if(SetupInfo.getInstance().hasGrid)
			{
				this._rows=DataMap.getSimple().gridData.length;
				if(_isEmptyRow)
				{
					_rowNumMax=1000;
				}
				else
				{
					_rowNumMax=_rows;
				}
				PrintDataMap.getSimple().initData();
				if(_printFixChangeBol)
				{
					FoldAdvancedGridMap.getSimple().getPagesByFix();
				}
				else
				{
					FoldAdvancedGridMap.getSimple().getPageByChange();
				}
				SetupInfo.getInstance().printTotalPages=SetupInfo.getInstance().colPages*SetupInfo.getInstance().rowPages;
			}
			else
			{
				SetupInfo.getInstance().rowPages=1;
			}
		
		}
/**
 * 取得在coverSet.xml中的值
 * */
		public function setCoverSet():void
		{
			if(PrintUtil.getSimple().coverSetXml==null)
			{
				PrintUtil.getSimple().coverSetXml=<sets>
													<colHeight>25</colHeight>
													<borderWidth>2</borderWidth>  
												  	<offsetX>80</offsetX>  
												  	<offsetY>30</offsetY> 
												</sets>;
			}
			if(_setXml==null){_setXml=<Properties></Properties>;}
			var xml:XML=new XML(PrintUtil.getSimple().coverSetXml);
			this._borderWidth=xml.borderWidth;
			this._colHeight=xml.colHeight;
			this._offsetX=xml.offsetX;
			this._offsetY=xml.offsetY;
			_setXml.appendChild(xml.children());
		}
		private function getBoolean(bolStr:String):Boolean
		{
			if(bolStr=="true")
			{
				return true;
			}
			return false;
		}
		public function gotoPropertiesDefault():void
		{
			setupInfo.paperSelectIndex=0;
			setupInfo.printLayout="ver";
			setCoverSet();
			if(SetupInfo.getInstance().hasGrid)
			{
				SetupInfo.getInstance().printRowNumber=DataMap.getSimple().gridData.length;
				SetupInfo.getInstance().rows=DataMap.getSimple().gridData.length;
				PrintDataMap.getSimple().initData();
				_rowNumMax=_rows;
				InitMap.getSimple().indexFirstEndRows();
				FoldAdvancedGridMap.getSimple().getPagesByFix();
				SetupInfo.getInstance().printTotalPages=SetupInfo.getInstance().colPages*SetupInfo.getInstance().rowPages;
				
			}
			else
			{
				SetupInfo.getInstance().printTotalPages=1;
			}
		}
/**
 * 		直接获取纸张宽度和高度
 * */
		public function getPaperArrays():Array
		{
			var array:Array=[];
			var layout:String=setupInfo._printLayout;
			var index:int=setupInfo._paperSelectIndex;
			var pw:int=setupInfo.paperArray[index].pw;
			var ph:int=setupInfo.paperArray[index].ph;
			array=[pw,ph];
			if(layout=="hor")
			{
				array=[ph,pw];
			}
			return array;
		}
		/** 打印布局方向
		 * landscape 为水平打印
		 * portrait 为垂直打印
		 * */
		public function get printLayout():String
		{
			return _printLayout;
		}

		/**
		 * 打印布局方向
		 */
		public function set printLayout(value:String):void
		{
			_printLayout = value;
		}
		/**
		 * 页脚距离界面高度
		 * */
		public function get printFooterNum():Number
		{
			return _printFooterNum;
		}
		/**
		 * 页脚距离界面高度
		 * */
		public function set printFooterNum(value:Number):void
		{
			_printFooterNum = value;
		}
		/**
		 * 页眉距离界面高度
		 * */
		public function get printHeaderNum():Number
		{
			return _printHeaderNum;
		}
		/**
		 * 页眉距离界面高度
		 * */
		public function set printHeaderNum(value:Number):void
		{
			_printHeaderNum = value;
		}
		/**
		 * 页脚内容
		 * */
		public function get printFooter():String
		{
			return _printFooter;
		}
		/**
		 * 页脚内容
		 * */
		public function set printFooter(value:String):void
		{
			_printFooter = value;
		}

		/**
		 * 页眉内容
		 * */
		public function get printHeader():String
		{
			return _printHeader;
		}

		/**
		 *页眉内容
		 */
		public function set printHeader(value:String):void
		{
			_printHeader = value;
		}

		/**
		 * 
		 *  是否套打*/
		public function get printIsTaoda():Boolean
		{
			return _printIsTaoda;
		}

		/**
		 * 是否套打
		 */
		public function set printIsTaoda(value:Boolean):void
		{
			_printIsTaoda = value;
		}
		
		/**
		 * 打印界面的高度
		 * */
		public function get printPaperHeight():Number
		{
			return _printPaperHeight;
		}
		/**
		 * 打印界面的高度
		 * */
		public function set printPaperHeight(value:Number):void
		{
			_printPaperHeight = value;
		}

		/** 
		 * 打印的界面宽度
		 * */
		public function get printPaperWidth():Number
		{
			return _printPaperWidth;
		}

		/**
		 * 打印界面的宽度
		 */
		public function set printPaperWidth(value:Number):void
		{
			_printPaperWidth = value;
		}

		/**
		 * 右边据
		 * */
		public function get printRight():Number
		{
			return _printRight;
		}
		/**
		 * 右边据
		 * */
		public function set printRight(value:Number):void
		{
			_printRight = value;
		}
		/**
		 * 左边距
		 * */
		public function get printLeft():Number
		{
			return _printLeft;
		}
		/**
		 * 左边距
		 * */
		public function set printLeft(value:Number):void
		{
			_printLeft = value;
		}

		
		/**
		 * 下边距
		 * */
		public function get printBottom():Number
		{
			return _printBottom;
		}
		/**
		 * 下边距
		 * */
		public function set printBottom(value:Number):void
		{
			_printBottom = value;
		}

		/** 
		 * 上边距
		 *  */
		public function get printTop():Number
		{
			return _printTop;
		}

		/**
		 * 上边距
		 */
		public function set printTop(value:Number):void
		{
			_printTop = value;
		}

		/** 
		 * 打印份数
		 * */
		public function get printNumber():int
		{
			return _printNumber;
		}

		/**
		 * 打印份数
		 */
		public function set printNumber(value:int):void
		{
			_printNumber = value;
		}
		/**
		 * 每页打印多少行 默认为8.
		 * */
		public function get printRowNumber():uint
		{
			return _printRowNumber;
		}
		/**
		 * 每页打印多少行 默认为8.
		 * */
		public function set printRowNumber(value:uint):void
		{
			_printRowNumber = value;
		}

		/**
		 * 总共有多少页   根据数据来进行分页不考虑折页等的情况  保留的属性
		 * */

		/**
		 * 初始化的时候纸张大小
		 * */

		/**
		 * 是否打印表头
		 * */
		public function get isPrintHeader():Boolean
		{
			return _isPrintHeader;
		}
		/**
		 * 是否打印表头
		 * */
		public function set isPrintHeader(value:Boolean):void
		{
			_isPrintHeader = value;
		}
		/**
		 * 是否打印表格线
		 * */
		public function get isPrintLines():Boolean
		{
			return _isPrintLines;
		}
		/**
		 * 是否打印表格线
		 * */
		public function set isPrintLines(value:Boolean):void
		{
			_isPrintLines = value;
		}
		/**
		 * 是否逐份打印
		 * */
		public function get isPirntOrder():Boolean
		{
			return _isPirntOrder;
		}
		/**
		 * 是否逐份打印
		 * */
		public function set isPirntOrder(value:Boolean):void
		{
			_isPirntOrder = value;
		}
		/**
		 * 是否补空行
		 * */
		public function get isEmptyRow():Boolean
		{
			return _isEmptyRow;
		}
		/**
		 * 是否补空行
		 * */
		public function set isEmptyRow(value:Boolean):void
		{
			_isEmptyRow = value;
		}

		/**
		 * 打印范围
		 * */
		public function get printRange():Array
		{
			return _printRange;
		}
		/**
		 * 打印范围
		 * */
		public function set printRange(value:Array):void
		{
			_printRange = value;
		}

		/**
		 * 根据折页中的参数来设置的总页数目
		 * */
		public function get printTotalPages():int
		{
			return _printTotalPages;
		}
		/**
		 * 根据折页中的参数来设置的总页数目
		 * */
		public function set printTotalPages(value:int):void
		{
			_printTotalPages = value;
		}
		/**
		 * 折页中是否固定列选择 默认固定列
		 * */
		public function get printFixChangeBol():Boolean
		{
			return _printFixChangeBol;
		}
		/**
		 * 折页中是否固定列选择 默认固定列
		 * */
		public function set printFixChangeBol(value:Boolean):void
		{
			_printFixChangeBol = value;
		}
		/**
		 * 折页中变动方式时  后几页列数
		 * */
		public function get printEndRow():int
		{
			return _printEndRow;
		}
		/**
		 * 折页中变动方式时  后几页列数
		 * */
		public function set printEndRow(value:int):void
		{
			_printEndRow = value;
		}
		/**
		 * 折页中变动方式时  第一页列数
		 * */
		public function get printFirstRow():int
		{
			return _printFirstRow;
		}
		/**
		 * 折页中变动方式时  第一页列数
		 * */
		public function set printFirstRow(value:int):void
		{
			_printFirstRow = value;
		}

		/**
		 * 打印顺序  先行后列  还是先列后行  默认先行后列为true
		 * */
		public function get printRow():Boolean
		{
			return _printRow;
		}

		public function set printRow(value:Boolean):void
		{
			_printRow = value;
		}
		/**
		 * 折页中 固定方式下的变动列的最大值
		 * */

		public function get printFoldMax():int
		{
			return _printFoldMax;
		}

		public function set printFoldMax(value:int):void
		{
			_printFoldMax = value;
		}


		
		

		public function get infor():String
		{
			return _infor;
		}

		public function set infor(value:String):void
		{
			_infor = value;
		}


		/**检测是否有表格　　没有的话不进行任何折页*/
		public function get hasGrid():Boolean
		{
			return _hasGrid;
		}

		/**
		 * @private
		 */
		public function set hasGrid(value:Boolean):void
		{
			_hasGrid = value;
		}

		/** 左右有一个默认的距离*/
		public function get normMagn():int
		{
			return _normMagn;
		}

		/**
		 * @private
		 */
		public function set normMagn(value:int):void
		{
			_normMagn = value;
		}


		
		/**  动态记录表格的高度  用于套打*/
		public function get gridHeight():int
		{
			return _gridHeight;
		}

		/**
		 * @private
		 */
		public function set gridHeight(value:int):void
		{
			_gridHeight = value;
		}
/** 
 * 记录行分页中的当前页数  
 * */
		public function get colCurrentPage():int
		{
			return _colCurrentPage;
		}

		public function set colCurrentPage(value:int):void
		{
			_colCurrentPage = value;
		}
/**
 * 记录列分页中的当前页数
 * */
		public function get rowCurrentPage():int
		{
			return _rowCurrentPage;
		}

		public function set rowCurrentPage(value:int):void
		{
			_rowCurrentPage = value;
		}

/**
 * 根据行来计算的总页数
 * */
		public function get colPages():int
		{
			return _colPages;
		}

		/**
		 * @private
		 */
		public function set colPages(value:int):void
		{
			_colPages = value;
		}

/**
* 根据列来计算的总页数
* */
		public function get rowPages():int
		{
			return _rowPages;
		}

		/**
		 * @private
		 */
		public function set rowPages(value:int):void
		{
			_rowPages = value;
		}
/**
 * 记录表格的所有数据   用于每页打印行数的绑定
 * */
		public function get rows():int
		{
			return _rows;
		}

		public function set rows(value:int):void
		{
			_rows = value;
		}
/**
 * 打印顺序是否先列后行  默认为先列后行
 * */
		public function get rowToCol():Boolean
		{
			return _rowToCol;
		}

		public function set rowToCol(value:Boolean):void
		{
			_rowToCol = value;
		}

/**
 * 实际进行打印时候 检测到的纸张实际打印的宽度
 * */
		public function get pageWidth():int
		{
			return _pageWidth;
		}
		
		public function set pageWidth(value:int):void
		{
			_pageWidth = value;
		}
/**
 * 纸张选择  默认为A4
 * */
		public function get paperType():String
		{
			return _paperType;
		}

		public function set paperType(value:String):void
		{
			_paperType = value;
		}
/**
		 * 保存的打印设置XML
* */
		
		public function get exportPropertiesXml():XML
		{
			return _exportPropertiesXml;
		}

		public function set exportPropertiesXml(value:XML):void
		{
			_exportPropertiesXml = value;
		}
/**
 * 选用的纸张大小的下标
 * */
		public function get paperSelectIndex():int
		{
			return _paperSelectIndex;
		}

		public function set paperSelectIndex(value:int):void
		{
			_paperSelectIndex = value;
		}
/**
 * 打印时最终的一个打印宽度
 * */
		public function get paperRealWidth():int
		{
			return _paperRealWidth;
		}

		public function set paperRealWidth(value:int):void
		{
			_paperRealWidth = value;
		}
/**
 * *打印时最终的一个打印高度
 * */
		public function get paperRealHeight():int
		{
			return _paperRealHeight;
		}

		public function set paperRealHeight(value:int):void
		{
			_paperRealHeight = value;
		}
/**
 * 计算每页显示列数的最大值
 * */
		public function get rowNumMax():int
		{
			return _rowNumMax;
		}

		public function set rowNumMax(value:int):void
		{
			_rowNumMax = value;
		}
/**
 * 表格表头的checkBox选择
 * */
		public function get gridHeadCheckBol():Boolean
		{
			return _gridHeadCheckBol;
		}

		public function set gridHeadCheckBol(value:Boolean):void
		{
			_gridHeadCheckBol = value;
		}
/**
 * 表格是否可以操作
 * */
		public function get gridIsEnable():Boolean
		{
			return _gridIsEnable;
		}

		public function set gridIsEnable(value:Boolean):void
		{
			_gridIsEnable = value;
		}
/**
 * 第一列的最大值
 * */
		public function get printFixMax():int
		{
			return _printFixMax;
		}

		public function set printFixMax(value:int):void
		{
			_printFixMax = value;
		}
/**
 * 是否是连打
 * */
		public function get isContinue():Boolean
		{
			return _isContinue;
		}

		public function set isContinue(value:Boolean):void
		{
			_isContinue = value;
		}
/**
 * 外边框设置线条宽度
 * */
		public function get borderWidth():int
		{
			return _borderWidth;
		}

		public function set borderWidth(value:int):void
		{
			_borderWidth = value;
		}
/**
 * 记录是否存在合计行   有则为1  无则为0
 * */
		public function get isTotalCol():int
		{
			return _isTotalCol;
		}

		public function set isTotalCol(value:int):void
		{
			_isTotalCol = value;
		}
/**
 * 打印时 设置偏离纸张的X的偏移距离
 * */
		public function get offsetX():int
		{
			return _offsetX;
		}

		public function set offsetX(value:int):void
		{
			_offsetX = value;
		}
/**
 * 打印时 设置偏离纸张的Y的偏移距离
 * */
		public function get offsetY():int
		{
			return _offsetY;
		}

		public function set offsetY(value:int):void
		{
			_offsetY = value;
		}
/**
 * 设置每行的行高  并且动态计算是否自动换行。
 * */
		public function get colHeight():int
		{
			return _colHeight;
		}

		public function set colHeight(value:int):void
		{
			_colHeight = value;
		}
/**
 * 初始化的时候获取的设置XML
 * */
		public function get setXml():XML
		{
			return _setXml;
		}

		public function set setXml(value:XML):void
		{
			_setXml = value;
		}
/**
 * 是否是连打  默认为单页打印0
 * 连打为1
 * */
		public function get multiPrintType():int
		{
			return _multiPrintType;
		}

		public function set multiPrintType(value:int):void
		{
			_multiPrintType = value;
		}
/**
 * 初始化所有纸张大小
 * */
		public function get paperArray():ArrayCollection
		{
			return _paperArray;
		}

		public function set paperArray(value:ArrayCollection):void
		{
			_paperArray = value;
		}




	}
}