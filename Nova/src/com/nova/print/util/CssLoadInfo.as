package com.nova.print.util
{
	import com.nova.print.google.css.CSSLoader;
	
	import flash.events.Event;
	
	import mx.managers.CursorManager;
	

	public class CssLoadInfo
	{
		private static var cssLoadInfo:CssLoadInfo=null;
		
		public var cssLoad:CSSLoader=null;
		public function CssLoadInfo()
		{
			cssLoad=new CSSLoader();
		}
		public static function getInstance():CssLoadInfo
		{
			if(cssLoadInfo==null)
			{
				cssLoadInfo=new CssLoadInfo();
			}
			return cssLoadInfo;
		}
		public function Load(url:String,args:Object):void
		{
			cssLoad.load(url,"newCss",args);
			cssLoad.addEventListener(CSSLoader.RESULT,cssLoadResult);
			cssLoad.addEventListener(CSSLoader.LOAD_INIT,cssLoadStart);
		}
		private function cssLoadResult(event:Event):void
		{
			trace("加载成功");
			CursorManager.removeBusyCursor();
		}
		private function cssLoadStart(event:Event):void
		{
			trace("加载失败");
			CursorManager.setBusyCursor();
		}
	}
}