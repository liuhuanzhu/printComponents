package com.nova.print.map
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;

	/**
	 * 此类定义特殊情况下的坐标，用于调试
	 * */
	public class LocalGridMap
	{
		private static var it:LocalGridMap=null;
		private var loader:URLLoader=null;
		public var xml:XML=null;
		public static function getInstance():LocalGridMap
		{
			if(it==null)
			{
				it=new LocalGridMap();
			}
			return it;
		}
		public function loadXml():void
		{
			loader=new URLLoader(new URLRequest("../printLocal"));
			loader.addEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
		}
		
		private function loadCompleteHandler(e:Event):void
		{
			xml=new XML(e.target.data);
			var arr:Array=[];
			for(var i:int=0;i<xml.children().length();i++)
			{
				var xx:XML=xml.children()[i] as XML;
				arr.push([int(xx.@x),int(xx.@y)]);
			}
			//Alert.show("更改后的坐标: "+arr);
			trace("arr:------------------------------------------------->"+arr);
			loader.removeEventListener(Event.COMPLETE,loadCompleteHandler);
		}
		private function loadErrorHandler(e:IOErrorEvent):void
		{
			Alert.show("加载失败"+e.text);
		}
	}
}