package com.nova.print.doc
{
	import com.nova.print.map.DataMap;
	import com.nova.print.map.LayoutMap;
	import com.nova.print.map.PrintMap;
	import com.nova.print.util.SetupInfo;
	
	import flash.printing.PrintJob;

/**
 * 此类为连续打印的操作类.
 * */
	public class PrintContinuous
	{
		private var _lauoutXmls:XML=null;
		private var _dataXmls:XML=null;
		private var _proXml:XML=null;
		private static var pc:PrintContinuous=null;
		public static function getPc():PrintContinuous
		{
			if(pc==null)
			{
				pc=new PrintContinuous();
			}
			return pc;
		}
		public function loadAllXml(_xml:XML):void
		{
			var job:PrintJob=new PrintJob();
			if(job.start())
			{
				for(var i:int=0;i<_xml.children().length();i++)
				{
					var items:XML=_xml.children()[i] as XML;
					var layout:XML=new XML(items.Layouts);
					var data:XML=new XML(items.Data);
					trace("界面Xml:  "+items.Layouts);
					trace("数据Xml:  "+items.Data);
					LayoutMap.getSimple().setLayout(layout);
					DataMap.getSimple().setData(data);
					SetupInfo.getInstance().gotoPropertiesDefault();
					gotoPrint(job);
				}
			}
			
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
		public function get lauoutXmls():XML
		{
			return _lauoutXmls;
		}

		public function set lauoutXmls(value:XML):void
		{
			_lauoutXmls = value;
		}
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


	}
}