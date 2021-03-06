package com.nova.print.util
{
	import com.nova.print.event.PrintEvents;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;

	public class PrintUtil extends Sprite
	{
		private static  var _simple:PrintUtil=null;
		private var _layoutXml:XML=null;
		private var _dataXml:XML=null;
		private var _settingXml:XML=null;
		private var type:int=0;
		private var _loader:URLLoader=null;
		private var version:int;
		private var coverSetUrl:String;
		private var layoutUrl:String;
		private var dataUrl:String;
		private var setUrl:String;
		public function PrintUtil()
		{
			
		}
		public static function getSimple():PrintUtil
		{
			if(_simple==null)
			{
				_simple=new PrintUtil();
			}
			return _simple;
		}
		
		public function startLoad(_version:int):void
		{
			if(_loader==null)
			{
				_loader=new URLLoader();
			}
			version=_version;
			coverSetUrl=SetupInfo.getInstance().multiPrintType==0?"assets/file/coverSet.xml":"assets/file/coverSets.xml";
			layoutUrl=SetupInfo.getInstance().multiPrintType==0?"assets/file/printLayout.xml":"assets/file/printLayouts.xml";
			dataUrl=SetupInfo.getInstance().multiPrintType==0?"assets/file/printData.xml":"assets/file/printDatas.xml";
			setUrl=SetupInfo.getInstance().multiPrintType==0?"assets/file/printSet.xml":"assets/file/printSets.xml";
			_loader.load(new URLRequest(coverSetUrl));
			_loader.addEventListener(Event.COMPLETE,loadCompleteHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
		}
		private function loadCompleteHandler(event:Event):void
		{
			type++;
			switch(type)
			{
				case 1:
				{
					_loader.removeEventListener(Event.COMPLETE,loadCompleteHandler);
					if(version==1)
					{
						trace("继续加载");
						_loader.load(new URLRequest(layoutUrl));
						_loader.addEventListener(Event.COMPLETE,loadCompleteHandler);
					}
					else
					{
						trace("停止加载");
						_loader=null;
						this.dispatchEvent(new PrintEvents(PrintEvents.PrintChange));
						return;
					}
					break;
				}
				case 2:
				{
					_loader.removeEventListener(Event.COMPLETE,loadCompleteHandler);
					_layoutXml=new XML(event.target.data);
					_loader.load(new URLRequest(dataUrl));
					_loader.addEventListener(Event.COMPLETE,loadCompleteHandler);
					break;
				}
				case 3:
				{
					_loader.removeEventListener(Event.COMPLETE,loadCompleteHandler);
					_dataXml=new XML(event.target.data);
					_loader.load(new URLRequest(setUrl));
					_loader.addEventListener(Event.COMPLETE,loadCompleteHandler);
					break;
				}
				case 4:
				{
					_loader.removeEventListener(Event.COMPLETE,loadCompleteHandler);
					_settingXml=new XML(event.target.data);
					break;
				}
			}
			if(type==4)
			{
				//trace("coveSetXml:  "+_coverSetXml);
				//trace("LayoutXml:  "+_layoutXml);
				//trace("DataXml:  "+_dataXml);
				//trace("SetXml:  "+_settingXml);
				this.dispatchEvent(new PrintEvents(PrintEvents.PrintChange));
				
			}
			
		}
		private function loadErrorHandler(event:IOErrorEvent):void
		{
			Alert.show("加载失败"+"|"+event.text);
		}

		public function get layoutXml():XML
		{
			return _layoutXml;
		}

		public function set layoutXml(value:XML):void
		{
			_layoutXml = value;
		}

		public function get dataXml():XML
		{
			return _dataXml;
		}

		public function set dataXml(value:XML):void
		{
			_dataXml = value;
		}

		public function get settingXml():XML
		{
			return _settingXml;
		}

		public function set settingXml(value:XML):void
		{
			_settingXml = value;
		}



	}
}