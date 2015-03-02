package com.nova.print.map
{
	import com.nova.print.util.SetupInfo;
	
	import mx.containers.Grid;
	import mx.controls.Alert;

	/**
	 * 此类解析传递过来的界面XML
	 * 上部分XML,下部分XML,表格XML分别进行保存。 
	 * */
	public class LayoutMap
	{
		private var _topXml:XML=null;
		private var _bottomXml:XML=null;
		private var _gridXml:XML=null;
		private var _layoutXml:XML=null;
		private var _declarationsXml:XML=null;
		private var _headingArray:Array=null;
		private var _headerXml:XML=null;
		private var _gridType:int=0;
		private static var _simple:LayoutMap=null;
		private var _allColumnIndex:int=0;
	
		public static function getSimple():LayoutMap
		{
			if(_simple==null)
			{
				_simple=new LayoutMap();
			}
			return _simple;
		}
/**
 * 此方法用于解析所有界面的接口
 * 界面xml分别进行保存
 * */
		public function setLayout(xml:XML):void
		{
			this.initialState();
			_layoutXml=xml;
			_allColumnIndex=0;
			for(var i:int=0;i<xml.children().length();i++)
			{
				var xx:XML=xml.children()[i] as XML;
				if(xx.localName()=="BorderContainer")
				{
					if(xx.@id=="top")
					{
						_topXml=xx;
					}
					else
					{
						_bottomXml=xx;
					}
				}
				else if(xx.localName()=="Label")
				{
					creatHeader(xx);
				}
				else if(xx.localName()=="Grids")
				{
					creatGridsXml(xx);
				}
				else if(xx.localName()=="Declarations")
				{
					creatDeclarationsXml(xx);
				}
			}
			if(_bottomXml==null)
			{
				_bottomXml= new XML(<BorderContainer x="0" y="0" id="bottom"/>);
			}
			if(_topXml==null)
			{
				_topXml= new XML(<BorderContainer x="0" y="0" id="top"/>);
			}
			if(_declarationsXml==null)
			{
				_declarationsXml= new XML(<Declarations></Declarations>);
			}
			layoutTrace();
		}
		private function creatHeader(xx:XML):void
		{
			if(_headingArray==null)
			{
				_headingArray=[];
			}
			if(_headerXml==null)
			{
				_headerXml=<header></header>;
			}
			_headerXml.appendChild(xx);
			_headingArray.push([xx.@text,xx.@fontSize,xx.@y,xx.@id]);
		}
		private function creatGridsXml(xx:XML):void
		{
			SetupInfo.getInstance().hasGrid=true;
			_gridXml=xx;
			for(var j:int=0;j<xx.children().length();j++)
			{
				var xxx:XML=xx.children()[j] as XML;
				if(xxx.localName()=="column")
				{
					var visible:String=xxx.@visible;
					if(visible!="false")
					{
						_allColumnIndex++;
						PrintMap.getSimple().creatRecordDataFieldArray(xxx.@dataField,xxx.@width);
						PrintMap.getSimple().recordSpacing.push(xxx.@dataField,xxx.@letterSpace);
					}
				}
				else
				{
					_gridType=1;
					for(var k:int=0;k<xxx.children().length();k++)
					{
						var xxxx:XML=xxx.children()[k] as XML;
						var groupVisible:String=xxxx.@visible;
						if(groupVisible!="false")
						{
							_allColumnIndex++;
							PrintMap.getSimple().creatRecordDataFieldArray(xxxx.@dataField,xxxx.@width);
							PrintMap.getSimple().recordSpacing.push(xxxx.@dataField,xxxx.@letterSpace);
						}
					}
				}
			}
		}
/**
 * 界面解析数据的输出
 * */
		private function layoutTrace():void
		{
			trace("/****************************************************解析数据的输出********************************")	;
			trace("top: "+_topXml);
			trace("grids: "+_gridXml);
			trace("bottom: "+_bottomXml);
			trace("_declarationsXml: "+_declarationsXml);
			trace("header: "+headingArray);
			trace("/****************************************************解析数据的输出********************************end")	;
		}
		private function creatDeclarationsXml(xx:XML):void
		{
			_declarationsXml=xx;
		}
/**
 * 所有数据恢复到初始状态
 * */		
		private function initialState():void
		{
			_topXml=null;
			_bottomXml=null;
			_gridXml=null;
			_layoutXml=null;
			_declarationsXml=null;
			_headingArray=null;
			_headerXml=null;
			_gridType=0;
			_allColumnIndex=0;
		}
		
/**
 * 操作项表格属性中的操作列是否显示
 * 根据gridType不同来分别解析操作
 * */
		public function findHeaderVisible(headText:String,unique:String):void
		{
			if(_gridType==0)
			{
				findGridVisible(headText);
			}
			else
			{
				findAdvGridVisible(headText,unique);
			}
		}
/**
 *此方法用来更新表格列的visible属性。
 * 用于保存和表格界面显示 
*/
		private  function findGridVisible(headText:String):void
		{
			for(var i:int=0;i<_gridXml.children().length();i++)
			{
				var xx:String=_gridXml.children()[i].@headerText;
				var width:int=_gridXml.children()[i].@width;
				var textAlign:String=_gridXml.children()[i].@textAlign;
				var vi:String=_gridXml.children()[i].@visible;
				if(xx==headText)
				{
					if(vi=="false")
					{
						vi="true";
					}
					else
					{
						vi="false";
					}
				}
				_gridXml.children()[i].@visible=vi;
			}
		}
/**
 *此方法用来更新表格列的visible属性。  此方法操作的复杂表格
 * 用于保存和表格界面显示 
 */
		private function findAdvGridVisible(headText:String,unique:String):void
		{
			for(var i:int=0;i<_gridXml.children().length();i++)
			{
				var xml:XML=_gridXml.children()[i] as XML;
				if(xml.children().length()==0)
				{
					var headerParent:String=xml.@headerText;
					var viParent:String=xml.@visible;
					var xmlUnique:String=xml.@unique;
					if(headText==headerParent && xmlUnique==unique)
					{
						if(viParent=="false")
						{
							viParent="true";
						}
						else
						{
							viParent="false";
						}
						_gridXml.children()[i].@visible=viParent;
					}
				}
				else
				{
					for(var j:int=0;j<xml.children().length();j++)
					{
						var xxx:XML=xml.children()[j] as XML;
						var headerSon:String=xxx.@headerText;
						var viSon:String=xxx.@visible;
						var xxxUnique:String=xxx.@unique;
						if(headText==headerSon && xxxUnique==unique)
						{
							if(viSon=="false")
							{
								viSon="true";
							}
							else
							{
								viSon="false";
							}
							_gridXml.children()[i].children()[j].@visible=viSon;
						}
					}
				}
			}
			trace("更改后的Xml： "+_gridXml);
		}
		public function gridVisibleAll():void
		{
			var xml:XML=new XML();
			if(_gridType==0)
			{
				xml=_gridXml;
			}
			else
			{
				xml=_gridXml;
			}
			for(var i:int=0;i<xml.children().length();i++)
			{
				var xx:XML=xml.children()[i] as XML;
				if(xx.children().length()>0)
				{
					for(var j:int=0;j<xx.children().length();j++)
					{
						var xxx:XML=xx.children()[j] as XML;
						xxx.@visible="true";
					}
				}
				else
				{
					xx.@visible="true";
				}
			}
		}
/**
 * 获取上部分的X坐标
 * */
		public function getTopX():int
		{
			var topX:int=0;
			topX=int(_topXml.@x);
			return topX;
		}
/**
 * 获取上部分的Y坐标
 * */
		public function getTopY():int
		{
			var topY:int=0;
			topY=int(_topXml.@y);
			return topY;
		}
/**
 * 获取下部分的X坐标
 * */
		public function getBottomX():int
		{
			var bottomX:int=0;
			bottomX=int(_bottomXml.@x);
			return bottomX;
		}
/**
 * 获取下部分的Y坐标   此时的Y坐标应该是创建后的表格高度加上表格的Y坐标   
 * 在这里获取无意义。
 * */
		public function getBottomY():int
		{
			return 0;
		}
/**
 * 获取表格的X坐标    打印的时候默认左侧像素距离最坐标30px。
 * 默认设置表格x坐标没意义。2014.7.7
 * */
		public function getGridX():int
		{
			if(_gridXml==null &&  _gridXml==null)
			{
				return 0;
			}
			return 0;
			if(_gridType==0)
			{
				return int(_gridXml.@x);
			}
			else
			{
				return int(_gridXml.@x);
			}
			return 0;
		}
/**
 * 获取表格的Y坐标
 * */
		public function getGridY():int
		{
			if(_gridXml==null &&  _gridXml==null)
			{
				return 0;
			}
			if(_gridType==0)
			{
				return int(_gridXml.@y);
			}
			else
			{
				return int(_gridXml.@y);
			}
			return 0;
		}
		public function get topXml():XML
		{
			return _topXml;
		}

		public function set topXml(value:XML):void
		{
			_topXml = value;
		}

		public function get bottomXml():XML
		{
			return _bottomXml;
		}

		public function set bottomXml(value:XML):void
		{
			_bottomXml = value;
		}

		public function get gridXml():XML
		{
			return _gridXml;
		}

		public function set gridXml(value:XML):void
		{
			_gridXml = value;
		}

		public function get layoutXml():XML
		{
			return _layoutXml;
		}

		public function set layoutXml(value:XML):void
		{
			_layoutXml = value;
		}
/**
 * 保存其他属性
 * */
		public function get declarationsXml():XML
		{
			return _declarationsXml;
		}

		public function set declarationsXml(value:XML):void
		{
			_declarationsXml = value;
		}
/**
 * 标识区别表格或者多表头表格的属性
 * 0为单表格
 * 1为多表头表格
 * */
		public function get gridType():int
		{
			return _gridType;
		}

		public function set gridType(value:int):void
		{
			_gridType = value;
		}
/**
 * 只有一次  默认初始化没有设置的时候  进行初始化  固定列和变动列
 * */
		public function get allColumnIndex():int
		{
			return _allColumnIndex;
		}

		public function set allColumnIndex(value:int):void
		{
			_allColumnIndex = value;
		}

		public function get headingArray():Array
		{
			return _headingArray;
		}
		
		public function set headingArray(value:Array):void
		{
			_headingArray = value;
		}
/*
 * Layout 头部标题xml
		*/
		public function get headerXml():XML
		{
			return _headerXml;
		}

		public function set headerXml(value:XML):void
		{
			_headerXml = value;
		}


	}
}