package com.nova.print.doc
{
	import com.nova.print.map.DataMap;
	import com.nova.print.map.LayoutMap;
	import com.nova.print.map.PrintMap;
	import com.nova.print.util.PrintUtil;
	import com.nova.print.util.SetupInfo;
	
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.printing.PrintJob;
	
	import mx.printing.PrintDataGrid;

/**
 * 此类为连续打印的操作类.
 * */
	public class PrintMultiResolve
	{
		private var _layoutXmls:XML=null;
		private var _dataXmls:XML=null;
		private var _proXml:XML=null;
		private static var instance:PrintMultiResolve=null;
		private var printSpriteArr:Array=[];
		public static function getPc():PrintMultiResolve
		{
			if(instance==null)
			{
				instance=new PrintMultiResolve();
			}
			return instance;
		}
		public function getLayouts(_xml:XML):void
		{
			_layoutXmls=_xml;
		}
		public function getData(_xml:XML):void
		{
			_dataXmls=_xml;
		}
		public function getProperties(_xml:XML):void
		{
			_proXml=_xml;
		}
		public function resolveXmls():void
		{
			printSpriteArr=[];
			var printJob:PrintJob=new PrintJob();
			if(printJob.start())
			{
				for(var i:int=0;i<_layoutXmls.children().length();i++)
				{
					var lx:XML=_layoutXmls.children()[i] as XML;
					var dx:XML=_dataXmls.children()[i] as XML;
					var px:XML=_proXml.children()[i] as XML;
					LayoutMap.getSimple().setLayout(lx);
					DataMap.getSimple().setData(dx);
					if(String(px.paperWidthSize).length>1)
					{
						SetupInfo.getInstance().getProperties(px);
					}
					else
					{
						SetupInfo.getInstance().gotoPropertiesDefault();
					}
					SetupInfo.getInstance().paperRealWidth=printJob.pageWidth;
					SetupInfo.getInstance().paperRealHeight=printJob.pageHeight;
					if(!SetupInfo.getInstance().hasGrid)
					{
						SetupInfo.getInstance().colPages=1;
						SetupInfo.getInstance().rowPages=1;
					}
					var array:Array=PrintMap.getSimple().getPrintRange();
					printSpriteArr=printSpriteArr.concat(array);
				}
				for(var j:int=0;j<printSpriteArr.length;j++)
				{
					var doc:PrintDoc=printSpriteArr[j] as PrintDoc;
					printJob.addPage(doc);
				}
				trace("printSpriteArr:  "+printSpriteArr.length);
				//trace("layouts:  "+_layoutXmls);
				//trace("data:  "+_dataXmls);
				//trace("set:  "+_proXml);
				//trace("coverset:  "+PrintUtil.getSimple().coverSetXml);
			}
			printJob.send();
			ExternalInterface.call("closePrint"); 
		}
		private function gotoPrint(printJob:PrintJob):void
		{
			//打印机出现的是磅  需要转化为像素
			SetupInfo.getInstance().paperRealWidth=printJob.pageWidth;
			SetupInfo.getInstance().paperRealHeight=printJob.pageHeight;
			if(!SetupInfo.getInstance().hasGrid)
			{
				SetupInfo.getInstance().colPages=1;
				SetupInfo.getInstance().rowPages=1;
			}
			var array:Array=PrintMap.getSimple().getPrintRange();
			for(var i:int=0;i<array.length;i++)
			{
				var sprite:PrintDoc=array[i] as PrintDoc;
				printJob.addPage(sprite);
			}
		}
		
/**
 * 存储所有的界面xml
 * */
		
/**
 * 存储所有的数据xml
 * */
		public function get dataXmls():XML
		{
			return _dataXmls;
		}

		public function set dataXmls(value:XML):void
		{
			_dataXmls = value;
		}

		public function get proXml():XML
		{
			return _proXml;
		}

		public function set proXml(value:XML):void
		{
			_proXml = value;
		}

		public function get layoutXmls():XML
		{
			return _layoutXmls;
		}

		public function set layoutXmls(value:XML):void
		{
			_layoutXmls = value;
		}


	}
}