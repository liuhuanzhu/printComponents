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
		private var _coverSetXml:XML=null;
		private var type:int=0;
		private var _loader:URLLoader=null;
		private var version:int;
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
			_loader.load(new URLRequest("assets/file/coverSet.xml"));
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
					_coverSetXml=new XML(event.target.data);
					if(version==1)
					{
						trace("继续加载");
						_loader.load(new URLRequest("assets/file/printLayout.xml"));
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
					_loader.load(new URLRequest("assets/file/printData.xml"));
					_loader.addEventListener(Event.COMPLETE,loadCompleteHandler);
					break;
				}
				case 3:
				{
					_loader.removeEventListener(Event.COMPLETE,loadCompleteHandler);
					_dataXml=new XML(event.target.data);
					_loader.load(new URLRequest("assets/file/printSet.xml"));
					_loader.addEventListener(Event.COMPLETE,loadCompleteHandler);
					break;
				}
				case 4:
				{
					_loader.removeEventListener(Event.COMPLETE,loadCompleteHandler);
					_settingXml=new XML(event.target.data);
					_settingXml.appendChild(_coverSetXml.children());
					break;
				}
			}
			if(type==4)
			{
				trace("coveSetXml:  "+_coverSetXml);
				trace("LayoutXml:  "+_layoutXml);
				trace("DataXml:  "+_dataXml);
				trace("SetXml:  "+_settingXml);
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

		public function get coverSetXml():XML
		{
			return _coverSetXml;
		}

		public function set coverSetXml(value:XML):void
		{
			_coverSetXml = value;
		}


	}
}