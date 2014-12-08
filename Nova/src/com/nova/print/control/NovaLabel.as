package com.nova.print.control
{
	import com.nova.print.map.DataMap;
	import com.nova.print.map.LayoutMap;
	import com.nova.print.util.SetupInfo;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import flashx.textLayout.formats.TextAlign;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.messaging.channels.StreamingAMFChannel;
	
	import spark.components.BorderContainer;
	import spark.components.Label;

	public class NovaLabel extends Sprite
	{
		private static var novaLabel:NovaLabel=null;
		private var layoutXml:XML=null;
		private var dataArr:ArrayCollection=null;
		public static function getInstance():NovaLabel
		{
			if(novaLabel==null)
			{
				novaLabel=new NovaLabel();
			}
			return novaLabel;
		}
		/** 所有的上部Label解析创建*/
		public function creatLabel(type:String):void
		{
			if(type=="top")
			{
				layoutXml=LayoutMap.getSimple().topXml;
			}
			else
			{
				layoutXml=LayoutMap.getSimple().bottomXml;
			}
			dataArr=DataMap.getSimple().tfData;
			for(var i:int=0;i<layoutXml.children().length();i++)
			{
				var xxx:XML=layoutXml.children()[i] as XML;
				var By:int=int(xxx.@y)+SetupInfo.getInstance().printTop;
				var str:String=xxx.@text;
				var text:TextField=new TextField();
				text.name=xxx.@id;
				text.mouseEnabled=false;
				if(str.length==0)
				{
					text.text=findById(text.name);
				}
				else
				{
					text.text=xxx.@text;
				}
/*				if(size.length!=0)
				{
					text.defaultTextFormat=getHeadFormat();
				}
				else
				{
					text.defaultTextFormat=getDefaultFormat();
				}*/
				text.defaultTextFormat=getDefaultFormat();
				text.width=xxx.@width;
				text.x=xxx.@x;
				trace("加载的文本: "+text.x+"------->>"+text.text+"-------->>"+text.name+"-----"+text.defaultTextFormat.size+"---------type:"+type);
				text.y=By;
				//text.autoSize=TextFieldAutoSize.LEFT;
				this.addChild(text);
			}
		}
		public function findById(strId:String):String
		{
			var str:String="";
			for(var i:int=0;i<dataArr.length;i++)
			{
				var obj:Object=dataArr[i] as Object;
				if(obj.id==strId)
				{
					str=obj.text;
				}
			}
			return str;
		}
		private function getDefaultFormat():TextFormat
		{
			var txtFormat:TextFormat=new TextFormat();
			txtFormat.size=11;
			txtFormat.align="left";
			return txtFormat;
		}
		private function getHeadFormat():TextFormat
		{
			var txtFormat:TextFormat=new TextFormat();
			txtFormat.size=25;
			txtFormat.align="left";
			return txtFormat;
		}
	}
}