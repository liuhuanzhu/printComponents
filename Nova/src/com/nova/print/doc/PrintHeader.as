package com.nova.print.doc
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.nova.print.map.DataMap;
	import com.nova.print.map.LayoutMap;
	import com.nova.print.util.SetupInfo;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.controls.Alert;
	import mx.messaging.channels.StreamingAMFChannel;

	public class PrintHeader extends Sprite
	{
		
		
		public function creatHeader(_w:int):void
		{
			var array:Array=LayoutMap.getSimple().headingArray;
			if(array==null) return;
			var textFormat:TextFormat=new TextFormat();
			textFormat.size=14;
			textFormat.font="SONG";
			for(var i:int=0;i<array.length;i++)
			{
				var text:TextField=new TextField();
				var txt:String=array[i][0];
				var size:String=array[i][1];
				var id:String=array[i][3];
				var idTxt:String=findById(id);
				var yy:Number=Number(array[i][2]);
				if(size.length>0)
				{
					textFormat.size=size;
				}
				if(idTxt.length!=0)
				{
					text.text=idTxt;
				}
				else if(txt.length!=0)
				{
					text.text=txt;
				}
				else
				{
					text.text="";
				}
				textFormat.align=TextFormatAlign.CENTER;
				text.setTextFormat(textFormat);
				text.embedFonts=true;
				//text.border=true;
				//text.borderColor=0x000000;
				var marginTop:int=SetupInfo.getInstance().printTop;
				var headNum:int=SetupInfo.getInstance().printHeaderNum;
				yy+=marginTop+headNum;
				text.y=yy;
				text.width=_w;
				this.addChild(text);
				trace("加载标题的宽度为:   "+text.width);
			}
		}
		private function findById(ID:String):String
		{
			if(ID==null) return "";
			var text:String="";
			for(var i:int=0;i<DataMap.getSimple().tfData.length;i++)
			{
				var obj:Object=DataMap.getSimple().tfData.getItemAt(i);
				if(obj.id==ID)
				{
					text=obj.text;
				}
			}
			return text;
		}


	}
}